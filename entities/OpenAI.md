---
title: OpenAI
created: 2026-04-20
updated: 2026-04-20
type: entity
tags: [公司, AI研究, GPT, Agent]
sources: [raw/articles/javaguide-harness-engineering-2026.md]
---

# OpenAI

> AI研究和部署公司，GPT模型和Codex的开发者。

## 简介

- **定位**: AI研究和部署公司
- **产品**: GPT模型系列、Codex Agent
- **创始人**: Sam Altman（CEO）

## Harness Engineering 实战

2026年2月发布《Harness Engineering: Leveraging Codex in an Agent-First World》，披露了用 Codex Agent 从零构建完整内部产品的案例：

| 指标 | 数值 |
|------|------|
| 团队规模 | 3 名工程师（后扩至 7 人） |
| 持续时间 | 5 个月（2025 年 8 月起） |
| 代码规模 | 约 100 万行 |
| 手写代码 | 0 行（设计约束） |
| 合并 PR 数 | 约 1,500 个 |
| 效率提升 | 约 10 倍 |

**五大方法论**：

1. 给 Agent 一张地图（AGENTS.md 约 100 行），而不是一本千页手册
2. 架构约束必须靠工具强制执行（自定义 Linter）
3. 可观测性也是给 Agent 看的（Chrome DevTools Protocol）
4. 熵不会自己消失，必须主动对抗（后台清理 Agent）
5. 写在 Slack 里的知识，对 Agent 等于不存在（仓库为唯一事实源）

> "If it cannot be enforced mechanically, agents will deviate." — OpenAI

## 核心洞察

- 瓶颈不在模型，在 Harness
- AGENTS.md 只当目录用，详细规则按需加载
- 以仓库为唯一事实源

## 关联

- [[Harness Engineering]]
- [[Anthropic]]
- [[渐进式披露]]
- [[熵管理]]
- [[Claude Code]]