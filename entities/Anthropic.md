---
title: Anthropic
created: 2026-04-18
updated: 2026-04-18
type: entity
tags: [公司, AI研究, Claude]
sources: [raw/papers/ClaudeCode从入门到精通-v2.0.0_摘要.md]
---

# Anthropic

> AI安全和研究公司，Claude模型和Claude Code的开发者。

## 简介

- **定位**: AI安全和研究公司
- **产品**: Claude模型系列、Claude Code
- **创始人**: Dario Amodei、Daniela Amodei（前OpenAI成员）

## 核心产品

### Claude模型系列

| 模型 | 特点 |
|------|------|
| Opus 4.6 | 推理能力最强，处理复杂任务和架构决策 |
| Sonnet 4.6 | 性价比最优，日常编码主力 |
| Haiku 4.5 | 响应最快，简单查询和补全 |

### Claude Code

- 2025年2月公开发布（研究预览版），5月正式GA
- GA后6个月达到10亿美元年化收入
- 终端原生AI编程工具

## 企业采用

Netflix、Spotify、DoorDash、Notion、Vercel等大公司内部大规模使用。使用团队平均提效2-5倍。

## Harness Engineering 实战

2026年3月发布《Harness Design for Long-Running Application Development》，提出借鉴GAN思路的三智能体架构：

**架构**：Planner（规划者）→ Generator（执行者）⇄ Evaluator（评估者）

| 角色 | 职责 |
|------|------|
| Planner | 拿到 1-4 句话的产品描述，扩展成完整的产品规格 |
| Generator | 按功能一个一个做"Sprint"，每个 Sprint 有明确的完成标准 |
| Evaluator | 用 Playwright MCP 实际点击运行中的应用，按维度打分 |

**解决的核心问题**：

| 问题 | 表现 | 解法 |
|------|------|------|
| 上下文焦虑 | Sonnet 4.5 快到上下文上限时草草收工 | context resets + 结构化交接 |
| 自我评价偏差 | Agent 自信满满夸自己做得好 | 生成和评估交给两个独立的 Agent |

**Context Resets**：当一个 Agent 的上下文接近饱和时，直接清空上下文窗口，但通过结构化的交接文档把关键状态留下来。

> "The space of interesting harness combinations doesn't shrink as models improve. Instead, it moves." — Anthropic

## Claude Code付费方案

| 方案 | 月费 | 用量 |
|------|------|------|
| Pro | $20/月 | 基础用量 |
| Max 5x | $100/月 | 5倍于Pro |
| Max 20x | $200/月 | 20倍于Pro |

## 关联

- [[Claude Code]]
- [[Claude Code从入门到精通]]
- [[花叔]]
- [[Boris Cherny]]
- [[Harness Engineering]]
- [[OpenAI]]