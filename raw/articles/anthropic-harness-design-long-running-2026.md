# Harness Design for Long-Running Application Development

> 来源：https://www.anthropic.com/engineering/harness-design-long-running-apps
> 抓取日期：2026-04-26
> 作者：Prithvi Rajasekaran (Anthropic Labs)
> 发布日期：March 24, 2026

## 核心问题

两个互联问题：
1. 让 Claude 产生高质量前端设计
2. 让 Claude 构建完整应用无需人类干预

两个领域：主观品味（前端设计） vs 可验证正确性（软件工程）

## 核心洞察：借鉴 GAN 的多智能体结构

Taking inspiration from Generative Adversarial Networks (GANs), I designed a multi-agent structure with a generator and evaluator agent.

**关键发现**：分离 Generator 和 Evaluator 是强有力的杠杆——调教一个独立的 Evaluator 使其挑剔，比让 Generator 批判自己的工作更容易。

## Why Naive Implementations Fall Short

### 两大失败模式

**模式一：Context Anxiety**

Some models also exhibit "context anxiety," in which they begin wrapping up work prematurely as they approach what they believe is their context limit.

**Context Resets vs Compaction**

| | Context Resets | Compaction |
|---|---|---|
| 定义 | 清空上下文，启动全新 Agent，结构化交接 | 原位总结早期对话，同一 Agent 继续 |
| 优点 | 干净 slate，消除 context anxiety | 保持连续性 |
| 缺点 | 交接 artifact 必须有足够状态，增加复杂度/开销 | 无法给 Agent 干净 slate，context anxiety 可能残留 |
| 适用 | Claude Sonnet 4.5（context anxiety 强） | Opus 4.5（context anxiety 弱） |

Claude Sonnet 4.5 exhibited context anxiety strongly enough that compaction alone wasn't sufficient to enable strong long task performance, so context resets became essential.

**模式二：Self-Evaluation Problem**

When asked to evaluate work they've produced, agents tend to respond by confidently praising the work—even when, to a human observer, the quality is obviously mediocre.

问题在主观任务（设计）更严重——没有类似软件测试的二进制检查。

解决方案：分离 Generator 和 Evaluator。

## 前端设计：让主观质量可评分

### 四项评分标准

I wrote four grading criteria that I gave to both the generator and evaluator agents:

| 标准 | 问题 | 检查内容 |
|------|------|----------|
| Design Quality | 设计是整体还是零件拼凑？ | 颜色、字体、布局、图像是否创造独特 mood 和 identity |
| Originality | 有自定义决策还是模板默认？ | 惩罚"AI slop"模式：紫色渐变+白色卡片 |
| Craft | 技术执行 | 字体层级、间距一致性、色彩和谐、对比度 |
| Functionality | 可用性（独立于美学） | 用户能理解界面、找到主要操作、完成任务 |

权重：Design Quality + Originality > Craft + Functionality

### 评分标准的微妙影响

The wording of the criteria steered the generator in ways I didn't fully anticipate. Including phrases like "the best designs are museum quality" pushed designs toward a particular visual convergence.

**荷兰艺术博物馆案例**：第 9 次迭代产出干净深色主题 landing page。第 10 次迭代 scrapped 整个方案，重想成空间体验：3D room with checkered floor (CSS perspective)，墙上挂艺术品，门廊导航而非滚动/点击。

## 三智能体架构

### 架构设计

```
┌─────────────────────────────────────────────────────┐
│ Planner                                             │
│ 1-4 句 prompt → 16-feature spec                     │
│ 强调 scope ambitious，不指定 granular tech details  │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ Generator ⇄ Evaluator (Sprint Contract)             │
│ 每个 Sprint 前：                                    │
│  Generator 提议 → Evaluator 审核 → 达成 agreement    │
│ Generator 实现 → Evaluator QA → 反馈                │
└─────────────────────────────────────────────────────┘
```

### Planner

- 1-4 句 prompt → full product spec
- 强调 ambitious scope
- 不指定 granular tech details（避免 spec 错误 cascade）
- 自动 weave AI features

### Generator

- one-feature-at-a-time (sprints)
- stack: React + Vite + FastAPI + SQLite/PostgreSQL
- self-evaluate at end of each sprint
- git for version control

### Evaluator

- Playwright MCP：click through running application
- test UI features, API endpoints, database states
- grade each sprint against:
  - bugs found
  - criteria: product depth, functionality, visual design, code quality
