# Harness Engineering 深度解析

> 来源：https://javaguide.cn/ai/agent/harness-engineering.html
> 抓取日期：2026-04-20
> 这是 JavaGuide 对 OpenAI《Harness Engineering: Leveraging Codex in an Agent-First World》及相关实践的详细解析

## 核心概念

### Harness 到底是什么？

一句话：**Agent = Model + Harness**。你不是模型，那你就是 Harness。

Harness 就是模型之外的一切——系统提示词、工具调用、文件系统、沙箱环境、编排逻辑、钩子中间件、反馈回路、约束机制。模型本身只是能力的来源，只有通过 Harness 把状态、工具、反馈和约束串起来，它才真正变成一个 Agent。

### 三层关系

| 层级 | 解决的核心问题 | 关注点 | 典型工作 |
|------|--------------|--------|----------|
| Prompt Engineering | 表达——怎么写好指令 | 塑造局部概率空间，让模型听懂意图 | 系统提示词设计、Few-shot 示例、思维链引导 |
| Context Engineering | 信息——给 Agent 看什么 | 确保模型在合适的时机拿到正确且必要的事实信息 | 上下文管理、RAG、记忆注入、Token 优化 |
| Harness Engineering | 执行——整个系统怎么防崩、怎么量化、怎么持续运转 | 长链路任务中的持续正确、偏差纠正、故障恢复 | 文件系统、沙箱、约束执行、熵管理、反馈回路 |

## 六层架构

| 层级 | 名称 | 解决什么问题 | 关键设计 |
|------|------|-------------|----------|
| L1 | 信息边界层 | Agent 该知道什么、不该知道什么 | 定义角色与目标，裁剪无关信息，结构化组织任务状态 |
| L2 | 工具系统层 | Agent 怎么跟外部世界交互 | 工具的选拔、调用时机、结果的提炼与反馈 |
| L3 | 执行编排层 | 多步骤任务怎么串起来 | 让模型像人一样走完"理解目标→判断信息→分析→生成→检查"的完整轨道 |
| L4 | 记忆与状态层 | 长任务中间结果怎么管 | 独立管理当前任务状态、中间产物和长期记忆，防止系统混乱 |
| L5 | 评估与观测层 | Agent 怎么知道自己做对了没有 | 建立独立于生成过程的验证机制，让 Agent 具备"自知之明" |
| L6 | 约束、校验与恢复层 | 出错了怎么办 | 预设规则拦截错误，失败时提供重试或回滚机制 |

## 关键发现

### 上下文 40% 阈值

Dex Horthy 观察到：168K token 的上下文窗口，用到大约 40% 的时候，Agent 的输出质量就开始明显下降。

| 区间 | 占比 | 表现 |
|------|------|------|
| Smart Zone | 0 - ~40% | 推理聚焦、工具调用准确、代码质量高 |
| Dumb Zone | 超过 ~40% | 幻觉增多、兜圈子、格式混乱、低质量代码 |

### 瓶颈不在模型

Can.ac 实验：同一个模型，只换了文件编辑接口的调用方式，编码基准分数从 6.7% 直接跳到 68.3%。模型没变，变的是外围的那套系统。

## OpenAI 案例

### 数据

| 指标 | 数值 |
|------|------|
| 团队规模 | 3 名工程师（后扩至 7 人） |
| 持续时间 | 5 个月（2025 年 8 月起） |
| 代码规模 | 约 100 万行 |
| 手写代码 | 0 行（设计约束） |
| 合并 PR 数 | 约 1,500 个 |
| 日均 PR/人 | 3.5 个 |
| 效率提升 | 约 10 倍 |

### 五大方法论

1. **给 Agent 一张地图，而不是一本千页手册**
   - AGENTS.md 只有大约 100 行，作用类似于目录，指向 docs/ 目录下更深层的设计文档
   - 渐进式披露——先把最关键的信息放进来，需要什么再加载什么

