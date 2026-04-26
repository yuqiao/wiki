---
title: Context Anxiety
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [concept, ai-ml, agent]
sources:
  - raw/articles/anthropic-harness-design-long-running-2026.md
---

# Context Anxiety（上下文焦虑）

> 模型接近上下文限制时提前收工的现象。

## 概念 (Concept)

**Context Anxiety**：模型在接近其上下文窗口限制时，开始提前结束工作（wrapping up prematurely），即使任务尚未完成。

Anthropic Labs 工程师 Prithvi Rajasekaran 在《Harness Design for Long-Running Application Development》中命名这个现象。

## 价值 (Value)

### 为什么重要

- 解释了长任务中 Agent "提前收工" 的行为
- 指出了 Compaction 策略的局限性
- 为 Context Resets 策略提供了理论基础

### 模型差异

| 模型 | Context Anxiety 强度 | 需要的策略 |
|------|----------------------|------------|
| Claude Sonnet 4.5 | 强 | Context Resets（Compaction 不够） |
| Opus 4.5 | 大幅减弱 | Compaction 可能足够 |
| Opus 4.6 | 更弱 | 可能不需要任何策略 |

## 用法 (Usage)

### Context Resets 策略

清空上下文窗口，启动全新 Agent，通过结构化交接文档（handoff artifact）携带前一 Agent 状态。

**关键**：交接 artifact 必须有足够状态让下一个 Agent 无缝接续。

### 与 Compaction 的区别

| | Context Resets | Compaction |
|---|---|---|
| 定义 | 清空上下文，启动全新 Agent | 原位总结早期对话 |
| Agent | 新 Agent | 同一 Agent |
| Slate | 干净 | 不干净 |
| Context Anxiety | 消除 | 可能残留 |
| 连续性 | 需要交接 artifact | 保持 |

### 与 Ralph Loop 的关系

LangChain 的 Ralph Loop 本质上是 Context Resets 的变体：
- 拦截 Agent 退出尝试
- 在干净上下文重启
- 文件系统使状态持久化可行

## 原理 (Principle)

### 为什么会发生

模型"担心"上下文即将填满，提前开始收尾工作，避免"爆掉"。

这是一种"自我保护"行为，但代价是任务未完成就停止。

### 为什么 Resets 有效

类比：程序碰到内存泄漏时的解法——重启进程，从检查点恢复状态。

干净重启的 Agent > 一个塞满历史信息的焦虑 Agent。

## 心法 (Best Practices)

### 选择策略

- Sonnet 4.5：Context Resets 必需
- Opus 4.5+：根据任务复杂度决定
- 简单任务：Compaction 可能足够
- 复杂任务：Resets 更可靠

### 交接 Artifact 设计

交接文档必须包含：
- 当前进度
- 已完成工作
- 待办事项
- 关键发现/决策
- 下一步行动

### 监控 Context Anxiety

- 观察 Agent 在接近 context limit 时的行为
- 检查是否提前收工
- 日志中记录 context utilization

## 关联

- [[Prithvi Rajasekaran]]
- [[Anthropic]]
- [[Context Resets]]
- [[Ralph Loop]]
- [[Context Rot]]
- [[Harness Engineering]]