---
title: Scaling Managed Agents: Decoupling the brain from the hands
source: https://www.anthropic.com/engineering/managed-agents
author: Lance Martin, Gabe Cemaj, Michael Cohen
date: 2026-04-08
---

# Scaling Managed Agents: Decoupling the brain from the hands

> Harnesses encode assumptions that go stale as models improve. Managed Agents—our hosted service for long-horizon agent work—is built around interfaces that stay stable as harnesses change.

## Overview

A running topic on the Engineering Blog is how to build effective agents and design harnesses for long-running work. A common thread across this work is that harnesses encode assumptions about what Claude can't do on its own. However, those assumptions need to be frequently questioned because they can go stale as models improve.

### The Bitter Lesson

As just one example, in prior work we found that Claude Sonnet 4.5 would wrap up tasks prematurely as it sensed its context limit approaching—a behavior sometimes called "context anxiety." We addressed this by adding context resets to the harness. But when we used the same harness on Claude Opus 4.5, we found that the behavior was gone. The resets had become dead weight.

We expect harnesses to continue evolving. So we built Managed Agents: a hosted service in the Claude Platform that runs long-horizon agents on your behalf through a small set of interfaces meant to outlast any particular implementation—including the ones we run today.

## The Virtualization Pattern

Building Managed Agents meant solving an old problem in computing: how to design a system for "programs as yet unthought of." Decades ago, operating systems solved this problem by virtualizing hardware into abstractions—process, file—general enough for programs that didn't exist yet. The abstractions outlasted the hardware. The `read()` command is agnostic as to whether it's accessing a disk pack from the 1970s or a modern SSD. The abstractions on top stayed stable while the implementations underneath changed freely.

Managed Agents follow the same pattern. We virtualized the components of an agent:

| Component | Definition |
|-----------|------------|
| Session | The append-only log of everything that happened |
| Harness | The loop that calls Claude and routes Claude's tool calls to the relevant infrastructure |
| Sandbox | An execution environment where Claude can run code and edit files |

This allows the implementation of each to be swapped without disturbing the others. We're opinionated about the shape of these interfaces, not about what runs behind them.

## Don't Adopt a Pet

We started by placing all agent components into a single container, which meant the session, agent harness, and sandbox all shared an environment. There were benefits to this approach, including that file edits are direct syscalls, and there were no service boundaries to design.

But by coupling everything into one container, we ran into an old infrastructure problem: we'd adopted a **pet**. In the pets-vs-cattle analogy:

| Type | Definition | Characteristics |
|------|------------|-----------------|
| Pet | Named, hand-tended individual | Can't afford to lose, need to nurse back to health |
| Cattle | Interchangeable | Can fail and be replaced |

In our case, the server became that pet; if a container failed, the session was lost. If a container was unresponsive, we had to nurse it back to health.

### Debugging Problems

Nursing containers meant debugging unresponsive stuck sessions. Our only window in was the WebSocket event stream, but that couldn't tell us where failures arose—which meant that a bug in the harness, a packet drop in the event stream, or a container going offline all presented the same.

### Deployment Constraints

A second issue was that the harness assumed that whatever Claude worked on lived in the container with it. When customers asked us to connect Claude to their virtual private cloud, they had to either peer their network with ours, or run our harness in their own environment. An assumption baked into the harness became a deployment constraint for customers.

## Decouple the Brain from the Hands

The solution we arrived at was to decouple:

| Component | Role | Interface |
|-----------|------|-----------|
| Brain | Claude and its harness | Calls hands as tools |
| Hands | Sandboxes and tools that perform actions | `execute(name, input) → string` |
| Session | The log of session events | `getSession(id)` |

Each became an interface that made few assumptions about the others, and each could fail or be replaced independently.

### The Harness Leaves the Container

Decoupling the brain from the hands meant the harness no longer lived inside the container. It called the container the way it called any other tool: `execute(name, input) → string`. The container became cattle.

If the container died, the harness caught the failure as a tool-call error and passed it back to Claude. If Claude decided to retry, a new container could be reinitialized with a standard recipe: `provision({resources})`. We no longer had to nurse failed containers back to health.

### Recovering from Harness Failure

The harness also became cattle. Because the session log sits outside the harness, nothing in the harness needs to survive a crash. When one fails, a new one can be rebooted with:

1. `wake(sessionId)`
2. `getSession(id)` to get back the event log
3. Resume from the last event

During the agent loop, the harness writes to the session with `emitEvent(id, event)` in order to keep a durable record of events.

### The Security Boundary

