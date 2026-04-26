---
title: Generator-Evaluator分离
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [technique, ai-ml, agent, architecture]
sources:
  - raw/articles/anthropic-harness-design-long-running-2026.md
---

# Generator-Evaluator分离

> 做工作的 Agent 和评判工作的 Agent 分开。

## 概念 (Concept)

**Generator-Evaluator 分离**：借鉴 GAN（Generative Adversarial Networks）思路，将 Agent 系统分为两个角色——Generator（生成者）负责生产，Evaluator（评判者）负责质检。

Anthropic Labs 工程师 Prithvi Rajasekaran 提出。

## 价值 (Value)

### 解决什么问题

**Self-Evaluation Problem**：Agent 评判自己工作时，倾向于过度宽容。

> When asked to evaluate work they've produced, agents tend to respond by confidently praising the work—even when, to a human observer, the quality is obviously mediocre.

问题在主观任务（设计）更严重，因为没有类似软件测试的二进制检查。

### 为什么分离有效

> Separating the agent doing the work from the agent judging it proves to be a strong lever... tuning a standalone evaluator to be skeptical turns out to be far more tractable than making a generator critical of its own work.

调教一个独立的 Evaluator 使其挑剔，比让 Generator 批判自己的工作更容易。

一旦外部反馈存在，Generator 有具体的东西可以迭代。

## 用法 (Usage)

### 前端设计案例

Generator：创建 HTML/CSS/JS 前端
Evaluator：用 Playwright MCP 导航页面、截图、评分四项标准、写详细 critique

流程：
```
Generator creates → Evaluator navigates & screenshots → 
Evaluator grades & critiques → Feedback flows back to Generator →
Generator refines → repeat (5-15 iterations)
```

### 全栈开发案例

Generator：实现 feature
Evaluator：用 Playwright MCP click through running application，test UI/API/database，grade against criteria

硬阈值：任何 criterion 低于阈值 → sprint fails → Generator 得详细反馈

### 调教 Evaluator 的过程

Out of the box, Claude is a poor QA agent：
- identify legitimate issues → talk itself into deciding they're not a big deal
- test superficially → subtle bugs slip through

**Tuning loop**：
1. read evaluator logs
2. find divergence from human judgment
3. update QA prompt
4. repeat

需要多轮迭代才能让 Evaluator 评判合理。

## 原理 (Principle)

### GAN 类比

GAN：Generator 生成图像，Discriminator 判断真假，对抗训练使 Generator 产出越来越真实。

Agent 系统：Generator 产出代码/设计，Evaluator 评判质量，迭代使 Generator 产出越来越高质量。

**关键区别**：
- GAN 是训练时的对抗
- Agent 系统是推理时的对抗

### 为什么 Generator 无法自评

心理学类比：人难以客观评判自己的作品（"用同一双眼睛检查自己的作业"）。

LLM 有类似倾向：对 LLM 生成的输出宽容。

### Evaluator 的价值边界

Evaluator worth the cost when task sits beyond what current model does reliably solo。

| 模型 | 任务边界 | Evaluator 价值 |
|------|----------|----------------|
| Opus 4.5 | 边界近 | 捕获有意义问题 |
| Opus 4.6 | 边界向外移动 | 范围内任务 evaluator 不必要 |

## 心法 (Best Practices)

### Evaluator Prompt 设计

关键：让 Evaluator 挑剔而非宽容。

技巧：
- 明确评分标准（而非"好不好"）
- 设置硬阈值（低于阈值 → fail）
- Few-shot examples with detailed score breakdowns
- 惩罚 generic patterns（如"AI slop"）

### 评分标准设计

前端设计四项标准（Anthropic 案例）：
- Design Quality（整体 vs 零件）
- Originality（自定义 vs 模板）
- Craft（技术执行）
- Functionality（可用性）

权重：Design Quality + Originality > Craft + Functionality

### 工具配置

Evaluator 需要工具来"审视"产出：
- Playwright MCP：导航页面、截图
- Test runner：执行测试
- Logs：查看运行日志

### 分离程度

完全分离（不同 session） > 部分 separation（同一 session 不同 prompt）

Context Resets 时完全分离更自然。

## 关联

- [[Prithvi Rajasekaran]]
- [[Anthropic]]
- [[三智能体架构]]
- [[Sprint Contract]]
- [[Context Resets]]
- [[Harness Engineering]]
- [[Playwright MCP]]