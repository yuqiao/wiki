# The Anatomy of an Agent Harness

> 来源：https://www.langchain.com/blog/the-anatomy-of-an-agent-harness
> 抓取日期：2026-04-26
> 作者：Vivek Trivedy
> 发布日期：March 10, 2026

## 核心定义

**Agent = Model + Harness**

> If you're not the model, you're the harness.

A harness is every piece of code, configuration, and execution logic that isn't the model itself. A raw model is not an agent. But it becomes one when a harness gives it things like state, tool execution, feedback loops, and enforceable constraints.

## Harness 包含什么

Concretely, a harness includes:
- System Prompts
- Tools, Skills, MCPs + and their descriptions
- Bundled Infrastructure (filesystem, sandbox, browser)
- Orchestration Logic (subagent spawning, handoffs, model routing)
- Hooks/Middleware for deterministic execution (compaction, continuation, lint checks)

## 为什么需要 Harness（从模型视角）

Models (mostly) take in data like text, images, audio, video and they output text. That's it. Out of the box they cannot:
- Maintain durable state across interactions
- Execute code
- Access realtime knowledge
- Setup environments and install packages to complete work

These are all harness level features. The structure of LLMs requires some sort of machinery that wraps them to do useful work.

## 核心组件推导

### Filesystems for Durable Storage and Context Management

**Harnesses ship with filesystem abstractions and tools for fs-ops.**

The filesystem is arguably the most foundational harness primitive because of what it unlocks:
- Agents get a workspace to read data, code, and documentation
- Work can be incrementally added and offloaded instead of holding everything in context
- The filesystem is a natural collaboration surface. Multiple agents and humans can coordinate through shared files

Git adds versioning to the filesystem so agents can track work, rollback errors, and branch experiments.

### Bash + Code as a General Purpose Tool

**Harnesses ship with a bash tool so models can solve problems autonomously by writing & executing code.**

Bash + code exec is a big step towards giving models a computer and letting them figure out the rest autonomously. The model can design its own tools on the fly via code instead of being constrained to a fixed set of pre-configured tools.

### Sandboxes and Tools to Execute & Verify Work

**Sandboxes give agents safe operating environments.**

Instead of executing locally, the harness can connect to a sandbox to run code, inspect files, install dependencies, and complete tasks. This creates secure, isolated execution of code.

Good environments come with good default tooling:
- Pre-installing language runtimes and packages
- CLIs for git and testing
- Browsers for web interaction and verification

Tools like browsers, logs, screenshots, and test runners give agents a way to observe and analyze their work. This helps them create self-verification loops.

### Memory & Search for Continual Learning

**Agents should remember what they've seen and access information that didn't exist when they were trained.**

For memory, the filesystem is again a core primitive. Harnesses support memory file standards like AGENTS.md which get injected into context on agent start.

For up-to-date knowledge, Web Search and MCP tools like Context7 help agents access information beyond the knowledge cutoff.

### Battling Context Rot

**Context Rot describes how models become worse at reasoning and completing tasks as their context window fills up.**

Harnesses today are largely delivery mechanisms for good context engineering.

Strategies:
- **Compaction**: intelligently offloads and summarizes the existing context window
- **Tool call offloading**: keeps the head and tail tokens of tool outputs above a threshold, offloads full output to filesystem
- **Skills**: progressive disclosure, protects the model against context rot

### Long Horizon Autonomous Execution

**We want agents to complete complex work, autonomously, correctly, over long time horizons.**

This is where earlier harness primitives start to compound. Long-horizon work requires durable state, planning, observation, and verification.

Components:
- **Filesystems and git**: track work across sessions
- **Ralph Loops**: intercepts the model's exit attempt and reinjects the original prompt in a clean context window
- **Planning and self-verification**: decompose goals into steps, check correctness via test suites

## Model-Harness Coupling

Today's agent products like Claude Code and Codex are post-trained with models and harnesses in the loop. This creates a feedback loop where useful primitives are discovered, added to the harness, then used when training the next generation of models.

**Side effect**: changing tool logic leads to worse model performance. A good example is the apply_patch tool logic for editing files. Training with a harness in the loop creates this overfitting.

**But**: the best harness for your task is not necessarily the one a model was post-trained with. The Terminal Bench 2.0 Leaderboard shows Opus 4.6 in Claude Code scores far below Opus 4.6 in other harnesses.

LangChain improved their coding agent Top 30 to Top 5 on Terminal Bench 2.0 by **only changing the harness**.

## Future of Harnesses

As models get more capable, some of what lives in the harness today will get absorbed into the model. Models will get better at planning, self-verification, and long horizon coherence natively.

But harness engineering will continue to be useful for building good agents:
- A well-configured environment, the right tools, durable state, and verification loops make any model more efficient regardless of its base intelligence

Open problems:
- Orchestrating hundreds of agents working in parallel on a shared codebase
- Agents that analyze their own traces to identify and fix harness-level failure modes
- Harnesses that dynamically assemble the right tools and context just-in-time for a given task

## Core Insight

> The model contains the intelligence and the harness is the system that makes that intelligence useful.