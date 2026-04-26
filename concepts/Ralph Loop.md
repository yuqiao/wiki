---
title: Ralph Loop
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [technique, ai-ml, agent]
sources:
  - raw/articles/langchain-anatomy-of-agent-harness-2026.md
---

# Ralph Loop

> 拦截模型退出，在干净上下文中强制继续工作的 Harness 模式。

## 概念 (Concept)

**Ralph Loop**：一种 Harness 模式，通过 hook 拦截模型的退出尝试，在干净的上下文窗口中重新注入原始 prompt，强制 Agent 继续工作直到完成目标。

LangChain 的 Vivek Trivedy 在《The Anatomy of an Agent Harness》中提出。

## 价值 (Value)

### 解决什么问题

- **Early stopping**：模型倾向于提前收工，即使任务未完成
- **Context rot**：上下文填满后质量下降，需要"重启"
- **长任务连贯性**：跨多个上下文窗口保持任务连贯

### 与 Anthropic Context Resets 的关系

两者本质相同：
- Anthropic：启动全新"干净" Agent，通过结构化交接文档恢复状态
- Ralph Loop：拦截退出，在同一 session 中重启干净上下文

核心思想：不压缩上下文，而是重启进程，从检查点恢复状态。

## 用法 (Usage)

### 实现机制

```
┌─────────────────────────────────────────┐
│ Agent tries to exit                     │
│     ↓                                   │
│ Hook intercepts exit attempt            │
│     ↓                                   │
│ Clear context window                    │
│     ↓                                   │
│ Reinject original prompt                │
│     ↓                                   │
│ Agent reads state from filesystem       │
│     ↓                                   │
│ Continue working                        │
└─────────────────────────────────────────┘
```

### 文件系统的关键作用

文件系统使 Ralph Loop 可行：
- 每次迭代开始时上下文干净
- 但能读取上一轮的状态（AGENTS.md、进度文件）
- 工作持久化，不随上下文清空丢失

## 原理 (Principle)

### 为什么有效

类比：程序碰到内存泄漏时的解法——不手动释放每个内存块（对应上下文压缩），而是直接重启进程，从检查点恢复状态。

粗暴但在长任务场景里：
- 一个干净重启的 Agent > 一个塞满历史信息的 Agent

### 完成目标导向

Ralph Loop 强制 Agent 工作到**完成目标**，而非"自己觉得差不多了"。

## 心法 (Best Practices)

### 设置完成目标

- Prompt 中明确 completion criteria
- Ralph Loop 检查是否满足 criteria
- 满足才允许退出

### 结构化状态持久化

每次迭代写入：
- 当前进度
- 已完成工作
- 待办事项
- 关键发现

下一次迭代读取这些状态继续。

### 防止无限循环

- 设置最大迭代次数
- 设置 token 预算告警
- 人工审核触发条件

## 关联

- [[Harness Engineering]]
- [[Vivek Trivedy]]
- [[LangChain]]
- [[Context Rot]]
- [[Anthropic]]（Context Resets 策略）
- [[渐进式披露]]