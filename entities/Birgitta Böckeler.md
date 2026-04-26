---
title: Birgitta Böckeler
created: 2026-04-26
updated: 2026-04-26
type: entity
tags: [person, ai-ml, thoughtworks]
sources:
  - raw/articles/martinfowler-harness-engineering-2026.md
---

# Birgitta Böckeler

> Thoughtworks Distinguished Engineer，AI-assisted delivery 专家。Harness Engineering 系统化梳理者。

## 简介

Birgitta Böckeler 是 Thoughtworks 的 Distinguished Engineer 和 AI-assisted delivery 专家，拥有超过 20 年软件开发、架构和技术领导经验。

2026 年 4 月，她在 Martin Fowler 网站发表《Harness engineering for coding agent users》，系统化梳理了 Harness Engineering 的核心概念，提出了 Guides/Sensors 框架、三种 Regulation categories、Harnessability 等关键概念。

## 核心贡献

### Harness Engineering 系统化

Böckeler 将 Harness Engineering 从模糊概念变成可操作的框架：

| 概念 | 说明 |
|------|------|
| Guides (feedforward) | 预期行为，事前引导 |
| Sensors (feedback) | 观察结果，事后纠错 |
| Computational | CPU 执行，确定性，快 |
| Inferential | GPU/NPU 执行，语义分析，慢但丰富 |

### 三种 Regulation categories

1. **Maintainability harness** — 内部代码质量，现有工具最多
2. **Architecture fitness harness** — 架构特性，Fitness Functions
3. **Behaviour harness** — 功能正确性，"房间里的大象"

### Harnessability 与 Ambient affordances

提出「Ambient affordances」概念（与 Ned Letcher 合作）：环境本身的结构特性决定了 Harness 能做多好。强类型语言天然有类型检查作 sensor，清晰模块边界方便定义架构约束。

### 绿地 vs 棕地项目洞察

> 所有公开成功案例都是绿地项目。棕地项目改造是最大挑战——Harness 最需要的地方最难建。

比作"在从未用过静态分析工具的代码库上运行静态分析——你会被警报淹没"。

### 对 AI 生成测试的尖锐批评

> 很多团队只是让 AI 生成测试套件然后看它是否绿色通过，但这 puts a lot of faith into AI-generated tests, **that's not good enough yet**——用 AI 生成的测试来验证 AI 生成的代码，本质上是在用同一双眼睛检查自己的作业。

## 关键洞见

- "行为验证体系几乎缺席" — 功能正确性验证是被严重忽视的领域
- "Harness templates 可能成为未来的服务模板" — 预定义的 guides + sensors 捆绑包
- "好的 Harness 不是消除人工输入，而是把它导向最重要的地方"
- Ashby's Law 应用：定义 topology 是 variety-reduction move

## 关联

- [[Harness Engineering]]
- [[Thoughtworks]]
- [[Martin Fowler]]
- [[OpenAI]]（Harness 实战案例引用）
- [[Stripe]]（Minions 系统引用）
- [[Ambient Affordances]]（提出者之一）
- [[Ashby's Law]]（应用于 Harness）
- [[棕地项目改造]]（核心挑战）
- [[Rahul Garg]] — Thoughtworks 同僚，Executable Governance 提出者