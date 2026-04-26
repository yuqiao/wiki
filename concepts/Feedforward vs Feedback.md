---
title: Feedforward vs Feedback
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [concept, ai-ml, methodology]
sources:
  - raw/articles/martinfowler-harness-engineering-2026.md
---

# Feedforward vs Feedback（前馈与反馈）

> Harness Engineering 的核心框架：Guides（前馈）预期行为，Sensors（反馈）观察纠错。

## 概念 (Concept)

在 Harness Engineering 中，控制机制分为两类：

| 类型 | 名称 | 作用时机 | 目标 |
|------|------|----------|------|
| 前馈 | Guides | Agent 行动前 | 增加正确结果的概率 |
| 反馈 | Sensors | Agent 行动后 | 发现错误，触发自纠 |

**Birgitta Böckeler** 在 Martin Fowler 网站文章中提出这个框架。

## 价值 (Value)

### 为什么重要

- 把 Harness 从"一堆工具"变成有逻辑的控制系统
- 解释了为什么单独用任何一类都会失败
- 帮助规划 Harness 的完整度

### 单独使用的失败模式

| 单独使用 | 失败模式 |
|----------|----------|
| Feedback-only | Agent 重复犯同样的错误 |
| Feedforward-only | 编码规则但不知道是否生效 |

## 用法 (Usage)

### Guides（前馈）示例

| Guide | 类型 | 实现 |
|-------|------|------|
| 编码规范 | Inferential | AGENTS.md, Skills |
| 项目启动指令 | Both | Skill + bootstrap script |
| Code mods | Computational | OpenRewrite recipes |
| 架构约束 | Computational | Structural tests |

### Sensors（反馈）示例

| Sensor | 类型 | 实现 |
|--------|------|------|
| 结构测试 | Computational | ArchUnit tests, pre-commit hook |
| 类型检查 | Computational | Language Server |
| 静态分析 | Computational | Linter, custom linter |
| AI 代码审查 | Inferential | Review agent, "LLM as judge" |
| 运行测试 | Computational | Test suite |

### 关键技巧：LLM-optimized sensor signals

反馈传感器产生 LLM 可直接消费的信号，如：
- 自定义 linter 消息包含修复指令（正面的 prompt injection）
- 结构测试失败附带修复建议

## 原理 (Principle)

### Computational vs Inferential

| 执行类型 | 硬件 | 特点 | 速度 |
|----------|------|------|------|
| Computational | CPU | 确定性，可靠 | 毫秒-秒 |
| Inferential | GPU/NPU | 语义分析，非确定性 | 慢，贵 |

Computational sensors 足够便宜快，可每次变更都运行。
Inferential sensors 贵且非确定性，但提供语义判断。

### Cybernetic Governor

Harness 像控制论中的 governor，组合前馈和反馈来 regulate 代码库向期望状态。

## 心法 (Best Practices)

### Keep Quality Left

把检查尽可能早地放在生产路径上。越早发现问题，修复越便宜。

分布策略：
- **Before commit**: Linters, 快速测试套件, 基础代码审查 agent
- **Post-integration pipeline**: Mutation testing, 全面的代码审查
- **Continuous monitoring**: Dead code detection, coverage quality, dependency scanners

### Steering Loop

人的工作是迭代改进 Harness：每当问题多次发生，改进前馈和反馈控制，使其更不可能发生或直接预防。

可以用 AI 来改进 Harness：coding agents 可以帮写结构测试、生成规则草稿、scaffold 自定义 linter、创建 how-to guides。

## 关联

- [[Harness Engineering]]
- [[Birgitta Böckeler]]
- [[渐进式披露]]
- [[熵管理]]
- [[Ashby's Law]]
- [[控制论]]