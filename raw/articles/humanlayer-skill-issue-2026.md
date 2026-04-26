# Skill Issue: Harness Engineering for Coding Agents

> 来源：https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents
> 抓取日期：2026-04-26
> 作者：Kyle (HumanLayer)
> 发布日期：March 12, 2026

## 核心论点

> It's not a model problem. It's a configuration problem.

模型会变得更聪明，我们会给它们更难的问题，它们会继续以意想不到的方式失败。意想不到的失败模式是非确定性系统的根本问题。

## Harness Engineering 定义

```
coding agent = AI model(s) + harness
```

Harness 是 Agent 的 runtime，或 peripherals：模型用什么与环境交互。

Harness Engineering 是利用这些配置点来定制和改进 coding agent 输出质量和可靠性的实践。

> Harness engineering is the idea that anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again. — Mitchell Hashimoto

## Harness Engineering 作为 Context Engineering 的子集

**Context Engineering**：由 Dex Horthy 在 12-factor agents 提出，是 prompt engineering 的超集，包括系统性地改进 AI agent 可靠性的各种技术。

**Harness Engineering**：Context Engineering 的子集，主要涉及利用 harness 配置点来仔细管理 coding agents 的上下文窗口。

回答的问题：
- How do we give our coding agent new capabilities?
- How do we teach it things about our codebase that aren't in the training data?
- How do we add determinism beyond `CRITICAL: always do XYZ` in the system message?
- How do we adapt the agent's behavior for our specific codebase?
- How do we increase task success rates beyond "magic prompts"?
- How do we prevent our context window from inflating too rapidly, or with too much bad context?

## 配置表面

### CLAUDE.md & AGENTS.md

在接触其他配置点之前，通常先定制 CLAUDE.md / AGENTS.md 文件。这些是仓库顶层的 markdown 文件，被 harness 确定性注入到 agent 的 system prompt。

#### ETH Zurich 研究

研究测试了 138 个 agentfiles，发现：
- LLM 生成的 agentfiles 实际上有害，成本增加 20%+
- Human-written 的只帮助约 4%
- Agents 用 14-22% 更多 reasoning tokens 处理 context file instructions，更多步骤，更多工具调用——全部没有改进 resolution rates
- Codebase overviews 和 directory listings 没有帮助——agents 自己发现仓库结构很好

**研究证实 HumanLayer 的建议正确**：
- Agent-generated files 更差：他们说了 "avoid auto-generating it"
- 太多文件过度引导模型使用特定工具：他们说了 "Less (instructions) is more"
- 文件包含不相关上下文：他们说了 "Use Progressive Disclosure"
- Human-written 的几乎没帮助因为太多条件规则：他们说了 "Keep contents concise and universally applicable"

HumanLayer 的 CLAUDE.md under 60 lines。

### MCP Servers Are for Tools

MCP servers 主要用于把工具插入 coding agent 以扩展其能力。

**WARNING**：MCP servers' tool descriptions 添加到 system prompt，不要连接不信任的 server——prompt injection 向量。

#### Too Many Tools Is Bad

插太多 MCP tools，上下文窗口被工具描述填满，更快进入 dumb zone。

Instruction budget 也重要——每个不相关的工具描述是 agent 没有任何好处地处理的指令。

Anthropic 发布 MCP tool search 支持——progressive disclose tools。如果不主动使用提供大量工具的 server，关掉它。

#### CLI vs MCP

如果 MCP server 复制已在训练数据中很好表示的 CLI 功能，最好直接 prompt agent 用 CLI。GitHub、Docker、大多数数据库——agent 已经知道怎么用 CLI，还能与 grep/jq 组合获得额外 context-efficiency。

HumanLayer 案例：用 Linear MCP server 一段时间后，意识到只用小部分工具——写了小型 CLI 包装 Linear API，提供非常 context-efficient 的响应，在 CLAUDE.md 里包含 6 个示例用法。节省了数千 tokens。

### Skills Are for Reusable Knowledge

Skills 通过 Anthropic 为 Claude Code 引入，现在是开放标准，被 Codex 和 OpenCode 支持。

**Security Warning**：skill registries 已经被发现分发数百恶意 skills。像 npm install random-package 一样——读你要安装的。

#### Progressive Disclosure

把所有指令和工具塞进 system prompt，agent 变差。在 agent 开始工作前就用掉 instruction budget。

Skills 通过 progressive disclosure 解决——agent 只有在它决定（或你决定）需要时才获得特定指令/知识/工具。

#### Skill Activation

Skill 激活时，skill 目录的 SKILL.md 文件作为 user message 加载到 agent 的 context window，agent被告知 skill 文件加载的目录。

```
example-skill/
|--- SKILL.md
|--- response_template.md
|--- CLIs/
   |--- linear-cli
   |--- tunnel-cli
```

### Sub-Agents Are for Context Control

Sub-agents 是流行的但常被误解的配置点。

**误解**：frontend engineer sub-agent、backend engineer sub-agent、data analyst sub-agent——不工作。

**正确用法**：Sub-agents for context control。

提供方法封装整个 coding agent session 的工作，dispatching agent 只看到：
- 它为 sub-agent 写的 prompt
- sub-agent 的最终结果

没有中间工具调用、工具结果或其他消息进入 parent coding agent 的 context window。

#### Sub-Agents Avoid Context Rot

Chroma 的 context rot 研究：模型在更长的上下文长度表现更差。

Chroma 研究者测试了 18 个模型在 needle-in-a-haystack 任务——发现与经验完全吻合：性能随上下文长度增加而下降。

