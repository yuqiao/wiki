---
title: Orchestration Decision
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [concept, ai-ml, agent]
sources:
  - raw/articles/anthropic-harnessing-claudes-intelligence-2026.md
---

# Orchestration Decision（编排决策）

> 决定工具结果如何流动的决策权。

## 概念 (Concept)

**Orchestration Decision**：决定工具调用结果如何处理、传递、过滤的决策。

传统 Agent harness 做这个决策：每个 tool result 流回 context window。

Anthropic Claude Platform 团队成员 Lance Martin 提出：这个决策应该从 harness 移到 model。

## 价值 (Value)

### 解决什么问题

**传统假设**：every tool result should flow back through context window.

**问题**：
- Processing tool results in tokens is slow, costly
- Unnecessary if only needs to pass to next tool
- Claude only cares about small slice of output

例子：读取大表推理单列——整表进入上下文，为不需要的每行付 token 成本。

Hard-coded filters 没解决根本：harness 在做 orchestration decision。

### BrowseComp 数据

| 模型 | 配置 | Accuracy |
|------|------|----------|
| Opus 4.6 | 传统 | 45.3% |
| Opus 4.6 | + filter own tool outputs | 61.6% |

+16.3% 准确率提升。

## 用法 (Usage)

### Give Claude Code Execution Tool

Give Claude bash tool or language-specific REPL:
- Claude writes code to express tool calls and logic between them
- Claude decides what results to pass through, filter, pipe without touching context window
- Only output of code execution reaches context window

### 代码即编排语言

> Since code is a general way for Claude to orchestrate actions, a strong coding model is also a strong **general** agent.

Claude 在 non-coding evals 上也表现强，用这个模式。

## 原理 (Principle)

### 为什么移到 Model

Harness 不知道：
- Claude 关心哪个输出切片
- 哪些结果需要传递给下一个 tool
- 哪些可以过滤掉

Claude 有任务上下文，更适合做这个决策。

### 与 Context Budget 的关系

每进入 context window 的 token：
- 消耗 attention budget
- 增加 latency
- 增加成本

Orchestration decision 控制什么进入——是 context efficiency 的核心。

## 心法 (Best Practices)

### 默认假设

不要默认每个 tool result 进 context window。

### 代码执行优先

Give Claude code execution tool，让它自己编排。

### 监控 Context Inflow

观察有多少 tool result token 进入 context window，考虑是否可以减少。

## 关联

- [[Lance Martin]]
- [[Anthropic]]
- [[Harness Engineering]]
- [[Context Budget]]
- [[渐进式披露]]