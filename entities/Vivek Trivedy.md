---
title: Vivek Trivedy
created: 2026-04-26
updated: 2026-04-26
type: entity
tags: [person, ai-ml, langchain]
sources:
  - raw/articles/langchain-anatomy-of-agent-harness-2026.md
---

# Vivek Trivedy

> LangChain 工程师，《The Anatomy of an Agent Harness》作者。

## 简介

Vivek Trivedy 是 LangChain 工程师，2026 年 3 月发表《The Anatomy of an Agent Harness》，系统化定义了 Harness 的核心组件，提出了从"模型做不到什么"推导 Harness 设计的方法论。

## 核心贡献

### Agent = Model + Harness

提出最清晰的 Harness 定义：

> If you're not the model, you're the harness.

Harness 是模型之外的一切：代码、配置、执行逻辑。

### Harness 五组件推导

从"模型做不到什么"推导 Harness 需要：

| 模型做不到 | Harness 补什么 | 核心组件 |
|------------|----------------|----------|
| 持久状态 | 文件系统抽象 + fs-ops | Filesystem |
| 执行代码 | Bash + 通用工具 | Bash + Code exec |
| 安全执行 | Sandbox 环境 | Sandboxes |
| 记忆/新知识 | AGENTS.md + Web Search | Memory & Search |
| 上下文衰减 | Compaction + Skills | Context Management |

### Context Rot 概念

提出 **Context Rot**：模型随着上下文窗口填满，推理和完成任务的能力变差。

解决方案：
- Compaction（压缩）
- Tool call offloading（工具输出截断）
- Skills（渐进式披露）

### Ralph Loop

提出 Ralph Loop：拦截模型的退出尝试，在干净上下文窗口中重新注入原始 prompt，强制 Agent 继续工作直到完成目标。

### Model-Harness Coupling 洞察

观察到 Agent 产品（Claude Code、Codex）的训练包含模型和 Harness，形成反馈循环。但也创造了过拟合：改变工具逻辑会导致模型表现变差。

关键发现：**最好的 Harness 不是模型训练时用的那个**。Terminal Bench 2.0 显示，Opus 4.6 在 Claude Code 的 Harness 下得分远低于在其他 Harness 下。

LangChain 只改 Harness，把排名从 Top 30 提升到 Top 5。

## 关联

- [[Harness Engineering]]
- [[LangChain]]
- [[Context Rot]]
- [[Ralph Loop]]
- [[渐进式披露]]
- [[agentskills.io]]