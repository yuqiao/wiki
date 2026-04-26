---
title: Context Rot
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [concept, ai-ml, programming]
sources:
  - raw/articles/langchain-anatomy-of-agent-harness-2026.md
---

# Context Rot（上下文腐烂）

> 上下文窗口填满时，模型推理和完成任务的能力变差。

## 概念 (Concept)

**Context Rot**：模型随着上下文窗口逐渐填满，推理能力下降、任务完成质量变差的现象。

LangChain 的 Vivek Trivedy 在《The Anatomy of an Agent Harness》中提出这个概念。

与 Dex Horthy 观察到的 40% 阈值现象本质相同：168K token 上下文窗口，用到约 40% 时，Agent 输出质量开始明显下降。

## 价值 (Value)

### 为什么重要

- 解释了为什么长任务中 Agent 越跑越蠢
- 为 Harness 的上下文管理提供了理论基础
- 指出了 Harness 需要主动管理上下文的原因

### 表现

| 区间 | 表现 |
|------|------|
| Smart Zone (0-40%) | 推理聚焦、工具调用准确、代码质量高 |
| Dumb Zone (>40%) | 幻觉增多、兜圈子、格式混乱、低质量代码 |

## 用法 (Usage)

### Harness 对抗 Context Rot 的策略

| 策略 | 说明 |
|------|------|
| Compaction | 上下文接近填满时，智能压缩和总结 |
| Tool call offloading | 保留工具输出的头尾 token，完整输出存文件系统 |
| Skills | 渐进式披露，只在上下文中保留 Skill 的 front-matter |
| Context Resets | Anthropic 策略：清空上下文，通过结构化交接文档恢复状态 |

### Ralph Loop

LangChain 提出的策略：拦截模型退出尝试，在干净上下文窗口中重新注入原始 prompt，强制继续工作。

文件系统使得 Ralph Loop 可行：每次迭代开始时上下文干净，但能读取上一轮的状态。

## 原理 (Principle)

### 为什么会发生

- 上下文是宝贵且稀缺的资源
- 模型注意力分散在大量信息中
- 历史信息越多，当前任务聚焦越难

### Harness 的角色

> Harnesses today are largely delivery mechanisms for good context engineering.

Harness 本质上是良好上下文工程的传递机制。

## 心法 (Best Practices)

- 监控上下文利用率，设置 40% 阈值告警
- 增量执行：工作增量添加，不把所有东西塞进上下文
- 文件系统 offload：中间输出存文件，不留在上下文
- Skills 渐进式披露：元数据常驻，正文按需加载

## 关联

- [[Harness Engineering]]
- [[Vivek Trivedy]]
- [[LangChain]]
- [[Ralph Loop]]
- [[渐进式披露]]
- [[熵管理]]
- [[单Agent问题]]（上下文饱和是核心问题之一）