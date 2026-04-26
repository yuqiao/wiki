---
title: Harness Engineering
created: 2026-04-24
updated: 2026-04-26
type: concept
tags: [方法论, AI编程, Agent, 六层架构]
sources:
  - raw/papers/Hermes-Agent-从入门到精通_摘要.md
  - raw/articles/javaguide-harness-engineering-2026.md
  - raw/articles/martinfowler-harness-engineering-2026.md
  - raw/articles/langchain-anatomy-of-agent-harness-2026.md
  - raw/articles/anthropic-harness-design-long-running-2026.md
  - raw/articles/anthropic-harnessing-claudes-intelligence-2026.md
---

# Harness Engineering

> 给AI造缰绳的方法论。Mitchell Hashimoto（Terraform创造者）在2026年初命名。

## 概念 (Concept)

Harness Engineering是一套方法论，核心思想是：**瓶颈不是模型，是环境**。LangChain团队实验证明：用同一个模型，只调整周围的「缰绳」配置，成绩从52.8%涨到66.5%，排名从Top 30跳到Top 5——模型一行没改。

## 价值 (Value)

### 为什么重要

- 解决了AI Agent「越强越难管」的悖论
- 让Agent在能力增长的同时保持可控
- 把人的角色从「盯着AI干活」变成「设计AI怎么干活」

### 解决的问题

- Agent重复犯同样的错误
- 项目知识无法持久传递
- 行为约束需要持续手动维护

## 用法 (Usage)

### 六层架构（成熟 Harness）

| 层级 | 名称 | 解决什么问题 | 关键设计 |
|------|------|-------------|----------|
| L1 | 信息边界层 | Agent 该知道什么、不该知道什么 | 定义角色与目标，裁剪无关信息 |
| L2 | 工具系统层 | Agent 怎么跟外部世界交互 | 工具的选拔、调用时机、结果提炼 |
| L3 | 执行编排层 | 多步骤任务怎么串起来 | 完整轨道：理解→判断→分析→生成→检查 |
| L4 | 记忆与状态层 | 长任务中间结果怎么管 | 独立管理当前状态、中间产物、长期记忆 |
| L5 | 评估与观测层 | Agent 怎么知道自己做对了没有 | 独立验证机制，让 Agent 具备"自知之明" |
| L6 | 约束、校验与恢复层 | 出错了怎么办 | 预设规则拦截错误，提供重试或回滚 |

**投入产出比最高**: L1（信息边界）+ L6（约束与恢复）。L1 决定 Agent 知道该干什么，L6 决定它搞砸了能不能拉回来。

### Birgitta Böckeler 的 Guides/Sensors 框架（2026）

**[[Birgitta Böckeler]]** 在 Martin Fowler 网站提出更精细的控制框架：

| 类型 | 名称 | 作用时机 | 目标 |
|------|------|----------|------|
| Guides | Feedforward（前馈） | Agent 行动前 | 增加正确结果的概率 |
| Sensors | Feedback（反馈） | Agent 行动后 | 发现错误，触发自纠 |

**执行类型**：

| 类型 | 硬件 | 特点 | 速度 |
|------|------|------|------|
| Computational | CPU | 确定性，可靠 | 毫秒-秒 |
| Inferential | GPU/NPU | 语义分析，非确定性 | 慢，贵 |

单独使用的失败模式：
- **Feedback-only**: Agent 重复犯同样的错误
- **Feedforward-only**: 编码规则但不知道是否生效

### 三种 Regulation Categories（Birgitta Böckeler）

| 类别 | 调节什么 | 难度 | 现有工具 |
|------|----------|------|----------|
| Maintainability harness | 内部代码质量 | 低 | 最多 |
| Architecture fitness harness | 架构特性 | 中 | Fitness Functions |
| Behaviour harness | 功能正确性 | 高 | 几乎缺席 |

**Behavior harness 是"房间里的大象"**：如何引导和感知应用功能是否正确？

当前主流做法：
- Feed-forward: 功能规格（从简短提示到多文件描述）
- Feedback: AI 生成的测试套件是否绿色

**Böckeler 的尖锐批评**：
> 这 puts a lot of faith into AI-generated tests, that's not good enough yet——用 AI 生成的测试验证 AI 生成的代码，本质上是用同一双眼睛检查自己的作业。

### Harnessability（环境可治理性）

**[[Ambient Affordances]]**：环境本身的结构特性决定了 Harness 能做多好。

- 强类型语言天然有类型检查作 sensor
- 清晰模块边界方便定义架构约束
- Spring 等框架抽象细节，Agent 不需操心

