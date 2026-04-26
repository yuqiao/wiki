---
title: Ambient Affordances
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [concept, ai-ml, thinking]
sources:
  - raw/articles/martinfowler-harness-engineering-2026.md
---

# Ambient Affordances

> 环境本身的结构特性决定了 Agent 能做多好。Ned Letcher 提出，Birgitta Böckeler 深化。

## 概念 (Concept)

**Ambient Affordances**：环境本身的结构特性，使 Agent 在其中操作时更容易被引导、导航和处理。

Ned Letcher 的定义："structural properties of the environment itself that make it legible, navigable, and tractable to agents operating within it."

## 价值 (Value)

### 为什么重要

- 解释了为什么同样的 Harness 在不同代码库效果差异巨大
- 为「绿地 vs 棁地」项目差异提供了理论框架
- 帮助理解哪些环境特性值得投资

### 解决的问题

- 为什么棕地项目 Harness 难建？
- 如何选择让 Agent 更容易成功的技术栈？

## 用法 (Usage)

### 环境特性示例

| 特性 | Affordance | Harnessability |
|------|------------|----------------|
| 强类型语言 | 类型检查天然作 sensor | 高 |
| 清晰模块边界 | 方便定义架构约束 | 高 |
| Spring 等框架 | 抽象细节，Agent 不需操心 | 高 |
| 无类型语言 | 无类型检查 sensor | 低 |
| 模糊边界 | 无法定义架构约束 | 低 |

### 绿地 vs 棁地

**绿地项目**：从 day one 把 harnessability 植入——技术选型、架构决策决定代码库的可治理性。

**棕地项目**：技术债积累的应用——Harness 最需要的地方最难建。比作"在从未用过静态分析工具的代码库上运行静态分析——你会被警报淹没"。

## 原理 (Principle)

### 为什么有效

环境特性不是 Harness 的组件，而是 Harness 能否有效的前提条件。就像：
- 好的地基让房子更容易建
- 清晰的地图让导航更容易
- 结构化的数据让查询更高效

### 与 Ashby's Law 的关联

Ashby's Law 说：regulator 必须有至少与系统同样的 variety，且只能 regulate 它有 model 的东西。

环境结构化程度越高 → variety 越 narrow → comprehensive Harness 越 achievable。

## 心法 (Best Practices)

### 绿地项目

- 技术选型时考虑 harnessability
- 选择有清晰抽象的框架
- 从 day one 建模块边界

### 棁地项目

- 先简化环境再建 Harness（variety-reduction）
- 选择性地在局部应用 Harness
- 接受"最需要的地方最难建"的现实

## 关联

- [[Harness Engineering]]
- [[Birgitta Böckeler]]
- [[Ashby's Law]]
- [[棕地项目改造]]
- [[绿地项目]]