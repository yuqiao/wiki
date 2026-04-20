---
title: Harness Engineering
created: 2026-04-18
updated: 2026-04-20
type: concept
tags: [方法论, AI编程, Agent, 六层架构]
sources: 
  - raw/papers/Hermes-Agent-从入门到精通_摘要.md
  - raw/articles/javaguide-harness-engineering-2026.md
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