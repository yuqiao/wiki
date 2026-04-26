---
title: Managed Agents
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [ai-ml, tool, Agent, Anthropic]
sources:
  - raw/articles/anthropic-scaling-managed-agents-2026.md
---

# Managed Agents

> Anthropic 的托管服务，为长期运行的 Agent 工作提供稳定接口层。

## 概念 (Concept)

Managed Agents 是 Anthropic 在 Claude Platform 上提供的托管服务，用于运行长期任务（long-horizon）的 Agent。核心设计思想：**接口稳定，实现可变**——借鉴操作系统虚拟化硬件的模式，将 Agent 的组件虚拟化。

## 价值 (Value)

### 解决什么问题

| 问题 | 传统做法 | Managed Agents 解法 |
|------|----------|---------------------|
| Harness 假设过时 | 手动更新 harness | 接口层与实现解耦 |
| 容器耦合 | 单容器 = pet（不可丢失） | 容器 = cattle（可替换） |
| 安全边界模糊 | 凭证和代码同容器 | 凭证在 vault，sandbox 无感知 |
| TTFT 慢 | 每个会话等待容器启动 | 按需启动容器 |

### 性能提升

| Metric | 改进 |
|--------|------|
| p50 TTFT | 下降约 60% |
| p95 TTFT | 下降超过 90% |

## 用法 (Usage)

### 三组件虚拟化

借鉴 OS 虚拟化 hardware（process, file）的模式，Managed Agents 虚拟化 Agent 的三个组件：

| 组件 | 定义 | 接口 |
|------|------|------|
| Session | 事件日志（append-only） | `getSession(id)`, `getEvents()`, `emitEvent(id, event)` |
| Harness | 调用 Claude + 路由工具调用 | `wake(sessionId)` |
| Sandbox | 执行环境（代码运行、文件编辑） | `execute(name, input) → string`, `provision({resources})` |

### Brain/Hands/Session 解耦

**Brain**（大脑）：Claude + Harness
**Hands**（手）：Sandboxes + Tools
**Session**（日志）：持久事件记录

核心接口：`execute(name, input) → string`

```
┌─────────────┐     execute()     ┌─────────────┐
│   Brain     │ ────────────────→ │    Hand     │
│ (Claude+    │                   │ (Sandbox)   │
│  Harness)   │ ←──────────────── │             │
└─────────────┘     string        └─────────────┘
       │                                │
       │ getSession()                   │
       ↓                                │
┌─────────────┐                         │
│   Session   │ ←─── emitEvent() ───────┘
│ (Event Log) │
└─────────────┘
```

### Pets vs Cattle 模式

| 模式 | 特点 | Agent 场景 |
|------|------|-----------|
| Pet | 有名字，手养，不可丢失 | 单容器耦合（旧设计） |
| Cattle | 无名字，可替换 | 解耦后每个组件都是 cattle |

**关键转变**：容器失败 → Harness 捕获 tool-call error → Claude 决定 retry → 新容器 `provision()` → 不需要 nurse back to health。

### 安全边界设计

**原则**：tokens 从不 reachable from sandbox。

两种模式：

| 模式 | 机制 | 示例 |
|------|------|------|
| Auth bundled with resource | 资源初始化时注入凭证 | Git clone 时注入 token 到 local remote |
| Vault outside sandbox | OAuth tokens 存 vault，通过 proxy 调用 | MCP tools via dedicated proxy |

Harness 从不知道任何 credentials。

### Session vs Context Window

Session 是 Claude context window 外的持久化上下文：

| 特性 | Session | Context Window |
|------|---------|----------------|
| 存储 | 外部持久化 | Claude 内存 |
| 生命周期 | 跨 crash 恢复 | 随 Agent 重启清空 |
| 查询 | `getEvents()` 按位置切片 | 全量加载 |

用法：
- 从上次停止处继续读取
- rewind 查看特定事件前的上下文
- reread 特定 action 前的 context

### Many Brains, Many Hands

**Many Brains**：
- 无需网络 peering，直接连接客户 VPC
- 按需启动容器，不等待
- TTFT 大幅下降

**Many Hands**：
- 一个 Brain 连多个 Hands（多个执行环境）
- Claude 需要推理分发任务（比单 shell 更难）
- Hands 可在 Brains 间传递

接口支持：
- Custom tools
- MCP servers
- Anthropic 内置 tools

Harness 不知道 sandbox 是 container、phone 还是 Pokémon emulator。

## 原理 (Principle)

### Meta-harness 设计哲学

> 对接口有观点，对实现无观点。

| 接口 | 保证 |
|------|------|
| Session | 持久、可恢复 |
| Sandbox | 能执行计算 |
| Harness | 可靠、安全、长期运行 |

**不假设**：Claude 需要多少个 brains、多少个 hands、它们在哪里。

### Bitter Lesson 应用

Harness 编码的假设会随着模型改进而过时：

| 案例 | Sonnet 4.5 | Opus 4.5 |
|------|-----------|----------|
| Context Anxiety | 强，需要 Resets | 弱，Resets 变成 dead weight |

**解法**：接口设计不编码具体假设，实现层可随模型演进更换。

### OS 虚拟化类比

| OS 抽象 | Agent 抽象 |
|---------|-----------|
| process | session |
| file | sandbox/tool call |
| `read()` | `execute()` |

`read()` 不管是 1970s disk pack 还是 modern SSD——接口稳定，实现可换。

## 心法 (Best Practices)

### 设计原则

1. **接口优先**：定义稳定的接口形状，不关心背后实现
2. **Cattle 化**：每个组件都应该可替换，不需要 nurse
3. **安全边界**：credentials 和 untrusted code 永远不在同一空间
4. **按需启动**：不要让 session 等待不需要的资源

### 实施检查清单

- [ ] Harness 是否能捕获 tool-call error 并优雅处理？
- [ ] Session 是否在外部持久化（不在 container 内）？
- [ ] Sandbox 是否无法访问任何 credentials？
- [ ] 新 session 的 TTFT 是否合理（不等待全量 provision）？

## 关联

- [[Anthropic]]
- [[Lance Martin]]
- [[Harness Engineering]]
- [[Context Anxiety]]
- [[MCP (Model Context Protocol)]]
- [[Claude Code]]
- [[Bitter Lesson]]