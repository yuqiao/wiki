---
title: Ashby's Law
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [principle, thinking, ai-ml]
sources:
  - raw/articles/martinfowler-harness-engineering-2026.md
---

# Ashby's Law (必要多样性定律)

> Regulator 必须有至少与系统同样的 variety，且只能 regulate 它有 model 的东西。应用于 Harness Engineering。

## 概念 (Concept)

**Ashby's Law of Requisite Variety**：控制系统的多样性必须至少等于被控制系统的多样性。一个 regulator 只能控制它有 model 的东西。

来自控制论（Cybernetics），由 W. Ross Ashby 提出。

## 价值 (Value)

### 为什么重要

- 解释了为什么全面 Harness 难以实现
- 为「定义 topology」提供了理论依据
- 帮助理解为什么选择有限的技术栈有意义

### 在 Harness Engineering 中的应用

Birgitta Böckeler 的应用：

> LLM-based coding agent 可以产生几乎任何东西，但 committing to a topology narrows that space，使 comprehensive Harness 更 achievable。Defining topologies is a variety-reduction move.

## 用法 (Usage)

### Variety-Reduction 策略

| 策略 | 说明 | 效果 |
|------|------|------|
| 定义 topology | 限制代码结构空间 | Narrow variety |
| 预定义 Harness templates | 限制 guides/sensors 范围 | Narrow variety |
| 技术栈标准化 | 限制技术选择 | Narrow variety |

### 为什么有效

Agent 能产生几乎任何代码 → variety 无限 → 无法 build comprehensive Harness

定义 topology → variety 变窄 → Harness 变 achievable

## 原理 (Principle)

### Cybernetics 基础

控制论的核心定律：
- Regulator 的 variety ≥ System 的 variety
- Regulator 只能控制它有 model 的部分

类比：
- 警察数量必须匹配犯罪类型多样性
- 医生知识必须匹配疾病多样性
- Harness sensors 必须匹配代码问题多样性

## 心法 (Best Practices)

### Harness 设计

- 不要试图覆盖所有可能性
- 先定义 topology（variety-reduction）
- 针对有限范围 build comprehensive Harness

### Harness Templates

预定义的 guides + sensors 捆绑包 = 针对特定 topology 的 variety-matched Harness。

团队可能基于已有 Harness templates 选择技术栈，就像今天从服务模板实例化新服务。

## 关联

- [[Harness Engineering]]
- [[Birgitta Böckeler]]
- [[Ambient Affordances]]
- [[Harness Templates]]
- [[控制论]]