---
title: CLAUDE.md
created: 2026-04-18
updated: 2026-04-18
type: concept
tags: [Agent, 记忆, Claude Code]
sources: [raw/papers/ClaudeCode从入门到精通-v2.0.0_摘要.md]
---

# CLAUDE.md

> Claude Code的项目记忆文件。给AI一张地图，让项目知识、编码规范、架构决策持久存在。

## 概念 (Concept)

CLAUDE.md是Claude Code的核心记忆机制。它是一个markdown文件，放在项目根目录，Claude Code每次启动都会读取。相当于给AI一个持久的项目记忆。

这是显式记忆系统，和传统IDE Agent隐式项目索引的本质区别。

## 价值 (Value)

### 为什么重要

- 项目知识不用每次重新解释
- 编码规范自动生效
- 架构决策持久保存
- Agent的"项目地图"

### 解决的问题

| 问题 | 无CLAUDE.md | 有CLAUDE.md |
|------|-------------|-------------|
| 项目知识传递 | 每次都要解释 | 自动加载 |
| 规范执行 | 需要每次提醒 | 自动遵循 |
| 经验积累 | 无法保存 | 写入文件 |

### 和Harness Engineering的关系

Mitchell Hashimoto（Terraform创造者）的做法：每次Agent犯错，就在CLAUDE.md里加一条规则。几周下来，CLAUDE.md变成了一份非常详细的项目规范。

这就是手动实现Harness Engineering。

## 用法 (Usage)

### 文件位置

- 项目级：项目根目录的CLAUDE.md（每个项目一份）
- 全局级：~/.claude/CLAUDE.md（所有项目共享的全局指令）

### 内容示例

```markdown
# 项目规范

## 编码风格
- 使用TypeScript，严格模式
- 函数不超过50行
- 错误处理必须用自定义类型
- commit message用英文，动词开头

## 项目结构
- src/目录下按模块分
- 测试文件放在__tests__目录
- 不要在这个项目里用any类型

## 技术栈
- Next.js 14
- Tailwind CSS
- PostgreSQL + Prisma

## 架构决策
- 2024-03-15: 决定用Server Components而非CSR
- 2024-04-01: 数据库从MySQL迁移到PostgreSQL
```

### auto-memory

Claude Code还有auto-memory功能，自动把关键信息写入MEMORY.md。这是半自动机制，人可以审核和修改。

## 原理 (Principle)

### 显式 vs 隐式记忆

| 类型 | IDE Agent | Claude Code |
|------|-----------|-------------|
| 记忆形式 | 隐式项目索引 | 显式CLAUDE.md |
| 加载方式 | 内部数据库查询 | 启动时读取文件 |
| 可读性 | 不可见 | 可见可编辑 |
| 维护 | 自动 | 手动+半自动 |

### 对比Hermes记忆

| 维度 | Claude Code | Hermes |
|------|-------------|--------|
| 记忆格式 | CLAUDE.md + auto-memory文本 | SQLite + FTS5 + Skill文件 |
| 写入方式 | 手动写，auto-memory半自动 | 全自动写入 |
| 检索方式 | 启动时全量加载 | 按需FTS5检索 |
| 自改进 | 无 | Skill自动进化 |

两者的设计哲学不同：
- Claude Code：人编写、AI执行，人有完全控制权
- Hermes：AI自写、人审核，门槛低、自动化程度高

## 心法 (Best Practices)

### 写什么

- 编码规范（函数长度、命名、错误处理）
- 项目结构（目录布局、文件位置）
- 技术栈说明（框架、数据库、工具）
- 架构决策（为什么选这个方案）
- 禁止事项（不要做什么）

### 不要写什么

- 过于琐碎的细节（Agent自己能发现）
- 过时的信息（定期清理）
- 敏感信息（密钥、密码）

### 大小控制

CLAUDE.md建议控制在几KB。太大会影响加载速度和token消耗。

### Mitchell Hashimoto的方式

每次Agent犯错，就加一条规则：
- 「不要在这个项目里用any类型。」
- 「测试文件放在__tests__目录下，不要放在src里。」
- 「commit message用英文，动词开头。」

一条一条加，Agent从一个什么都不知道的新人，变成了解项目所有暗规则的老手。

## 关联

- [[Claude Code]]
- [[Claude Code从入门到精通]]
- [[终端Agent]]
- [[Harness Engineering]]
- [[三层记忆]]（Hermes的记忆方案）
- [[花叔]]
- [[Mitchell Hashimoto]]