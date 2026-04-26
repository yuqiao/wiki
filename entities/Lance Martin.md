---
title: Lance Martin
created: 2026-04-26
updated: 2026-04-26
type: entity
tags: [person, ai-ml, anthropic]
sources:
  - raw/articles/anthropic-harnessing-claudes-intelligence-2026.md
  - raw/articles/anthropic-scaling-managed-agents-2026.md
---

# Lance Martin

> Anthropic Claude Platform 团队成员，《Harnessing Claude's Intelligence》作者。

## 简介

Lance Martin 是 Anthropic Claude Platform 团队成员，2026 年 4 月发表《Harnessing Claude's Intelligence》，提出三大模式来构建与 Claude 演进智能同步的应用。

## 核心贡献

### 三大模式

| 模式 | 核心思想 |
|------|----------|
| Use what Claude knows | 用 Claude 理解的工具构建应用（bash + text editor） |
| Ask "what can I stop doing?" | 测试 harness 中关于 Claude 不能做的假设 |
| Set boundaries carefully | 用 declarative tools 设定 UX/安全/可观测边界 |

### Orchestration Decision

提出 **orchestration decision** 从 harness 移到 model：

> The orchestration decision moves from the harness to the model.

例子：读取大表推理单列——hard-coded filters 没解决根本原因（harness 在做 orchestration decision）。

解决方案：Give Claude code execution tool，Claude 决定什么结果传递/过滤/管道。

### BrowseComp 数据

BrowseComp benchmark 测试 Agent 浏览网页能力：

| 模型 | 配置变化 | Accuracy |
|------|----------|----------|
| Opus 4.6 | + filter own tool outputs | 45.3% → 61.6% |
| Opus 4.6 | + subagents | +2.8% over single-agent |

Compaction scaling：

| 模型 | BrowseComp (same compaction budget) |
|------|-------------------------------------|
| Sonnet 4.5 | 43% (flat) |
| Opus 4.5 | 68% |
| Opus 4.6 | 84% |

Memory folder：

| 模型 | BrowseComp-Plus |
|------|-----------------|
| Sonnet 4.5 (no memory folder) | 60.4% |
| Sonnet 4.5 (+ memory folder) | 67.2% |

### Pokémon Case Study

展示 Claude 用 memory folder 的能力演进：

| Model | Steps | Memory files | Progress |
|-------|-------|--------------|----------|
| Sonnet 3.5 | 14,000 | 31 files (transcript-style) | Still in second town |
| Opus 4.6 | 14,000 | 10 files organized, learnings.md | 3 gym badges |

Sonnet 3.5：transcript-style（记录 NPC 说了什么）
Opus 4.6：tactical notes（蒸馏失败经验）

### Context Anxiety Evolution

确认 Prithvi Rajasekaran 的观察：
- Sonnet 4.5：wrap up prematurely → added resets
- Opus 4.5：behavior gone → resets became dead weight

> Removing this dead weight is important because it can bottleneck Claude's performance.

### Cache Optimization

设计上下文最大化缓存命中率：

| Principle | Description |
|-----------|-------------|
| Static first, dynamic last | stable content first |
| Messages for updates | append `<system-reminder>` |
| Don't change models | caches are model-specific |
| Carefully manage tools | tools in cached prefix |
| Update breakpoints | move to latest message |

Cached tokens: 10% cost of base input tokens.

### Auto-mode Pattern

Claude Code auto-mode：second Claude reads bash command and judges safety。Limits need for dedicated tools，use only when users trust general direction。

### Managed Agents（2026年4月）

与 Gabe Cemaj、Michael Cohen 合著《Scaling Managed Agents: Decoupling the brain from the hands》，提出托管服务架构：

**核心贡献**：
- 提出 Brain/Hands/Session 三组件虚拟化架构
- 借鉴 OS 虚拟化模式设计稳定接口层
- 实现 p50 TTFT 60% 下降、p95 TTFT 90% 下降
- 设计安全边界：tokens 从不 reachable from sandbox

**Meta-harness 设计哲学**：
> We're opinionated about the shape of these interfaces, not about what runs behind them.

接口稳定，实现可随模型演进更换——解决 Harness 假设过时问题（Bitter Lesson）。

## 关联

- [[Anthropic]]
- [[Chris Olah]]
- [[Harness Engineering]]
- [[Context Anxiety]]
- [[渐进式披露]]
- [[Orchestration Decision]]
- [[Memory Folder]]
- [[Managed Agents]]