---
title: Prithvi Rajasekaran
created: 2026-04-26
updated: 2026-04-26
type: entity
tags: [person, ai-ml, anthropic]
sources:
  - raw/articles/anthropic-harness-design-long-running-2026.md
---

# Prithvi Rajasekaran

> Anthropic Labs 团队工程师，三智能体架构设计者。

## 简介

Prithvi Rajasekaran 是 Anthropic Labs 团队成员，2026 年 3 月发表《Harness Design for Long-Running Application Development》，提出借鉴 GAN 思路的三智能体架构（Planner → Generator ⇄ Evaluator）。

## 核心贡献

### Generator-Evaluator 分离

核心洞察：分离 Generator 和 Evaluator 是强有力的杠杆。

> Separating the agent doing the work from the agent judging it proves to be a strong lever... tuning a standalone evaluator to be skeptical turns out to be far more tractable than making a generator critical of its own work.

原因：Out of the box, Claude is a poor QA agent：
- identify legitimate issues → talk itself into deciding they're not a big deal → approve anyway
- test superficially → subtle bugs slip through

解决方案：Generator-Evaluator 分离 + tuning evaluator to be skeptical。

### Context Anxiety 概念

命名现象：模型接近上下文限制时，提前开始收工。

> Some models exhibit "context anxiety," in which they begin wrapping up work prematurely as they approach what they believe is their context limit.

Claude Sonnet 4.5 context anxiety 强，Compaction 不够，需要 Context Resets。Opus 4.5 大幅减弱，可以不用 Resets。

### Context Resets vs Compaction 区分

明确区分两种策略：

| | Context Resets | Compaction |
|---|---|---|
| 定义 | 清空上下文，启动全新 Agent，结构化交接 | 原位总结早期对话 |
| 优点 | 干净 slate，消除 context anxiety | 保持连续性 |
| 缺点 | 交接 artifact 必须有足够状态 | 无法消除 context anxiety |

### Sprint Contract 机制

Before each sprint, generator and evaluator negotiated a sprint contract: agreeing on what "done" looked like before any code was written.

目的：bridge gap between high-level spec and testable implementation。

### 前端设计评分标准

四项评分标准（权重 Design Quality + Originality > Craft + Functionality）：

| 标准 | 检查内容 |
|------|----------|
| Design Quality | 整体 vs 零件拼凑 |
| Originality | 自定义决策 vs 模板默认 |
| Craft | 技术执行（字体层级、间距、色彩） |
| Functionality | 可用性（独立于美学） |

### Harness 简化原则

> Every component in a harness encodes an assumption about what the model can't do on its own, and those assumptions are worth stress testing.

> Find the simplest solution possible, and only increase complexity when needed.

Opus 4.6 → 移除 sprint construct，Evaluator 变成 single pass at end。

### 关键发现：Evaluator 的价值边界

Evaluator worth the cost when task sits beyond what current model does reliably solo。

Opus 4.5：边界近，Evaluator 捕获有意义问题。
Opus 4.6：边界向外移动，范围内任务 evaluator 不必要。

## 关联

- [[Anthropic]]
- [[Harness Engineering]]
- [[Context Anxiety]]
- [[Context Resets]]
- [[Generator-Evaluator分离]]
- [[Sprint Contract]]
- [[三智能体架构]]
- [[Ralph Loop]]（LangChain 类似思路）