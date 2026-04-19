---
title: Skill自改进
created: 2026-04-18
updated: 2026-04-18
type: concept
tags: [Agent, Skill, Hermes, 自改进]
sources: [raw/papers/Hermes-Agent-从入门到精通_摘要.md]
---

# Skill自改进

> Hermes Agent最独特的能力：Skill会自己长出来，还会自己变好。这是Hermes和所有其他Agent Skill系统最大的区别。

## 概念 (Concept)

在Hermes里，每个Skill是一个独立的markdown文件，存在 ~/.hermes/skills/ 目录下。Skill是程序性记忆，记录Agent怎么做事。

传统Skill需要人工维护。Hermes的Skill是活的，它跑在学习循环里，根据实际反馈自动优化。

## 价值 (Value)

### 为什么重要

- 不需要人持续写和维护Skill
- Skill会从你的使用习惯中自然生长
- 同一个Skill，不同用户用三周后会演化出不同版本

### 解决的问题

| 问题 | 传统Skill | Hermes自改进Skill |
|------|-----------|-------------------|
| 创建 | 人工编写 | Agent自主创建 |
| 维护 | 人工更新 | 自动进化 + 人工干预 |
| 个性化 | 通用模板，需手动定制 | 从使用习惯中自然生长 |

### 和OpenClaw的区别

| 维度 | OpenClaw | Hermes |
|------|----------|--------|
| Skill数量 | 44000+（大） | 40+预置 + 社区 |
| 创建方式 | 人工编写SOUL.md | Agent自主创建 |
| 适应性 | 通用模板 | 按用户演化 |

## 用法 (Usage)

### Skill来源

| 来源 | 说明 | 数量级 |
|------|------|--------|
| Bundled Skills | 安装时自带的预置能力 | 40+ |
| Agent自主创建 | 完成复杂任务后自动提炼 | 按使用积累 |
| Skills Hub | 社区贡献的技能包 | 持续增长 |

### 自改进机制

```
执行Skill → 收集反馈 → 更新Skill → 下次执行时使用新版本
```

1. Agent按照Skill中记录的步骤完成任务
2. 用户反应（满意/不满意/修正）被记录到会话记忆
3. Agent分析反馈，自动修改Skill文件中的相关步骤
4. 改进后的Skill在后续任务中自动生效

### 实战示例

你让Hermes每天整理GitHub通知。前几次你每次都要说一遍需求：「帮我看看昨天的GitHub通知，按重要程度排序，PR和Issue分开，忽略bot的自动通知。」

第三次之后，Hermes自动创建一个Skill文件 github-daily-digest.md。

之后你只需说「看看GitHub」，它就知道该做什么。

某天你说「这次把Discussion也加上」，Hermes不仅这次加上，还会更新Skill文件。下次你不说，它也会带上Discussion。

## 原理 (Principle)

### agentskills.io标准

Skill不是封闭生态。Hermes采用agentskills.io标准，目前已有30+个工具支持：
- Claude Code
- Cursor
- Copilot
- Gemini CLI

**意义**：你为Claude Code写的Skill，可以直接在Hermes里用。反过来也一样。Skill是可移植的能力单元。

### Mitchell方式 vs Hermes方式

| 维度 | Mitchell手动 | Hermes自动 |
|------|--------------|------------|
| 规则来源 | 人观察到问题后手写 | Agent自己从反馈中提炼 |
| 存储位置 | CLAUDE.md（单文件） | 多Skill文件 + 记忆数据库 |
| 触发改进 | 人记得要加才会加 | 每次使用后自动评估 |
| 改进速度 | 取决于人的勤快程度 | 持续自动 |

## 心法 (Best Practices)

### Skill结构模板

好的Skill应包含：

| 部分 | 作用 | 必须？ |
|------|------|--------|
| 标题 | 让Agent快速识别用途 | 是 |
| 触发条件 | 什么时候激活 | 强烈建议 |
| 行为规则 | 具体怎么做 | 是 |
| 示例 | 完整的输入→输出示例 | 强烈建议 |
| 不要做什么 | 明确的边界 | 可选 |

**触发条件写得越具体，命中率越高**。「当用户提到代码」太模糊；「当用户让我提交代码、写commit message、或review提交历史时」就很好。

### 反馈要具体

Skill自改进的前提是反馈足够清晰。「不太对」不说具体哪里不对，Agent很难准确改进。

好的反馈 = 好的进化方向。

### 自改进是可审计的

Skill文件是可读的markdown，每次更新都能看到diff。如果某条规则学偏了，你可以手动修正，Hermes会把你的修正也纳入学习。

## 关联

- [[Hermes Agent]]
- [[Hermes Agent从入门到精通]]
- [[学习循环]]
- [[三层记忆]]
- [[agentskills.io]]
- [[Harness Engineering]]
- [[花叔]]