---
title: LangChain
created: 2026-04-26
updated: 2026-04-26
type: entity
tags: [company, ai-ml, open-source]
sources:
  - raw/articles/langchain-anatomy-of-agent-harness-2026.md
---

# LangChain

> Agent 开发框架公司，开源 deepagents Harness 构建库。

## 简介

LangChain 是 Agent 开发框架公司，提供开源工具链用于构建、调试和部署 AI Agent。2026 年 3 月发布《The Anatomy of an Agent Harness》，系统化定义了 Harness 的核心组件。

## 核心产品

| 产品 | 说明 |
|------|------|
| LangSmith | Agent engineering platform，debug、eval、deploy 一体 |
| deepagents | Harness 构建库，开源 |
| LangChain框架 | Agent 开发基础框架 |

## Harness Engineering 实验

2026 年，LangChain 团队实验证明：**只改 Harness，不改模型，排名从 Top 30 到 Top 5**。

Terminal Bench 2.0 结果：
- 用同一个模型
- 只调整周围的「缰绳」配置
- 成绩从 52.8% 涨到 66.5%
- 排名从 Top 30 跳到 Top 5

## 关键洞察

### Model-Harness Coupling

观察到 Agent 产品（Claude Code、Codex）训练时包含模型和 Harness：
- 有用的 primitives 被发现 → 加入 Harness → 用于训练下一代模型
- 形成反馈循环，模型在特定 Harness 下越来越能干

**副作用**：改变工具逻辑会导致模型表现变差（过拟合）。

**关键发现**：最好的 Harness 不是模型训练时用的那个。Opus 4.6 在 Claude Code 的 Harness 下得分远低于在其他 Harness 下。

### Harness 未来研究方向

- Orchestration: 数百个 Agent 并行工作在共享代码库
- Self-analysis: Agent 分析自己的 traces，识别并修复 Harness-level 失败模式
- Dynamic assembly: Harness 按任务动态组装工具和上下文（而非预配置）

## 关联

- [[Harness Engineering]]
- [[Vivek Trivedy]]
- [[Context Rot]]
- [[Ralph Loop]]
- [[agentskills.io]]
- [[MCP (Model Context Protocol)]]