In the coupled design, any untrusted code that Claude generated was run in the same container as credentials—so a prompt injection only had to convince Claude to read its own environment. Once an attacker has those tokens, they can spawn fresh, unrestricted sessions and delegate work to them.

**The structural fix**: make sure the tokens are never reachable from the sandbox where Claude's generated code runs.

Two patterns for this:

| Pattern | Mechanism |
|---------|-----------|
| Auth bundled with resource | Git repo's access token to clone during sandbox initialization, wire into local git remote |
| Vault outside sandbox | MCP tools store OAuth tokens in secure vault, Claude calls via dedicated proxy |

The harness is never made aware of any credentials.

## The Session is Not Claude's Context Window

Long-horizon tasks often exceed the length of Claude's context window, and the standard ways to address this all involve irreversible decisions about what to keep. We've explored these techniques in prior work on context engineering:

| Technique | Mechanism |
|-----------|-----------|
| Compaction | Claude saves a summary of its context window |
| Memory tool | Claude writes context to files, enabling learning across sessions |
| Context trimming | Selectively removes tokens such as old tool results or thinking blocks |

In Managed Agents, the session provides this same benefit, serving as a context object that lives outside Claude's context window. But rather than be stored within the sandbox or REPL, context is durably stored in the session log.

The interface, `getEvents()`, allows the brain to interrogate context by selecting positional slices of the event stream. The interface can be used flexibly:

- Pick up from wherever it last stopped reading
- Rewinding a few events before a specific moment to see the lead up
- Rereading context before a specific action

Any fetched events can also be transformed in the harness before being passed to Claude's context window. These transformations can be whatever the harness encodes, including context organization to achieve a high prompt cache hit rate and context engineering.

We separated the concerns of recoverable context storage in the session and arbitrary context management in the harness because we can't predict what specific context engineering will be required in future models.

## Many Brains

Decoupling the brain from the hands solved one of our earliest customer complaints. When teams wanted Claude to work against resources in their own VPC, the only path was to peer their network with ours, because the container holding the harness assumed every resource sat next to it. Once the harness was no longer in the container, that assumption went away.

### TTFT Improvement

The same change had a performance payoff. When we initially put the brain in a container, it meant that many brains required as many containers. For each brain, no inference could happen until that container was provisioned; every session paid the full container setup cost up front.

**Time-to-first-token (TTFT)** measures how long a session waits between accepting work and producing its first response token. TTFT is the latency the user most acutely feels.

Decoupling the brain from the hands means that containers are provisioned by the brain via a tool call (`execute(name, input) → string`) only if they are needed. So a session that didn't need a container right away didn't wait for one.

| Metric | Improvement |
|--------|-------------|
| p50 TTFT | Roughly 60% drop |
| p95 TTFT | Over 90% drop |

Scaling to many brains just meant starting many stateless harnesses, and connecting them to hands only if needed.

## Many Hands

We also wanted the ability to connect each brain to many hands. In practice, this means Claude must reason about many execution environments and decide where to send work—a harder cognitive task than operating in a single shell.

We started with the brain in a single container because earlier models weren't capable of this. As intelligence scaled, the single container became the limitation instead: when that container failed, we lost state for every hand that the brain was reaching into.

Decoupling the brain from the hands makes each hand a tool: `execute(name, input) → string`—a name and input go in, and a string is returned.

That interface supports:
- Any custom tool
- Any MCP server
- Our own tools

The harness doesn't know whether the sandbox is a container, a phone, or a Pokémon emulator. And because no hand is coupled to any brain, brains can pass hands to one another.

## Conclusion

The challenge we faced is an old one: how to design a system for "programs as yet unthought of." Operating systems have lasted decades by virtualizing the hardware into abstractions general enough for programs that didn't exist yet.

With Managed Agents, we aimed to design a system that accommodates future harnesses, sandboxes, or other components around Claude.

**Meta-harness design**: being opinionated about the interfaces around Claude, not about the specific implementations:

| Interface | Purpose |
|-----------|---------|
| Session | Durable, recoverable context storage |
| Sandbox | Perform computation |
| Harness | Context management, tool routing |

We designed the interfaces so that these can be run reliably and securely over long time horizons. But we make no assumptions about the number or location of brains or hands that Claude will need.

> The space of interesting harness combinations doesn't shrink as models improve. Instead, it moves.

## Acknowledgements

Written by Lance Martin, Gabe Cemaj, and Michael Cohen. Thanks to Nodir Turakulov and Jeremy Fox for helpful conversations on these topics. Special thanks to the Agents API team and Jake Eaton for their contributions.