- hard threshold: any criterion below threshold → sprint fails

### Sprint Contract

Before each sprint, the generator and evaluator negotiated a sprint contract: agreeing on what "done" looked like for that chunk of work before any code was written.

**目的**：bridge gap between high-level spec and testable implementation。

Generator proposes → Evaluator reviews → iterate until agreement.

Communication via files.

## 运行结果

### Retro Game Maker

Prompt: "Create a 2D retro game maker with features including a level editor, sprite editor, entity behaviors, and a playable test mode."

| Harness | Duration | Cost | 结果 |
|---------|----------|------|------|
| Solo | 20 min | $9 | 游戏不能玩，entity wiring broken |
| Full harness | 6 hr | $200 | 可玩，AI integration，16-feature spec |

**Evaluator 发现的具体 bug 示例**：

| Contract criterion | Evaluator finding |
|--------------------|-------------------|
| Rectangle fill tool allows click-drag | FAIL — Tool only places tiles at drag start/end |
| User can select and delete entity spawn points | FAIL — Delete key handler condition wrong |
| User can reorder animation frames via API | FAIL — FastAPI route order wrong |

### 调教 Evaluator 的过程

Out of the box, Claude is a poor QA agent:
- identify legitimate issues → talk itself into deciding they're not a big deal → approve anyway
- test superficially → subtle bugs slip through

**Tuning loop**: read evaluator logs → find divergence from my judgment → update QA prompt → repeat

## Iterating on Harness

### 核心原则

Every component in a harness encodes an assumption about what the model can't do on its own, and those assumptions are worth stress testing.

> Find the simplest solution possible, and only increase complexity when needed.

### Opus 4.6 → 简化 Harness

Opus 4.6 improvements:
- plans more carefully
- sustains agentic tasks for longer
- operates more reliably in larger codebases
- better code review and debugging skills
- improved long-context retrieval

**结论**：移除 sprint construct。

Evaluator 变成 single pass at end（而非 per sprint）。

**Evaluator 的价值边界**：
- 4.5: 边界近，Evaluator 捕获有意义问题
- 4.6: 边界向外移动，tasks 在 generator 能独立完成的范围内时 evaluator 不必要
- 结论：Evaluator worth the cost when task sits beyond what current model does reliably solo

### DAW 案例

Prompt: "Build a fully featured DAW in the browser using the Web Audio API."

| Agent & Phase | Duration | Cost |
|---------------|----------|------|
| Planner | 4.7 min | $0.46 |
| Build (Round 1) | 2 hr 7 min | $71.08 |
| QA (Round 1) | 8.8 min | $3.24 |
| Build (Round 2) | 1 hr 2 min | $36.89 |
| QA (Round 2) | 6.8 min | $3.09 |
| Build (Round 3) | 10.9 min | $5.88 |
| QA (Round 3) | 9.6 min | $4.06 |
| Total | 3 hr 50 min | $124.70 |

QA Round 1 feedback:
> This is a strong app with excellent design fidelity, solid AI agent, and good backend. The main failure point is Feature Completeness — clips can't be dragged/moved on the timeline, no instrument UI panels, no visual effect editors.

QA Round 2 feedback:
> Remaining gaps: Audio recording stub-only, Clip resize/split not implemented, Effect visualizations numeric sliders not graphical

## Key Lessons

1. **Experiment with the model you're building against, read its traces on realistic problems**
2. **Decomposing task and applying specialized agents → headroom**
3. **When new model lands, re-examine harness: strip pieces no longer load-bearing, add new pieces for greater capability**

> The space of interesting harness combinations doesn't shrink as models improve. Instead, it moves, and the interesting work for AI engineers is to keep finding the next novel combination.

## Appendix: Example Plan Generated by Planner Agent

RetroForge - 2D Retro Game Maker

Overview:
RetroForge is a web-based creative studio for designing and building 2D retro-style video games. Four integrated modules: Level Editor, Sprite Editor, Entity Behavior system, Playable Test Mode.

Target: creators who love retro gaming aesthetics but want modern conveniences.

Features (16 total across 10 sprints):
1. Project Dashboard & Management
2. Tile-Based Level Editor
3. Pixel-Art Sprite Editor
4. Visual Entity Behavior System
5. Instant Playable Test Mode
6. Sprite Animation System
7. Behavior Templates Library
8. Sound Effects & Music
9. AI-Assisted Sprite Generator
10. AI-Assisted Level Designer
11. Game Export & Shareable Links
...