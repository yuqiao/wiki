---
title: Anthropic
created: 2026-04-18
updated: 2026-04-26
type: entity
tags: [公司, AI研究, Claude]
sources:
  - raw/papers/ClaudeCode从入门到精通-v2.0.0_摘要.md
  - raw/articles/anthropic-harness-design-long-running-2026.md
  - raw/articles/anthropic-scaling-managed-agents-2026.md
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

**与 Compaction 的区别**：

| | Context Resets | Compaction |
|---|---|---|
| 定义 | 清空上下文，启动全新 Agent | 原位总结早期对话 |
| Slate | 干净 | 不干净 |
| Context Anxiety | 消除 | 可能残留 |

Claude Sonnet 4.5 context anxiety 强，Resets 必需。Opus 4.5 大幅减弱，可以不用 Resets。

**Sprint Contract**：每个 Sprint 前 Generator 和 Evaluator 协商"完成标准"。Product Spec 高层级，Contract 桥接 gap 到可测试实现。

**前端设计评分标准**（四项）：

| 标准 | 检查内容 | 权重 |
|------|----------|------|
| Design Quality | 整体 vs 零件拼凑 | 高 |
| Originality | 自定义决策 vs 模板默认 | 高 |
| Craft | 技术执行（字体、间距、色彩） | 中 |
| Functionality | 可用性（独立于美学） | 中 |

权重：Design Quality + Originality > Craft + Functionality，惩罚"AI slop"模式。

**Opus 4.6 简化 Harness**：

移除 sprint construct，Evaluator 变成 single pass at end。Evaluator worth the cost when task sits beyond what current model does reliably solo。

**案例**：Retro Game Maker（16-feature spec，6小时，$200）vs Solo（20分钟，$9）——前者可玩，后者不能玩。

> "The space of interesting harness combinations doesn't shrink as models improve. Instead, it moves, and the interesting work for AI engineers is to keep finding the next novel combination." — Prithvi Rajasekaran

## Managed Agents

2026年4月发布《Scaling Managed Agents: Decoupling the brain from the hands》，提出托管服务架构：

**核心设计**：借鉴 OS 虚拟化 hardware（process, file），虚拟化 Agent 的三个组件：

| 组件 | 定义 |
|------|------|
| Session | 事件日志（append-only） |
| Harness | 调用 Claude + 路由工具调用 |
| Sandbox | 执行环境 |

**Brain/Hands/Session 解耦**：
- Brain（Claude + Harness）调用 Hands（Sandbox + Tools）如调用普通 tool
- Session 在外部持久化，不受 crash 影响
- 每个组件都是 cattle（可替换），不是 pet（不可丢失）

**性能改进**：
- p50 TTFT 下降约 60%
- p95 TTFT 下降超过 90%

**安全边界**：tokens 从不 reachable from sandbox，通过 vault + proxy 模式隔离。

**Meta-harness 设计**：对接口有观点，对实现无观点——接口稳定，实现可随模型演进更换。

作者：Lance Martin, Gabe Cemaj, Michael Cohen。

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
- [[Prithvi Rajasekaran]]
- [[Lance Martin]]
- [[Harness Engineering]]
- [[Context Anxiety]]
- [[Context Resets]]
- [[Generator-Evaluator分离]]
- [[Sprint Contract]]
- [[Managed Agents]]
- [[OpenAI]]