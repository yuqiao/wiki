---
title: Feature Flags
created: 2026-04-19
updated: 2026-04-19
type: concept
tags: [technique, programming, devops]
sources:
  - https://martinfowler.com/articles/feature-toggles.html
  - https://trunkbaseddevelopment.com/feature-flags/
---

## 概念

Feature Flags（功能开关/Feature Toggles）是一种技术实践：**用配置开关控制功能的可见性，而非用分支隔离功能**。

核心思想：**代码可以提前合并（技术完成），功能可以延迟开启（业务完成）**。

```javascript
// 典型用法：未完成功能用开关保护
if (featureFlags.isEnabled('new-payment-flow')) {
  return newPaymentFlow();  // 新功能
} else {
  return legacyPaymentFlow();  // 旧功能（稳定）
}
```

## 价值

### 解决什么问题

传统开发流程的困境：

```
develop 分支包含：[功能A ✓] + [功能B ✓] + [功能C ❌] + [功能D ❌]
                                    ↓
                      发布时带入未完成的代码 → 生产风险
```

Feature Flags 的解决方案：

```
develop 分支包含：[功能A 开] + [功能B 开] + [功能C 关] + [功能D 关]
                                    ↓
                      只发布"开启"的功能 → 生产安全
```

### 核心收益

| 收益 | 说明 |
|------|------|
| **解耦技术完成与业务上线** | 开发者可以提前合并，产品经理可以按需上线 |
| **支持渐进式发布** | 先给 1% 用户，逐步扩大到 100% |
| **降低发布风险** | 功能出问题一键关闭，无需回滚代码 |
| **支持 A/B 测试** | 不同用户看到不同版本，数据驱动决策 |
| **消除"发布窗口"焦虑** | 主干永远可发布，不再等"所有功能做完" |

## 用法

### 基本模式

```javascript
// 1. 简单开关
if (flags.isEnabled('dark-mode')) {
  enableDarkMode();
}

// 2. 用户分组（A/B测试）
if (flags.isEnabled('new-ui', user)) {
  renderNewUI(user);
} else {
  renderLegacyUI(user);
}

// 3. 百分比灰度
if (flags.isEnabledForPercent('new-search', 10)) {
  // 10% 用户看到新搜索
}
```

### 分类（Martin Fowler）

| 类型 | 生命周期 | 用途 |
|------|---------|------|
| **Release Toggles** | 短（几周） | 控制未完成功能不上线 |
| **Experiment Toggles** | 短（几周） | A/B 测试，数据驱动 |
| **Ops Toggles** | 短（几小时） | 运维开关，快速回滚 |
| **Permission Toggles** | 长（永久） | 权限控制，付费用户功能 |

### 工具选择

| 工具 | 特点 | 适用场景 |
|------|------|---------|
| **LaunchDarkly** | 企业级，细分用户群、实时更新 | 大型团队 |
| **Unleash** | 开源，自托管 | 需要控制基础设施 |
| **ConfigCat** | 多语言 SDK，简单易用 | 中小团队 |
| **环境变量** | 最简单，无额外工具 | 小型项目 |

## 原理

### 为什么有效

1. **发布变成配置问题** — 不再需要"所有功能做完才能发布"
2. **回滚成本降到零** — 关闭开关 vs 回滚代码，前者几秒，后者几十分钟
3. **降低分支需求** — 不需要用分支隔离功能，减少合并冲突
4. **数据驱动上线** — A/B 测试结果决定是否正式上线

### 与 Trunk-Based Development 的协同

Feature Flags 是 Trunk-Based Development 的关键配套：

```
┌─────────────────────────────────────────────────────┐
│  Trunk-Based: 主干永远可发布                         │
│  Feature Flags: 未完成功能只是"暗"的                  │
│                                                     │
│  结果: 每天都可以发布，不再有"发布窗口"              │
└─────────────────────────────────────────────────────┘
```

这是 [[持续交付]] 的核心实践。

### 技术实现要点

```javascript
// 关键：开关逻辑不能影响性能
// 1. 开关判断要快（内存缓存）
// 2. 开关配置要实时（不依赖重启）
// 3. 开关状态要可追溯（审计日志）

class FeatureFlags {
  constructor() {
    this.cache = new Map();  // 内存缓存
    this.configSource = 'remote';  // 远程配置
  }
  
  isEnabled(flagName, context = {}) {
    const flag = this.cache.get(flagName);
    if (!flag) return false;
    
    // 根据规则判断
    return this.evaluate(flag, context);
  }
}
```

## 心法

1. **开关不是万能药** — 只用于控制可见性，不用于复杂业务逻辑
2. **开关要短命** — Release Toggles 用完即删，不要积累开关
3. **开关要有命名规范** — `feature-new-payment` 而非 `flag1`
4. **开关要有审计** — 谁在什么时候开了什么，要有记录
5. **开关要有清理机制** — 定期清理不再使用的开关，避免代码膨胀

### 反模式

| 反模式 | 问题 |
|--------|------|
| **开关嵌套** | `if (flagA && flagB && !flagC)` → 难测试、难维护 |
| **开关永久化** | 开关越来越多，代码变成迷宫 |
| **开关控制逻辑而非可见性** | 用开关实现业务规则，而非控制功能上线 |
| **开关硬编码** | 改开关要改代码、重新部署 |

---

## 关联概念

- [[Trunk-Based Development]] — Feature Flags 的主要应用场景
- [[Git 工作流最佳实践]] — Feature Flags + Trunk-Based 是现代最佳实践
- [[持续交付]] — Feature Flags 是持续交付的核心技术
- [[A/B测试]] — Feature Flags 支持 A/B 测试

---

## 来源

- Martin Fowler: [Feature Toggles](https://martinfowler.com/articles/feature-toggles.html)
- trunkbaseddevelopment.com: [Feature Flags](https://trunkbaseddevelopment.com/feature-flags/)
- 《Continuous Delivery》— Jez Humble & David Farley