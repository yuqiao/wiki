---
title: Claude Code
created: 2026-04-18
updated: 2026-04-18
type: entity
tags: [Agent, Claude, Anthropic, AI编程]
sources: [raw/papers/ClaudeCode从入门到精通-v2.0.0_摘要.md]
---

# Claude Code

> Anthropic的AI编程工具。终端原生运行，直接操作操作系统，是独立工程师团队而非结对伙伴。

## 简介

- **开发者**: [[Anthropic]]
- **创建者**: [[Boris Cherny]]
- **发布**: 2025年2月（研究预览版），5月正式GA
- **定位**: 终端Agent，交互式编码
- **增长**: GA后6个月达到10亿美元年化收入

## 背后模型

| 模型 | 特点 | 适用场景 |
|------|------|----------|
| Opus 4.6 | 推理能力最强 | 复杂任务和架构决策 |
| Sonnet 4.6 | 性价比最优 | 日常编码的主力 |
| Haiku 4.5 | 响应最快 | 简单查询和补全 |

## 付费方案

| 方案 | 月费 | 用量 | 适合谁 |
|------|------|------|--------|
| Pro | $20/月 | 基础用量 | 个人开发者、学习者 |
| Max 5x | $100/月 | 5倍于Pro | 重度用户、全职AI编程 |
| Max 20x | $200/月 | 20倍于Pro | 团队用户、商业项目 |

## 核心特性

### 终端原生

不住在任何编辑器里，直接在终端运行。直接操作git、shell、MCP。

详见 [[终端Agent]]

### CLAUDE.md记忆

项目记忆文件，给AI一张地图。编码规范、架构决策持久保存。

详见 [[CLAUDE.md]]

### 多实例并行

原生支持多实例并行工作，像一个小团队。

### Skills、Hooks、MCP

- Skills：能力扩展
- Hooks：行为约束
- MCP：外部工具连接（[[MCP (Model Context Protocol)]])

### Computer Use、Voice Mode

v2.1.88新增功能。

## 五种使用方式

| 方式 | 特点 | 适合谁 |
|------|------|--------|
| 终端CLI | 最原生体验，功能完整 | 日常开发主力 |
| VS Code扩展 | 侧边栏运行，可见文件变更 | VS Code用户 |
| Desktop App | 独立桌面应用 | 不熟悉终端的用户 |
| Web版 | 浏览器访问 claude.ai/code | 临时使用 |
| JetBrains插件 | IntelliJ/WebStorm中使用 | JetBrains用户 |

## 企业采用

Netflix、Spotify、DoorDash、Notion、Vercel等大公司内部大规模使用。使用团队平均提效2-5倍。

## 和其他工具的区别

| 维度 | Claude Code | Cursor | Hermes |
|------|-------------|--------|--------|
| 运行环境 | 终端原生 | IDE内嵌 | 终端原生 |
| 自主程度 | 可无人值守 | 需人在场确认 | 可无人值守 |
| 系统集成 | 直接git/shell | 插件桥接 | 直接git/shell |
| 记忆 | CLAUDE.md | 隐式索引 | 三层自改进 |
| 运行模式 | 按需启动 | 按需启动 | 24/7后台 |

## 核心洞察

> "Claude Code不是在帮你写代码，它在帮你构建产品。" — [[花叔]]

你的角色从「写代码的人」变成「给指令的人」。

## 实践经验

[[Boris Cherny]]（创建者）用Opus 4.5后：
- 47天里46天都在用
- 最长单次session跑了1天18小时50分钟
- 再也没有手写过一行代码

[[花叔]]：
- 从未手写过代码
- 所有产品用AI完成（包括AppStore付费榜Top 1的「小猫补光灯」）

## 关联

- [[Claude Code从入门到精通]]
- [[Anthropic]]
- [[Boris Cherny]]
- [[花叔]]
- [[终端Agent]]
- [[CLAUDE.md]]
- [[MCP (Model Context Protocol)]]
- [[agentskills.io]]
- [[Hermes Agent]]（组合使用）