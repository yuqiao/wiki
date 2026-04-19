---
title: MCP (Model Context Protocol)
created: 2026-04-18
updated: 2026-04-18
type: concept
tags: [协议, Agent, 工具集成, Anthropic]
sources: [raw/papers/Hermes-Agent-从入门到精通_摘要.md]
---

# MCP (Model Context Protocol)

> AI工具世界的USB接口。Anthropic在2024年底提出的开放标准，定义了AI Agent和外部工具之间的通信协议。

## 概念 (Concept)

MCP（Model Context Protocol）是一个开放协议，定义了AI Agent和外部工具之间的通信标准。只要MCP Server实现了这个协议，任何支持MCP的Agent都能直接调用它提供的工具。

目前MCP生态覆盖了6000+应用，包括GitHub、Slack、Jira、Google Drive、数据库等。

## 价值 (Value)

### 为什么重要

- Agent不需要为每个外部服务开发专用工具
- 即插即用的能力扩展
- 社区已有几千个现成的Server可用

### 解决的问题

| 问题 | 传统方案 | MCP方案 |
|------|----------|---------|
| 工具开发 | 每个服务需专用适配 | 统一协议 |
| 能力扩展 | 自己开发或等官方支持 | 安装MCP Server即可 |
| 维护成本 | 高 | 低（社区维护Server） |

## 用法 (Usage)

### 连接方式

| 方式 | Server位置 | 适用场景 | 性能 |
|------|------------|----------|------|
| stdio | 本机子进程 | 本地工具、文件系统、数据库 | 快，无网络开销 |
| HTTP (SSE) | 远程服务器 | 云服务、团队共享Server | 取决于网络 |

大多数情况用stdio就够了。MCP Server作为Agent的子进程运行，通信走标准输入输出。

### 配置示例

stdio方式：
```yaml
mcp_servers:
  github:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: "ghp_xxxxx"
```

HTTP方式：
```yaml
mcp_servers:
  remote-tools:
    url: "https://your-server.com/mcp"
    transport: "sse"
```

### GitHub MCP实战

1. 准备GitHub Token（至少勾选repo和read:org权限）
2. 配置config.yaml
3. 重启Agent，对它说「列出我GitHub上的仓库」

连接后可用自然语言操作GitHub：
- 「帮我在XX仓库创建一个Issue，标题是...」
- 「看看这个PR的改动，帮我做一下代码审查」
- 「最近一周有哪些新Issue？按标签分类列出来」

### 数据库MCP实战

```yaml
mcp_servers:
  postgres:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-postgres"]
    env:
      POSTGRES_CONNECTION_STRING: "postgresql://user:***@localhost:5432/mydb"
```

配置后可对Agent说「查一下这个月注册用户有多少」「最近30天每天的订单金额趋势」。

### per-server工具过滤

连接多个MCP Server后，工具可能太多影响决策质量。可指定每个Server只暴露哪些工具：

```yaml
mcp_servers:
  github:
    allowed_tools:
      - "list_issues"
      - "create_issue"
      - "get_pull_request"
```

## 原理 (Principle)

### 架构

```
AI Agent ← MCP协议 ← MCP Server ← 外部服务
```

Agent不需要知道外部服务的API细节，只需要知道MCP协议。MCP Server负责翻译。

### 原生工具 vs MCP

| 推荐原生 | 推荐MCP |
|----------|---------|
| 终端命令、文件操作、Web搜索、图像生成、记忆管理、子Agent委派 | GitHub、数据库、Slack、Jira、Google Drive |

判断标准：如果Agent已内置这个能力，用内置的；如果需要和外部服务交互，用MCP。

## 心法 (Best Practices)

### 安全提醒

数据库MCP默认有读写权限。如果只想查询，建议使用只读账号连接。生产环境尤其要注意。

### 不要一次性接入太多

刚开始只接一两个最常用的（GitHub、数据库），用熟了再加。每多一个Server，工具选择空间大一圈，决策路径也变长。

### MCP + Skill组合

MCP解决「能连什么」，Skill解决「怎么用」。两者配合效果更好：
- Skill定义审查标准
- MCP提供读取PR改动的能力
- 结合后Agent可按你的标准自动审查代码

## 关联

- [[Hermes Agent]]
- [[Claude Code]]
- [[Hermes Agent从入门到精通]]
- [[Claude Code从入门到精通]]
- [[Skill自改进]]
- [[Anthropic]]