2. **架构约束必须靠工具强制执行**
   - 每个业务领域定义固定分层结构：Types → Config → Repo → Service → Runtime → UI
   - 自定义 Linter 加结构测试，违反就报错，报错消息里直接告诉你怎么改

3. **可观测性也是给 Agent 看的**
   - Chrome DevTools Protocol 接入 Agent 运行时
   - Agent 能自己抓 DOM 快照、截图

4. **熵不会自己消失，必须主动对抗**
   - 后台 Agent 定期扫描，找文档不一致、架构违规和冗余代码
   - 清理的速度跟上了生成的速度

5. **写在 Slack 里的知识，对 Agent 来说等于不存在**
   - 所有团队知识都作为版本控制的制品放置在仓库中

## Anthropic 案例

### 三智能体架构

Planner（规划者）→ Generator（执行者）⇄ Evaluator（评估者）

- Planner：拿到 1-4 句话的产品描述，扩展成完整的产品规格
- Generator：按功能一个一个做"Sprint"，每个 Sprint 有明确的完成标准
- Evaluator：用 Playwright MCP 实际点击运行中的应用，按维度打分

### Context Resets

当一个 Agent 的上下文接近饱和时：
1. 先把当前任务状态、已完成的工作、待办事项结构化地提取出来
2. 启动一个全新的"干净" Agent，把结构化的交接文档交给它
3. 新 Agent 从干净的状态继续工作

## Stripe 案例

### Minions 系统

每周超过 1300 个完全由 Minions 生产的、不含任何人写代码的 PR 被合并。

| 组件 | 作用 | 关键设计 |
|------|------|----------|
| Devbox | 开发环境 | AWS EC2 预装源码和服务，启动约 10 秒 |
| 编排状态机 | 流程控制 | 混合确定性节点和 Agent 节点 |
| Toolshed MCP | 工具服务 | 集中式 MCP 服务，近 500 个工具 |
| 反馈回路 | 质量保障 | Pre-push hook 秒级修 lint；推送后最多 2 轮 CI |

## Mitchell Hashimoto 案例

六步进阶路线：

| 步骤 | 名称 | 核心做法 |
|------|------|----------|
| 1 | 放弃聊天模式 | 让 Agent 在能读文件、跑程序、发 HTTP 请求的环境里直接干活 |
| 2 | 复现自己的工作 | 件事做两次——一次自己做，一次让 Agent 做 |
| 3 | 下班前启动 Agent | 每天最后 30 分钟给 Agent 布置任务 |
| 4 | 外包确定性任务 | 挑出 Agent 几乎一定能做好的任务后台跑着 |
| 5 | 工程化 Harness | 每当 Agent 犯错，就工程化一个解决方案让它永远不再犯同样的错 |
| 6 | 始终有 Agent 在跑 | 目标是 10-20% 的工作时间有后台 Agent 运行 |

## 行动清单

### P0：不用犹豫，立即可以做

- 创建 AGENTS.md 并持续维护
- 构建自定义 Linter + 修复指令
- 把团队知识放进仓库

### P1：P0 做完之后，可以考虑这些

- 分层管理上下文
- 建立进度文件和功能列表
- 给 Agent 端到端验证能力
- 控制上下文利用率（不超过 40%）

### P2：有余力再考虑

- Agent 专业化分工
- 定期垃圾回收
- 可观测性集成

## 推荐阅读

- OpenAI - Harness Engineering: Leveraging Codex in an Agent-First World
- Anthropic - Harness Design for Long-Running Application Development
- Mitchell Hashimoto - My AI Adoption Journey
- Birgitta Böckeler - Harness Engineering (Martin Fowler 网站)
- Stripe - Minions: Stripe's One-Shot, End-to-End Coding Agents
- LangChain - The Anatomy of an Agent Harness
- Can Bölük (Can.ac) - The Harness Problem