更糟的是，当问题和上下文中相关信息之间语义相似度低时，下降更陡。每个中间工具调用、每个 grep 结果、每个在 parent session 中不相关的文件读取是潜在 distractor——distractor 效果在更长上下文窗口复合。

#### Long-Context Models

为什么怀疑 "just make the context window bigger"：

扩展上下文版本通常不是更大的模型——是同一模型用 clever math（如 YaRN）扩展序列长度。

Needle-in-a-haystack：更大上下文窗口不使模型更好找 needle——只是使 haystack 更大。

如果你觉得需要更长上下文，可能只需要更好的 context window isolation。Sub-agents 结构性地解决：每个获得 fresh、small、high-relevance context window with fresh "instruction budget"。

#### Sub-Agent Use Cases

适合用 sub-agents 的：
- 在 codebase 中定位特定定义或实现
- 分析 codebase 以识别特定类型工作的模式
- 追踪信息流通过 codebase，如跨服务边界追踪请求
- 其他一般 code/documentation/web 研究任务

Sub-agents 应返回高度浓缩的响应，遵循 progressive disclosure 原则。例如，sub-agents 提供答案但也用 filepath:line 格式或 URL 引用来源。

#### Sub-Agents for Cost Control

昂贵模型（Opus）用于 parent session（planning、orchestration），便宜快速模型（Sonnet、Haiku）用于 sub-agents。Sub-agents 接收更小更离散的任务——不需要 Opus tokens 做 codebase grep。

### Hooks Are for Control Flow

Hooks：用户定义的命令或脚本，在某些事件发生时和 agent lifecycle 各点自动执行。

概念上类似 git hooks，但更灵活。可用于添加新功能、集成外部服务、自动化常规操作、修改权限、配置默认行为。

Hook 可以：
- 当事件发生时自动但静默运行
- 当 tool 被调用时运行，返回额外上下文
- 在 agent 完成前 surface build/type errors，迫使它继续工作直到解决

**Common use cases**：
- Notifications：agent 完成时播放声音，approval pending 太久
- Approvals：基于输入值自动批准或拒绝 tool calls，比默认权限模型更表达性的规则
- Integrations：agent 完成时发送 Slack 消息，创建 GitHub PR，设置 preview environment
- Verification：typecheck 或 build 在几秒内完成——每次 agent stop 都运行以 surface errors

#### Example Hook

```bash
#!/bin/bash
cd "$CLAUDE_PROJECT_DIR"

# prebuild generates types and builds internal SDK packages
PREBUILD_OUTPUT=$(bun run generate-cache-key && turbo run build --filter=@humanlayer/hld-sdk && bun install 2>&1)
if [ $? -ne 0 ]; then
  echo "prebuild failed:" >&2
  echo "$PREBUILD_OUTPUT" >&2
  exit 2
fi

# biome and typecheck run in parallel
OUTPUT=$(bun run --parallel \
  "biome check . --write --unsafe || biome check . --write --unsafe" \
  "turbo run typecheck" 2>&1)

if [ $? -ne 0 ]; then
  echo "$OUTPUT" >&2
  exit 2
fi
```

成功时 hook 完全静默——没有东西进入 agent 上下文。失败时只有 errors 被 surface，exit code 2 告诉 harness re-engage agent 使它在完成前修复。

### Back-Pressure Increases Your Chances of Success

核心洞察：用 coding agent 成功解决问题的概率与 agent 验证自己工作的能力强相关。

**Verification mechanisms**：
- typechecks 和 build steps（强类型语言）
- unit tests 和/或 integration tests
- code coverage reporting（Stop hook prompt agent 增加 coverage 如果下降）
- UI interaction 和 testing integrations（playwright、agent-browser）

**Critical**：这些 verification mechanisms 需要 context-efficient。早期运行完整测试套件——4,000 行 passing tests 洪水般填满上下文窗口。agent 失去任务焦点，开始幻觉刚读过的测试文件。

现在：吞掉输出，只 surface errors。builds 同样——成功静默，只有失败产生详细输出。

## Post-Training Coupling

前沿 coding models 在它们的 harnesses 上 post-trained（Claude in Claude Code，GPT-5 Codex in Codex）。有人会争论最好的 harness 是模型训练时用的那个。

例如，Codex models 与 Codex harness 的 apply_patch tool 紧密耦合——OpenCode 不得不添加 apply_patch tool 专门为 GPT/Codex models 模拟 Codex harness。

但两面都有：models 可以 over-fitted to their harness。Viv 引用 Terminal Bench 2.0：Opus 4.6 in Claude Code 排位 #33，但在不同 harness 排位 #5。

## What Worked vs What Didn't

**What didn't work**：
- Trying to design the ideal harness configuration upfront before hitting real failures
- Installing dozens of skills and MCP servers "just in case"
- Running entire test suite (5+ min) at end of every agent session
- Micro-optimizing which sub-agents could access which tools——tool thrash，更差结果

**What worked**：
- Starting simple and adding configuration only when agent actually failed
- Designing, testing, iterating——throwing away things that didn't help
- Distributing battle-tested configurations to whole team via repository-level config
- Optimizing for iteration speed, not "likelihood of 1-shotting it on first attempt"
- Giving agent capabilities (Linear) then carefully paring down what exposed once knew what needed

## Closing

> The next time your coding agent isn't performing the way you expect, before you blame the model, check the harness. Agentfiles, MCP servers, skills, sub-agents, hooks, and back-pressure — that's where we've found most of the leverage. The model is probably fine. It's just a skill issue.