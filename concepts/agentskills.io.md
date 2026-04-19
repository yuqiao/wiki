---
title: agentskills.io
created: 2026-04-18
updated: 2026-04-18
type: concept
tags: [标准, Skill, Agent, 互通]
sources: [raw/papers/Hermes-Agent-从入门到精通_摘要.md]
---

# agentskills.io

> Skill互通标准。一个Skill插到哪都能跑。2026年初开始被多个工具采用，目前已有30+个工具支持。

## 概念 (Concept)

agentskills.io是一个开放标准，定义了Skill的通用格式。采用这个标准的Agent工具可以互相使用Skill——你为Claude Code写的Skill，可以直接在Hermes里用，反过来也一样。

这和App Store的逻辑不同。App Store是每个平台一套生态，开发者要适配多端。agentskills.io更像USB接口：一个Skill插到哪都能跑。

## 价值 (Value)

### 为什么重要

- Skill不再是某个Agent的专属资产
- 切换Agent时积累的Skill资产不会浪费
- Skill库是用户自己的资产，不是平台的附属品

### 解决的问题

| 问题 | 传统方案 | agentskills.io方案 |
|------|----------|-------------------|
| Skill锁死 | 每个Agent各自生态 | 标准格式，互通 |
| 迁移成本 | 从零开始 | 直接复用 |
| 学习投入浪费 | 换工具就丢失 | 可移植 |

### 已支持的工具

- Claude Code
- Hermes Agent
- Cursor
- Copilot
- Gemini CLI
- ...（30+工具）

## 用法 (Usage)

### Skill格式

agentskills.io标准规定Skill是markdown文件，包含：
- 标题
- 触发条件
- 行为规则
- 示例

这个格式是语义结构一致的，不同Agent都能理解和执行。

### 实战迁移示例

花叔在Claude Code里有个「公众号审校」Skill，核心逻辑是三遍审校（事实、风格、细节）。

把这个SKILL.md复制到 ~/.hermes/skills/proofreading.md，Hermes就能直接用。不需要改格式，不需要适配API。

### 示例Skill

```markdown
# 公众号文章审校

## 触发条件
当用户提到「审校」「降低AI味」「太AI了」「润色」时激活。

## 审校流程
### 第一遍：事实审校
- 检查所有数据、时间、产品名是否准确
- 标注不确定的信息

### 第二遍：风格审校
- 删除AI高频词（首先/其次/综上所述）
- 拆解AI句式
- 替换书面词汇为口语

### 第三遍：细节打磨
- 句子控制在15-25字
- 段落控制在手机屏幕3-5行
- 约10处加粗标记重点
```

## 原理 (Principle)

### 设计理念

agentskills.io的核心理念是：**Skill是能力单元，不是平台绑定资产**。

就像USB接口定义了设备的连接标准，agentskills.io定义了Agent Skill的格式标准。只要符合标准，任何Agent都能使用。

### OpenClaw生态的意义

OpenClaw的ClawHub有44000+个Skill。如果这些Skill能通过agentskills.io被其他Agent直接调用，整个生态的能力边界瞬间就展开。

反过来，其他Agent自动创建和改进的Skill也可以反哺回整个生态。

## 心法 (Best Practices)

### Skill迁移注意事项

如果Skill里引用了特定Agent特有的工具（比如某个MCP Server），那部分需要调整成目标Agent对应的工具名。但核心逻辑、触发条件、行为规则都是通用的。

### 选Agent时不用担心迁移成本

agentskills.io让Skill成为可移植资产。选Agent时不用考虑「我在另一个Agent积累的Skill怎么办」。

### 不是选择题，是组合题

花叔的做法：Claude Code处理需要他在场的事，Hermes处理不需要他在场的事。两者的Skill可以互通复用。

## 关联

- [[Hermes Agent]]
- [[Claude Code]]
- [[Hermes Agent从入门到精通]]
- [[Claude Code从入门到精通]]
- [[Skill自改进]]
- [[花叔]]