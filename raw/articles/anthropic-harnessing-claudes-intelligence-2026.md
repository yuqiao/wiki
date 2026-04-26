# Harnessing Claude's Intelligence

> 来源：https://claude.com/blog/harnessing-claudes-intelligence
> 抓取日期：2026-04-26
> 作者：Lance Martin (Anthropic Claude Platform team)
> 发布日期：April 2, 2026

## 核心论点

> Generative AI systems like Claude are grown more than they are built. — Chris Olah

Agent harnesses encode assumptions about what Claude can't do on its own, but those assumptions grow stale as Claude gets more capable.

**三大模式**：
1. Use what Claude knows
2. Ask "what can I stop doing?"
3. Set boundaries carefully

## 1. Use what Claude knows

Build applications using tools that Claude understands well.

Claude 3.5 Sonnet reached 49% on SWE-bench Verified with only:
- bash tool
- text editor tool

Bash wasn't designed for building agents, but it's a tool that Claude **knows** how to use and gets better at using over time.

### Composition Pattern

Claude composes general tools into patterns:

| Pattern | Composition |
|---------|-------------|
| Agent Skills | bash + text editor |
| Programmatic tool calling | bash + text editor |
| Memory tool | bash + text editor |

## 2. Ask "what can I stop doing?"

Agent harnesses encode assumptions about what Claude can't do. As Claude gets more capable, test those assumptions.

### Let Claude orchestrate its own actions

**Common assumption**：every tool result should flow back through context window.

**Problem**：Processing tool results in tokens is slow, costly, unnecessary.

Example：reading large table to reason about single column → whole table lands in context, pays token cost for every row it doesn't need.

Hard-coded filters don't address the root cause：harness is making an **orchestration decision** that Claude is better positioned to make.

**Solution**：Give Claude code execution tool (bash/REPL). Claude decides what results to pass through, filter, or pipe without touching context window.

> The orchestration decision moves from the harness to the model.

**BrowseComp result**：Opus 4.6 accuracy 45.3% → 61.6% when given ability to filter own tool outputs.

### Let Claude manage its own context

**Common assumption**：system prompts should be hand-crafted with task-specific instructions.

**Problem**：Pre-loading prompts doesn't scale across tasks. Every token added depletes attention budget.

**Solution - Skills**：YAML frontmatter pre-loaded, full skill progressively disclosed by Claude calling read file tool.

**Solution - Context editing**：Inverse of skills—selectively remove stale context (old tool results, thinking blocks).

**Solution - Subagents**：Fork into fresh context window. Opus 4.6 improved BrowseComp by 2.8% over best single-agent runs.

### Let Claude persist its own context

**Common assumption**：memory systems should rely on retrieval infrastructure around the model.

**Solution - Compaction**：Let Claude summarize past context. Different models scale differently:

| Model | BrowseComp (agentic search) with same compaction budget |
|-------|--------------------------------------------------------|
| Sonnet 4.5 | 43% (flat) |
| Opus 4.5 | 68% |
| Opus 4.6 | 84% |

**Solution - Memory folder**：Write context to files. BrowseComp-Plus: Sonnet 4.5 accuracy 60.4% → 67.2% with memory folder.

#### Pokémon Case Study

Long-horizon games show Claude's improved ability to use memory folder.

| Model | Step count | Memory files | Progress |
|-------|------------|--------------|----------|
| Sonnet 3.5 | 14,000 | 31 files (including duplicates about caterpillar Pokémon) | Still in second town |
| Opus 4.6 | 14,000 | 10 files organized into directories, 3 gym badges | Learnings file distilled from failures |

**Sonnet 3.5 memory example**：
```
caterpie_weedle_info:
- Caterpie and Weedle are both caterpillar Pokémon.
- Caterpie is a caterpillar Pokémon that does not have poison.
- Weedle is a caterpillar Pokémon that does have poison.
```

**Opus 4.6 memory example**：
```
/gameplay/learnings.md:
- Bellsprout Sleep+Wrap combo: KO FAST with BITE before Sleep Powder lands.
- Gen 1 Bag Limit: 20 items max. Toss unneeded TMs before dungeons.
- Spin tile mazes: Different entry y-positions lead to DIFFERENT destinations.
```

## 3. Set boundaries carefully

Agent harnesses provide structure around Claude to enforce UX, cost, or security.

### Design context to maximize cache hits

Messages API is stateless. Claude cannot see conversation history of prior turns. Harness must package new context alongside all past actions, tool descriptions, instructions.

Cached tokens are 10% cost of base input tokens.

| Principle | Description |
|-----------|-------------|
| Static first, dynamic last | Order requests: stable content (system prompt, tools) first |
| Messages for updates | Append `<system-reminder>` instead of editing prompt |
| Don't change models | Caches are model-specific; switching breaks them. Use subagent if need cheaper model |
| Carefully manage tools | Tools in cached prefix. Adding/removing invalidates. Use tool search for dynamic discovery |
| Update breakpoints | Move breakpoint to latest message to keep cache up-to-date |

### Use declarative tools for UX, observability, or security boundaries

Claude doesn't know application's security boundary or UX surface. Claude emits tool calls → harness handles them.

**Bash tool**：broad leverage, but only gives harness a command string (same shape for every action).

**Dedicated tool**：gives harness action-specific hook with typed arguments it can intercept, gate, render, audit.

**Security boundary**：hard-to-reverse actions (external API calls) gated by user confirmation.

**UX**：render as modal, display question clearly, give user options, block agent loop until feedback.

**Observability**：structured arguments to log, trace, replay.

### Auto-mode pattern

Claude Code's auto-mode (research mode): second Claude reads bash command string and judges whether safe. Limits need for dedicated tools, should only be used for tasks where users trust general direction.

## Context Anxiety Evolution

In an agent for long-horizon tasks:
- Sonnet 4.5: wrap up prematurely as sensed context limit approaching → added resets
- Opus 4.5: behavior gone → resets became dead weight

> Removing this dead weight is important because it can bottleneck Claude's performance.

## Looking Forward

> The frontier of Claude's intelligence is always changing. Assumptions about what Claude can't do need to be re-tested with each step change in its capability.

Over time, structure or boundaries should be pruned based on: what can I stop doing?