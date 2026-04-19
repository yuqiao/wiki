---
title: Git 工作流最佳实践
created: 2026-04-19
updated: 2026-04-19
type: concept
tags: [technique, programming, comparison]
sources: []
---

## 概念

Git 工作流是团队协作开发时管理分支、合并和发布的策略。不同的工作流适用于不同的团队规模、发布频率和项目复杂度。选择合适的工作流能大幅减少合并冲突、提高开发效率。

主流工作流包括：Gitflow、GitHub Flow、GitLab Flow、Trunk-Based Development。

## 价值

正确的工作流能解决以下问题：
- **减少合并冲突** — 功能分支从正确的父分支拉出，避免长期偏离
- **控制发布风险** — 未完成功能不误入生产环境
- **提高协作效率** — 明确的分支规则减少沟通成本
- **支持 CI/CD** — 与自动化流水线无缝集成

Atlassian 指出 Gitflow 已是 **legacy** 工作流，现代团队更推荐 [[Trunk-Based Development]] 或 [[Feature Flags]] 模式。

## 用法

### 场景一：传统 Gitflow（适合周期性发布）

```
main (release)       ← 生产分支，永远稳定
    ↑
hotfix/*             ← 紧急修复，从 main 拉出，合并回 main + develop
    │
release/*            ← 发布准备，从 develop 拉出，合并回 main + develop
    ↑
develop              ← 开发集成分支
    ↑
feature/*            ← 功能分支，必须从 develop 拉出！
```

**关键规则**：
| 分支类型 | 父分支 | 合并目标 | 用途 |
|---------|--------|---------|------|
| `feature/*` | **develop** | develop | 新功能开发 |
| `release/*` | develop | main + develop | 发布准备 |
| `hotfix/*` | main | main + develop | 紧急修复 |

**常见错误**：功能分支从 release 拉出 → 合入 develop 时大量冲突

### 场景二：Feature Flags + Trunk-Based（现代最佳实践）

**核心思想**：代码可以合并，但功能默认关闭

```javascript
// 未完成的功能用开关保护
if (featureFlags.isEnabled('new-payment')) {
  return newPaymentFlow();
} else {
  return legacyPaymentFlow();
}
```

**优势**：
- develop 始终可发布（未完成功能只是"暗"的）
- 减少分支冲突（短生命周期分支）
- 支持渐进式发布、[[A/B测试]]

**工具选择**：
| 工具 | 特点 |
|------|------|
| LaunchDarkly | 企业级，支持细分用户群 |
| Unleash | 开源，自托管 |
| ConfigCat | 多语言 SDK |

### 场景三：GitLab Flow（环境分支推进）

```
feature/*  →  main (开发)  →  staging (测试)  →  production (生产)
                ↑                  ↑                   ↑
            持续集成            手动推进            手动推进
```

**关键规则**：
- 只有一个主开发分支 `main`
- 环境分支是 **只读** 的
- 通过 cherry-pick 或 merge 选择性推进成熟功能

### 场景四：解决"develop 有未完成功能"的问题

**问题**：
```
develop 包含：[功能A ✓] + [功能B ✓] + [功能C ❌] + [功能D ❌]
                                    ↓
                        合并到 release 时带入风险代码
```

**解决方案对比**：

| 方案 | 适用场景 | 复杂度 | 推荐度 |
|------|---------|--------|--------|
| [[Feature Flags]] | 持续发布、功能迭代快 | 中 | ⭐⭐⭐⭐⭐ |
| GitLab Flow 环境分支 | 多环境、有测试流程 | 低 | ⭐⭐⭐⭐ |
| Cherry-pick 工作流 | 发布周期长、功能独立 | 高 | ⭐⭐ |
| Release Branch + 功能审查 | 传统发布流程 | 中 | ⭐⭐⭐ |

## 原理

### 为什么功能分支应该从 develop 拉出？

1. **develop 是最新集成点** — 包含所有已完成功能
2. **减少偏离时间** — 功能分支基于"最新"状态开始
3. **冲突早发现** — 合入 develop 时立即暴露问题
4. **release 分支是短期分支** — 只用于发布准备，不是开发起点

### 为什么 Gitflow 衰落？

Atlassian 明确指出：
- Gitflow 的长期分支导致高偏离风险
- 多主分支难以与 CI/CD 配合
- 现代 DevOps 要求持续集成，而非周期性大合并

### Feature Flags 的本质

[[Feature Flags]] 把"功能完成"和"功能上线"解耦：
- 代码可以提前合并（技术完成）
- 功能可以延迟开启（业务完成）

这是 [[持续交付]] 的核心实践。

## 心法

1. **分支越少越好** — 长期分支是冲突之源
2. **分支越短越好** — 存在时间越长，偏离越严重
3. **功能开关优先** — 未完成功能用开关保护，而非分支隔离
4. **环境推进而非合并** — 通过推进控制发布内容
5. **CI 是检验标准** — 所有分支都应该通过自动化测试

---

## 相关概念

- [[Feature Flags]] — 功能开关，控制未完成功能不上线
- [[Trunk-Based Development]] — 现代主流工作流
- [[持续交付]] — CI/CD 的核心理念
- [[第一性原理]] — 从本质思考工作流设计

---

## 来源

- Atlassian: [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- Atlassian: [Trunk-based Development](https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development)
- Martin Fowler: [Feature Toggles](https://martinfowler.com/articles/feature-toggles.html)
- GitLab: [GitLab Flow Best Practices](https://about.gitlab.com/topics/version-control/what-are-gitlab-flow-best-practices/)