**绿地 vs 棁地**：
- **绿地项目**：从 day one 把 harnessability 植入
- **棕地项目**：Harness 最需要的地方最难建——比作"在从未用过静态分析工具的代码库上运行静态分析"

### Ashby's Law 应用

**[[Ashby's Law]]**：regulator 必须有至少与系统同样的 variety，只能 regulate 它有 model 的东西。

应用：
> LLM-based coding agent 可以产生几乎任何东西，但 committing to a topology narrows that space。Defining topologies is a variety-reduction move。

**Harness templates**：预定义的 guides + sensors 捆绑包，可能成为未来的服务模板。

### 开放问题（Birgitta Böckeler）

- 如何保持 Harness 随增长保持 coherent？guides 和 sensors 同步、不互相矛盾？
- 当指令和反馈信号指向不同方向时，能信任 Agent 做合理权衡吗？
- 如果 sensors 从不触发，是高质量还是检测机制不足？
- 需要 harness coverage/quality 的评估方法，类似测试的 code coverage 和 mutation testing

### LangChain 的五组件推导（Vivek Trivedy）

**[[Vivek Trivedy]]** 在 LangChain 博客提出从"模型做不到什么"推导 Harness 设计：

> If you're not the model, you're the harness.

| 模型做不到 | Harness 补什么 | 核心组件 |
|------------|----------------|----------|
| 持久状态 | 文件系统抽象 + fs-ops | Filesystem |
| 执行代码 | Bash + 通用工具 | Bash + Code exec |
| 安全执行 | Sandbox 环境 | Sandboxes |
| 记忆/新知识 | AGENTS.md + Web Search | Memory & Search |
| 上下文衰减 | Compaction + Skills | Context Management |

### Context Rot（Vivek Trivedy）

**[[Context Rot]]**：上下文窗口填满时，模型推理能力下降、任务完成质量变差。

Harness 对抗策略：
- **Compaction**：上下文接近填满时智能压缩
- **Tool call offloading**：保留工具输出头尾 token，完整输出存文件
- **Skills**：渐进式披露，只保留 front-matter 在上下文
- **Ralph Loop**：拦截模型退出，在干净上下文强制继续

### Model-Harness Coupling 洞察（LangChain）

Agent 产品（Claude Code、Codex）训练时包含模型和 Harness，形成反馈循环：
- 有用的 primitives 被发现 → 加入 Harness → 用于训练下一代模型

**副作用**：改变工具逻辑导致模型表现变差（过拟合）。

**关键发现**：最好的 Harness 不是模型训练时用的那个。Terminal Bench 2.0 显示 Opus 4.6 在 Claude Code Harness 下得分远低于其他 Harness。

LangChain 实验：只改 Harness，排名 Top 30 → Top 5。

### Harness 未来方向（LangChain）

- Orchestration: 数百 Agent 并行工作在共享代码库
- Self-analysis: Agent 分析自己 traces，识别 Harness-level 失败
- Dynamic assembly: 按任务动态组装工具和上下文

### Anthropic 的三智能体架构（Prithvi Rajasekaran）

**[[Prithvi Rajasekaran]]** 在 Anthropic Labs 博客提出借鉴 GAN 思路的三智能体架构：

> Taking inspiration from Generative Adversarial Networks (GANs), I designed a multi-agent structure with a generator and evaluator agent.

**架构**：Planner → Generator ⇄ Evaluator

| 角色 | 职责 |
|------|------|
| Planner | 1-4 句 prompt → 16-feature spec，强调 ambitious scope |
| Generator | one-feature-at-a-time (sprints)，self-evaluate at end |
| Evaluator | Playwright MCP click through running app，grade against criteria |

**解决的核心问题**：

| 问题 | 表现 | 解法 |
|------|------|------|
| Context Anxiety | Sonnet 4.5 快到上下文上限时草草收工 | Context Resets + 结构化交接 |
| Self-Evaluation | Agent 自信满满夸自己做得好 | Generator-Evaluator 分离 |

### Context Resets vs Compaction（Anthropic）

明确区分两种策略：

| | Context Resets | Compaction |
|---|---|---|
| 定义 | 清空上下文，启动全新 Agent | 原位总结早期对话 |
| Slate | 干净 | 不干净 |
| Context Anxiety | 消除 | 可能残留 |
| 适用模型 | Sonnet 4.5（context anxiety 强） | Opus 4.5+（context anxiety 弱） |

### Generator-Evaluator 分离（Anthropic）

核心洞察：调教独立 Evaluator 使其挑剔，比让 Generator 批判自己更容易。

> Separating the agent doing the work from the agent judging it proves to be a strong lever... tuning a standalone evaluator to be skeptical turns out to be far more tractable than making a generator critical of its own work.

原因：Out of the box, Claude is a poor QA agent——identify issues → talk itself into deciding they're not a big deal。

### Sprint Contract（Anthropic）

每个 Sprint 前 Generator 和 Evaluator 协商"完成标准"：

> Before each sprint, the generator and evaluator negotiated a sprint contract: agreeing on what "done" looked like before any code was written.

目的：bridge gap between high-level spec and testable implementation。

**粒度示例**：Sprint 3 alone had 27 criteria covering the level editor。

### 前端设计评分标准（Anthropic）

四项评分标准（权重 Design Quality + Originality > Craft + Functionality）：

| 标准 | 检查内容 |
|------|----------|
| Design Quality | 整体 vs 零件拼凑，颜色/字体/布局创造独特 mood |
| Originality | 自定义决策 vs 模板默认，惩罚"AI slop"模式 |
| Craft | 技术执行：字体层级、间距、色彩和谐 |
| Functionality | 可用性：用户能理解界面、找到操作 |

### Harness 简化原则（Anthropic）

> Every component in a harness encodes an assumption about what the model can't do on its own, and those assumptions are worth stress testing.

> Find the simplest solution possible, and only increase complexity when needed.

**Opus 4.6 → 移除 sprint construct**：Evaluator 变成 single pass at end。

**Evaluator 的价值边界**：worth the cost when task sits beyond what current model does reliably solo。

### Harness 组合空间（Anthropic）

> The space of interesting harness combinations doesn't shrink as models improve. Instead, it moves, and the interesting work for AI engineers is to keep finding the next novel combination.

### Claude Intelligence 三大模式（Lance Martin）

Anthropic Claude Platform 团队成员 Lance Martin 在《Harnessing Claude's Intelligence》提出：

| 模式 | 核心思想 |
|------|----------|
| Use what Claude knows | 用 Claude 理解的工具构建应用（bash + text editor） |
| Ask "what can I stop doing?" | 测试 harness 中关于 Claude 不能做的假设 |
| Set boundaries carefully | 用 declarative tools 设定 UX/安全/可观测边界 |

**"Grown more than built"**（Chris Olah）：
> Generative AI systems like Claude are grown more than they are built. Researchers set the conditions to direct growth, but the exact structure or capabilities that emerge aren't always predictable.

**Orchestration Decision**：决定工具调用结果如何处理的决策。从 harness 移到 model。

- 传统假设：every tool result should flow back through context window
- Lance Martin 提出：Give Claude code execution tool，让它自己编排
- BrowseComp：Opus 4.6 accuracy 45.3% → 61.6%（+16.3%）

**Context Management 策略**：

| 策略 | 机制 | 效果 |
|------|------|------|
| Skills | YAML frontmatter pre-loaded，渐进披露 | 减少 pre-loaded tokens |
| Context editing | 移除 stale context | 清理旧工具结果/thinking blocks |
| Subagents | Fork fresh context | Opus 4.6 BrowseComp +2.8% |
| Compaction | Claude 总结过去上下文 | Opus 4.6 BrowseComp 84%（vs Sonnet 4.5 43%） |
| Memory folder | 写上下文到文件 | Sonnet 4.5 BrowseComp-Plus 60.4% → 67.2% |

**Cache Optimization**：

| Principle | Description |
|-----------|-------------|
| Static first, dynamic last | stable content first |
| Messages for updates | append `<system-reminder>` |
| Don't change models | caches are model-specific |
| Carefully manage tools | tools in cached prefix |
| Update breakpoints | move to latest message |

Cached tokens: 10% cost of base input tokens.

**Auto-mode Pattern**：second Claude reads bash command and judges safety。Limits need for dedicated tools。

**Context Anxiety Evolution**：
- Sonnet 4.5：wrap up prematurely → added resets
- Opus 4.5：behavior gone → resets became dead weight

> Removing this dead weight is important because it can bottleneck Claude's performance.

### 五组件模型（简化版）

| 组件 | 说明 | 手动实现 | Hermes内建 |
|------|------|----------|------------|
| 指令层 | 告诉AI做什么 | 手写CLAUDE.md / AGENTS.md | Skill系统 |
| 约束层 | 限制AI不能做什么 | 配置hooks / linter / CI | Tool permissions + sandbox |
| 反馈层 | 让AI知道做得对不对 | 人工审查 / 评估者Agent | 自改进学习循环 |
| 记忆层 | 存储知识和经验 | 手动维护knowledge base | 三层记忆 + Honcho |
| 编排层 | 多Agent协作 | 自己搭pipeline | 子Agent委派 + cron |

### 实施心法：验证而非教导

**核心洞察**：与其教 agent 怎么做，不如让它验证做得对不对。靠代码、linter、测试来保证正确性，而不是靠 LLM 的"直觉"。

把"对不对"的判断从 LLM 脑子里移出来，交给工程工具链：

#### 1. 测试优先

```python
# ❌ 告诉 agent "写一个排序函数"
# ✅ 给 agent 测试，让它跑通

def test_sort():
    assert sort([3,1,2]) == [1,2,3]
    assert sort([]) == []
    assert sort([1]) == [1]
```

agent 不需要"理解"排序，只需要让测试通过。测试是客观的裁判。

#### 2. 类型契约

```typescript
// ❌ 靠 prompt 说"返回用户对象"
// ✅ 用类型系统强制

interface User {
  id: string;
  name: string;
}
function getUser(id: string): User  // 类型检查器强制执行
```

#### 3. Linter + 格式化

- agent 生成代码 → `ruff check` / `eslint` 自动报错
- 不用说服它"写规范代码"，lint 不通过就重来
- 错误消息本身就是修正指令

#### 4. 沙箱执行验证

```bash
# ❌ 问 agent "这个脚本对吗？"
# ✅ 跑一下看结果

docker run --rm my-script && echo "OK"
```

实际跑一遍，退出码 0 就是正确。

#### 5. 结构化输出 + Schema 验证

```python
# 用 Pydantic/Outlines 强制输出格式
from pydantic import BaseModel

class Response(BaseModel):
    action: Literal["create", "delete"]
    target: str

response = Response.model_validate_json(llm_output)  # 不符合就报错
```

#### 对比总结

| ❌ 靠 LLM | ✅ 靠 Harness |
|---------|-------------|
| "写正确的代码" | 写能通过测试的代码 |
| "输出 JSON 格式" | Schema 验证失败就重试 |
| "这个逻辑对吗？" | 跑一下看结果 |
| "注意边界情况" | 测试覆盖边界情况 |
| "理解需求" | 让测试描述需求 |

**本质**：把 LLM 当成"搜索解空间"的引擎，验证正确性的"裁判"交给工具。这样：
- 不需要 prompt engineering 到完美
- 不依赖 LLM 的"理解"
- 可复现、可调试、可量化

### Mitchell Hashimoto的做法

每次Agent犯了一个错，就在CLAUDE.md里加一条规则：
- 「不要在这个项目里用any类型。」
- 「测试文件放在__tests__目录下，不要放在src里。」
- 「commit message用英文，动词开头。」

一条一条加，几周下来，CLAUDE.md变成了一份非常详细的项目规范。

## 原理 (Principle)

### 为什么有效

缰绳不是限制，是引导。好的Harness让Agent：
1. 知道做什么（指令层）
2. 知道不能做什么（约束层）
3. 知道做得对不对（反馈层）
4. 记住过去的教训（记忆层）
5. 能分工协作（编排层）

### 核心洞察

> "缰绳是活的，一直在长。" — Mitchell Hashimoto

### 瓶颈不在模型

**关键实验**：Can.ac 用同一个模型，只换了文件编辑接口的调用方式，编码基准分数从 6.7% 直接跳到 68.3%。模型没变，变的是外围的那套系统。

### 上下文 40% 阈值

Dex Horthy 观察到：168K token 的上下文窗口，用到大约 40% 的时候，Agent 的输出质量就开始明显下降。

| 区间 | 占比 | 表现 |
|------|------|------|
| Smart Zone | 0 - ~40% | 推理聚焦、工具调用准确、代码质量高 |
| Dumb Zone | 超过 ~40% | 幻觉增多、兜圈子、格式混乱、低质量代码 |

**工程建议**：设置 40% 阈值告警——当 Agent 的上下文占用超过这个比例时，就应该触发上下文压缩或任务交接。

## 心法 (Best Practices)

### OpenAI 实战案例

2026年2月，OpenAI 发布《Harness Engineering: Leveraging Codex in an Agent-First World》，披露了他们如何用 Codex Agent 从零构建了一个完整的内部产品：

| 指标 | 数值 |
|------|------|
| 团队规模 | 3 名工程师（后扩至 7 人） |
| 持续时间 | 5 个月（2025 年 8 月起） |
| 代码规模 | 约 100 万行 |
| 手写代码 | 0 行（设计约束） |
| 合并 PR 数 | 约 1,500 个 |
| 日均 PR/人 | 3.5 个 |
| 效率提升 | 约 10 倍 |

**五大方法论**：

1. **给 Agent 一张地图，而不是一本千页手册**
   - AGENTS.md 只有大约 100 行，作用类似于目录
   - 渐进式披露——先把最关键的信息放进来，需要什么再加载什么

2. **架构约束必须靠工具强制执行**
   - 固定分层结构：Types → Config → Repo → Service → Runtime → UI
   - 自定义 Linter 加结构测试，报错消息里直接告诉你怎么改

3. **可观测性也是给 Agent 看的**
   - Chrome DevTools Protocol 接入 Agent 运行时
   - Agent 能自己抓 DOM 快照、截图

4. **熵不会自己消失，必须主动对抗**
   - 后台 Agent 定期扫描文档不一致、架构违规和冗余代码
   - 清理速度跟上生成速度

5. **写在 Slack 里的知识，对 Agent 等于不存在**
   - 所有团队知识都作为版本控制的制品放置在仓库中

> "If it cannot be enforced mechanically, agents will deviate." — OpenAI

### Anthropic 实战案例

**三智能体架构**（借鉴 GAN 思路）：

Planner（规划者）→ Generator（执行者）⇄ Evaluator（评估者）

- Planner：拿到 1-4 句话的产品描述，扩展成完整的产品规格
- Generator：按功能一个一个做"Sprint"，每个 Sprint 有明确的完成标准
- Evaluator：用 Playwright MCP 实际点击运行中的应用，按维度打分

**Context Resets**：当一个 Agent 的上下文接近饱和时，直接清空上下文窗口，但通过结构化的交接文档把关键状态留下来。

**Managed Agents 托管服务**（2026年4月）：

Anthropic 发布《Scaling Managed Agents》，提出托管服务架构——借鉴 OS 虚拟化硬件的模式，将 Agent 的组件虚拟化：

| 组件 | 定义 | 接口 |
|------|------|------|
| Session | 事件日志（append-only） | `getSession(id)` |
| Harness | 调用 Claude + 路由工具调用 | `wake(sessionId)` |
| Sandbox | 执行环境 | `execute(name, input) → string` |

**Brain/Hands/Session 解耦**：
- Brain（Claude + Harness）调用 Hands 如调用普通 tool
- 每个组件都是 cattle（可替换），不是 pet（不可丢失）
- 性能：p50 TTFT 60% 下降，p95 TTFT 90% 下降

**Meta-harness 设计哲学**：
> We're opinionated about the shape of these interfaces, not about what runs behind them.

接口稳定，实现可随模型演进更换——解决 Bitter Lesson 问题：Harness 编码的假设会过时。

**安全边界设计**：tokens 从不 reachable from sandbox。两种模式：
1. Auth bundled with resource（Git clone 时注入）
2. Vault outside sandbox（MCP tools via proxy）

### 三层控制模式（Kief Morris）

| 层级 | 说明 | 你的角色 |
|------|------|----------|
| in the loop | 逐行审查Agent输出 | 监工 |
| on the loop | 不看输出，只管缰绳 | 设计师 |
| out of the loop | 你说要什么，Agent全搞定 | 老板 |

**推荐**: on the loop是最好的平衡点。你不重复劳动，但你还在。

### Hermes带来的变化

Hermes把Harness五组件全部内建，而且让它们自动运转：
- 从「你给AI造缰绳」变成「AI自己给自己造缰绳」
- 你不需要手动写CLAUDE.md，不需要每次犯错后自己总结规则
- Hermes自己观察、自己总结、自己写入Skill

### 自动化的代价

- 你对规则的控制力会降低一些
- 需要定期审查自动生成的内容
- 不是每个人都有Mitchell那样的耐心手动维护

## 关联

- [[Hermes Agent]]
- [[Hermes Agent从入门到精通]]
- [[学习循环]]
- [[三层记忆]]
- [[Skill自改进]]
- [[Mitchell Hashimoto]]
- [[花叔]]
- [[Claude Code]]（手动实现Harness的典型场景）
- [[OpenAI]]
- [[Anthropic]]
- [[上下文工程]]
- [[渐进式披露]]
- [[熵管理]]
- [[Birgitta Böckeler]]
- [[Feedforward vs Feedback]]
- [[Managed Agents]]
- [[Ambient Affordances]]
- [[Ashby's Law]]