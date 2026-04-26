---
title: Executable Governance
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [concept, ai-ml, governance, harness-engineering]
sources:
  - raw/articles/martinfowler-encoding-team-standards-2026.md
---

# Executable Governance

## 概念

**Executable Governance（可执行治理）**：将团队标准编码为可执行 AI 指令，使标准从"文档"变为"应用"。

> A team standard encoded as an AI instruction does not depend on someone remembering to apply it. **The instruction is the application.**

核心洞察：团队标准历来存在"文档与实践之间的鸿沟"——wiki 上的 checklist 依赖人去读、记住、在时间压力下一致地应用。AI 指令改变了这个动态。

## 价值

### 解决一致性问题

当 AI-assisted 开发依赖谁在 prompting：
- 资深工程师成为瓶颈——他们知道要问什么
- 同样代码库、同样 AI、不同开发者产生完全不同的质量门槛

**这是系统问题，不是技能问题。**

### 隐性知识规模化

资深工程师的直觉（检查什么模式、执行什么惯例、标记什么风险）不再是个人的、不可扩展的。它们可以：
- 提取
- 编码为版本化指令
- 一致地应用于每个开发者与 AI 的每次交互

### 与传统治理对比

| 传统治理 | Executable Governance |
|----------|----------------------|
| Wiki checklist | 版本化指令集 |
| 依赖人记住 | 指令自动执行 |
| 培训 juniors | 系统化预防 |
| 隐性知识在资深者脑中 | 隐性知识编码进仓库 |

## 用法

### 两个动作

| Move | Description |
|------|-------------|
| From tacit to explicit | 提取资深工程师的隐性知识，转化为结构化指令集。目标格式不是 wiki 页面，而是 AI 可执行的结构化指令 |
| From documentation to execution | Linting rules 是版本化配置，CI/CD 是可执行定义。AI 指令属于同一类别 |

### 指令解剖学

四元素结构：

| Element | Purpose |
|---------|---------|
| Role definition | 设定专业水平和视角。"Role: senior engineer implementing a new service following the team's architectural patterns" |
| Context requirements | 明确依赖项：相关代码、架构上下文、约束 |
| Categorized standards | 分类优先级编码团队判断。生成指令：architectural compliance (must)、convention adherence (should)、style preferences (nice to have) |
| Output format | 结构化输出（summary、分类发现、下一步），确保跨开发者可比 |

### 应用场景

| 交互 | 编码内容 |
|------|----------|
| Generation | 团队构建新代码的方式（架构模式、命名、错误处理、测试期望） |
| Refactoring | 团队改进现有代码的方式（保持契约、避免过早抽象、增量变更） |
| Security | 团队威胁模型（检查什么、严重程度分级） |
| Review | 团队检查什么（架构对齐、错误处理、类型安全、惯例） |

### 隐性知识提取访谈

结构化问题映射：

| Question | Maps To |
|----------|---------|
| What architectural decisions should never be left to individual judgment? | Generation constraints |
| Which conventions are corrected most often in generated code? | Convention checks |
| Which security checks are applied instinctively? | Threat-model items |
| What triggers an immediate rejection in review? | Critical checks |
| What separates a clean refactoring from an over-engineered one? | Refactoring philosophy |

### 起步建议

**一个指令起步**。Generation 或 Review 指令通常是最高价值选择：
- 最常见工作流
- 最宽质量差距
- 最可见不一致性

后续指令跟随采用，而非领先采用。

## 原理

### 标准作为共享基础设施

个人机器上的 prompt 是个人生产力技巧。同一 prompt 在团队仓库里是基础设施。

仓库化继承版本化工件属性：
- 变更可追踪
- 标准集体拥有
- 每个开发者用同一版本

> Priming document tells the AI how the project works. Executable instruction tells the AI how the team works.

### 维护机制

仓库位置和 PR review 缓解"文档墓地"风险：
- 出现在 diffs 中
- 可引用在 PR templates 中
- 偏移在日常工作中可见

> The closer the artifact is to the workflow, the more likely it is to be maintained.

### 团队规模启发式

| Team Size | Need |
|-----------|------|
| Teams of 5 | May not need this |
| Teams of 15 | Almost certainly do |

**信号**：AI-assisted 输出质量明显随谁 prompting 变化，或生成和 review 工作路由到少数人因为他们知道如何有效 prompting。

## 心法

### 不是每个交互都需要专用指令

过度规定会变得脆弱：边缘情况产生假阳性、与合法方法变体冲突。

### 指令小而单一目的

小指令保持聚焦、易维护、灵活组合。

### 团队拥有的进化机制

- 活在仓库里
- 通过 PR 进化
- 实践暴露缺口时改进

> The standards are not just the output of team knowledge; they are the mechanism through which team knowledge gets codified, shared, and refined.

---

## 相关概念

- [[Harness Engineering]] — 大框架，给 AI 建约束系统
- [[Birgitta Böckeler]] — Guides/Sensors 框架提出者
- [[Rahul Garg]] — Executable Governance 提出者
- [[CLAUDE.md]] — 项目记忆文件，手动 Executable Governance 实践
- [[Ashby's Law]] — 必要多样性定律，定义 topology 是 variety-reduction move
- [[Ambient Affordances]] — 环境结构决定 Harness 能做多好