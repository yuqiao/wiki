---
title: Trunk-Based Development
created: 2026-04-19
updated: 2026-04-19
type: concept
tags: [technique, programming, devops]
sources:
  - https://trunkbaseddevelopment.com/
  - https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development
---

## 概念

Trunk-Based Development（主干开发）是一种版本控制管理实践：开发者将小规模、高频的更新直接合并到单一"主干"分支（通常叫 `main` 或 `trunk`），而不是长期维护多个功能分支。

> Branches create distance between developers and we do not want that.
> — Frank Compagner, Guerrilla Games

核心原则：**永远不破坏构建，永远保持可发布状态**。

## 价值

### 解决什么问题

传统多分支工作流的问题：

| 问题 | 描述 |
|------|------|
| **集成延迟** | 分支存在时间越长，与主干的偏离越严重 |
| **合并地狱** | 长期分支合并时冲突爆炸 |
| **重复工作** | 不同分支的开发者可能在做相同的事 |
| **不兼容发现晚** | 代码间的兼容问题合并时才暴露 |

### Trunk-Based 的收益

- **最小化距离** — 开发者与代码集成点的距离降到最低
- **快速反馈** — 每天多次同步，问题几小时内发现
- **持续可发布** — 主干随时可以发布，无"发布窗口"
- **降低风险** — 小批量变更，出问题容易回滚

## 用法

### 基本工作流

```
trunk (main)  ────────────────────────────────────────▶
                  ↑       ↑       ↑       ↑
              commit   commit  commit  commit
              (1-2h)   (1-2h)  (1-2h)  (1-2h)

            开发者从主干拉取 → 本地修改 → 快速代码审查 → 合并回主干
```

### 两种发布模式

| 模式 | 适用场景 | 做法 |
|------|---------|------|
| **直接从主干发布** | 高发布频率（每天多次） | 主干 = 可发布 |
| **发布分支** | 低发布频率（周/月） | 从主干创建 release 分支，仅做 bugfix |

### 与 Feature Flags 配合

未完成功能用开关保护，保证主干始终可发布：

```javascript
// 代码可以提前合并，功能按需开启
if (featureFlags.isEnabled('new-checkout')) {
  return newCheckoutFlow();
} else {
  return legacyCheckoutFlow();
}
```

这是 Trunk-Based Development 的关键配套实践 — **[[Feature Flags]] 把"技术完成"和"业务上线"解耦**。

### 短生命周期分支（可选）

现代团队可以用 Pull Request 进行代码审查：

```
trunk  ────────────────────────────────────────▶
           ↑
           │ merge (squash or regular)
           │
feature/*  ────●────●────●────  (存活 < 1天)
                代码审查在此进行
```

关键：**分支必须在 1 天内合并**，否则违背 Trunk-Based 原则。

## 原理

### 为什么有效

1. **CI 是安全网** — 持续集成服务器监控主干，构建失败立即警报
2. **小批量 = 低风险** — 每次提交变更量小，出问题容易定位和回滚
3. **频繁同步 = 低偏离** — 每天多次 pull，始终与团队保持同步
4. **社交压力** — 破坏构建会在团队中"公开处刑"，倒逼质量意识

### 关键前提条件

| 条件 | 要求 | 原因 |
|------|------|------|
| **构建时间** | < 10 分钟 | 长构建会降低提交频率 |
| **测试覆盖** | 高覆盖 + 快速 | 每次提交前必须验证 |
| **故事粒度** | 几小时完成 | 大故事迫使创建长期分支 |
| **VCS 性能** | pull < 3 秒 | 慢速 VCS 阻碍高频同步 |

### 与 Gitflow 的对比

| 维度 | Gitflow | Trunk-Based |
|------|---------|-------------|
| 分支数量 | 多（main/develop/feature/release/hotfix） | 少（main + 短期分支） |
| 分支生命周期 | 长（周/月） | 短（小时/天） |
| 发布频率 | 周期性 | 持续 |
| CI/CD 配合 | 困难 | 天然契合 |
| 适用场景 | 传统发布流程 | 现代 DevOps |
| Atlassian 评价 | **Legacy** | **推荐** |

### "距离"的本质

Frank Compagner 提出的"距离"概念：

- **物理距离** — 已被远程协作工具解决
- **集成距离** — 代码未合并到共享分支带来的问题：
  - 合并后可能破坏意外的东西
  - 合并本身困难
  - 重复工作直到合并才发现
  - 不兼容/不期望的问题合并后才暴露

Trunk-Based Development 的目标：**将此距离降到最小**。

## 心法

1. **主干永远可发布** — 如果 CIO 说"现在上线"，最坏情况是 1 小时内可以发布
2. **提交粒度要小** — 一天多次提交，每次变更可独立验证
3. **构建绝不能断** — 破坏构建是团队紧急事件，立即修复
4. **分支越短越好** — 如需 PR 审查，分支存活不超过 1 天
5. **Feature Flags 是朋友** — 未完成功能用开关保护，不因"没做完"就不合并
6. **代码审查不等于长期分支** — 可以用 PR，但必须快速通过并删除分支

---

## 与其他工作流的关系

- [[Git 工作流最佳实践]] — 工作流选择指南
- [[Feature Flags]] — Trunk-Based 的关键配套
- [[持续交付]] — Trunk-Based 是持续交付的前提
- [[Gitflow]] — 传统多分支工作流（已是 legacy）

---

## 来源

- trunkbaseddevelopment.com — Paul Hammant 维护的权威资源站
- Atlassian: Trunk-based Development
- 《Continuous Delivery》— Jez Humble & David Farley