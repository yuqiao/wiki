---
title: Hermes Agent
created: 2026-04-18
updated: 2026-04-18
type: entity
tags: [Agent, Hermes, 开源, Nous Research]
sources: [raw/papers/Hermes-Agent-从入门到精通_摘要.md]
---

# Hermes Agent

> Nous Research开源的AI Agent框架。第一个出厂就带缰绳的Agent——缰绳会自己长大。自改进、跨会话记忆、Skill系统、多平台Gateway。

## 简介

- **开发者**: [[Nous Research]]
- **发布**: 2026年2月
- **版本**: v0.7.0（2026年4月3日）
- **许可证**: MIT（完全开源）
- **定位**: 自主后台引擎，24/7运行，自改进

## 关键数据

| 指标 | 数据 |
|------|------|
| GitHub stars | 27,000+（发布两个月） |
| 内置工具 | 40+ |
| 支持平台 | 12+ |
| MCP可接入 | 6,000+ 应用 |
| 子Agent并发 | 最多3个 |
| 最低部署成本 | $5/月 VPS |
| 内存占用 | <500MB |

## 核心特性

### 学习循环

Agent自己给自己造缰绳。五个环节：
- 策划记忆 → 创建Skill → Skill自改进 → FTS5召回 → 用户建模

详见 [[学习循环]]

### 三层记忆

- 会话记忆：发生了什么（SQLite + FTS5）
- 持久记忆：你是谁
- Skill记忆：怎么做事

详见 [[三层记忆]]

### Skill系统

- 来源：Bundled Skills（40+）、Agent自主创建、Skills Hub
- 特点：自改进，会从反馈中进化
- 标准：[[agentskills.io]]（Skill可互通）

详见 [[Skill自改进]]

### 多平台Gateway

12+平台支持：Telegram、Discord、Slack、WhatsApp、Signal等。所有平台共享同一个大脑，跨平台对话连续。

### MCP集成

6000+应用的统一接口。详见 [[MCP (Model Context Protocol)]]

### 子Agent委派

delegate_task工具，最多3个并发子Agent，独立上下文，受限工具集。

## 和其他工具的区别

| 维度 | Claude Code | OpenClaw | Hermes |
|------|-------------|----------|--------|
| 核心理念 | 交互式编码 | 配置即行为 | 自主后台+自改进 |
| 你的角色 | 坐在终端前指挥 | 写配置定义行为 | 部署后偶尔检查 |
| 运行模式 | 按需启动 | 按需启动 | 24/7后台运行 |
| 记忆 | CLAUDE.md + auto-memory | 多层透明可控 | 三层自改进 |
| Skill | 手动安装 | ClawHub 44000+ | Agent自创+社区 |

不是替代关系，是组合关系：
- Claude Code处理需要你在场的事（白天团队）
- Hermes处理不需要你在场的事（夜班团队）

## 部署方案

| 方案 | 成本 | 说明 |
|------|------|------|
| 本地安装 | 免费 | 5分钟上手 |
| Docker | 免费 | 隔离干净 |
| $5 VPS | $5/月 | 24/7运行 |

## 核心洞察

> "Hermes是第一个出厂就带缰绳的Agent。而且缰绳会自己长大。" — [[花叔]]

不是你训练它，是它在训练自己。用的时间越长，它对你的理解越深，做事的质量越高。

## 关联

- [[Hermes Agent从入门到精通]]
- [[Nous Research]]
- [[花叔]]
- [[学习循环]]
- [[三层记忆]]
- [[Skill自改进]]
- [[MCP (Model Context Protocol)]]
- [[agentskills.io]]
- [[Harness Engineering]]
- [[Claude Code]]（组合使用）