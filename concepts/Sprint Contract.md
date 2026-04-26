---
title: Sprint Contract
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [technique, ai-ml, agent]
sources:
  - raw/articles/anthropic-harness-design-long-running-2026.md
---

# Sprint Contract（冲刺契约）

> 每个 Sprint 前 Generator 和 Evaluator 协商"完成标准"。

## 概念 (Concept)

**Sprint Contract**：在开始每个 Sprint（工作单元）之前，Generator Agent 和 Evaluator Agent 协商达成的一份契约，明确约定"完成"（done）的具体标准。

Anthropic Labs 工程师 Prithvi Rajasekaran 在三智能体架构中提出。

## 价值 (Value)

### 解决什么问题

Product Spec 是高层级的，而实现需要可测试的具体标准。Sprint Contract 桥接这个差距：

> This existed because the product spec was intentionally high-level, and I wanted a step to bridge the gap between user stories and testable implementation.

### 避免 Spec 错误 Cascade

Planner 不指定 granular tech details，因为：
> if the planner tried to specify granular technical details upfront and got something wrong, the errors in the spec would cascade into the downstream implementation.

Sprint Contract 让 Generator 和 Evaluator 在实现前协商，避免错误传播。

## 用法 (Usage)

### 协商流程

```
Generator proposes:
  - what it will build
  - how success will be verified
  
Evaluator reviews:
  - is generator building the right thing?
  - are verification criteria sufficient?
  
Iterate until agreement:
  - both agents sign off on contract
  - contract recorded in file
```

### 通信方式

Communication was handled via files: one agent would write a file, another agent would read it and respond either within that file or with a new file.

文件是天然的协作表面，多 Agent 可通过共享文件协调。

### Contract 内容

每个 Sprint Contract 包含：
- 具体实现细节
- 可测试的行为（testable behaviors）
- 验证完成的标准

**粒度示例**：Sprint 3 alone had 27 criteria covering the level editor。

## 原理 (Principle)

### 为什么有效

1. **事前约定优于事后评判**：先明确标准，再实现，避免"你做的不是我想要的"
2. **Generator 和 Evaluator 对齐**：两个 Agent 在实现前达成共识
3. **可追溯性**：Contract 记录在文件，可回溯

### 与敏捷开发的关系

类比敏捷开发的 Sprint Planning + Acceptance Criteria，但：
- Generator 对应开发团队
- Evaluator 对应 QA/Product Owner
- Contract 对应 Sprint Goal + Acceptance Criteria

## 心法 (Best Practices)

### Contract 粒度

- 太粗：Evaluator 无法精确评判
- 太细：Generator 被过度约束
- 适中：足够具体可测试，足够灵活让 Generator 创造性实现

### 文件命名约定

建议命名：
- `sprint-N-contract.md`
- `sprint-N-proposal.md`（Generator 提议）
- `sprint-N-review.md`（Evaluator 审核）

### 失败处理

如果 Sprint 失败（Evaluator 发现问题）：
- 详细反馈写入文件
- Generator 修复
- 重新提交
- Evaluator 重新评判

## 关联

- [[Prithvi Rajasekaran]]
- [[Anthropic]]
- [[Generator-Evaluator分离]]
- [[三智能体架构]]
- [[Harness Engineering]]
- [[渐进式披露]]