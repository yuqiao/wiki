---
title: Strategy 策略模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Strategy 策略模式

## 概念 (Concept)

定义一系列算法，把它们一个个封装起来，并且使它们可相互替换。策略模式使算法可独立于使用它的客户而变化。

别名：政策(Policy)。

## 价值 (Value)

### 解决什么问题

- 算法硬编进使用类中会导致类复杂、难以维护
- 不同时候需要不同算法，不想支持不使用的算法
- 增加新算法或改变现有算法困难

### 带来什么收益

1. **算法系列**：Strategy类层次定义可重用算法/行为，继承析取公共功能
2. **替代继承**：避免行为硬编进Context，将算法实现与Context分离
3. **消除条件语句**：避免用条件语句选择行为，封装在独立Strategy类
4. **实现选择**：提供相同行为不同实现，客户可按时间/空间权衡选择

## 用法 (Usage)

### 适用场景

- 相关类仅行为有异，策略提供用多个行为之一配置类的方法
- 需使用算法不同变体，反映不同空间/时间权衡
- 算法使用客户不应知道的数据，避免暴露复杂数据结构
- 类定义多种行为，以多个条件语句形式出现，将条件分支移入各自Strategy类

### 参与者

- **Strategy**：定义所有支持算法的公共接口
- **ConcreteStrategy**：以Strategy接口实现具体算法
- **Context**：用ConcreteStrategy对象配置，维护对Strategy引用，可定义接口让Strategy访问数据

### 协作方式

- Strategy和Context相互作用实现选定算法
- Context可将算法所需数据传递给Strategy，或将自身作为参数传递
- Context将客户请求转发给Strategy

## 原理 (Principle)

### 委托替代继承

继承支持多种算法的方法：生成Context子类给它不同行为。但这会：
- 行为硬编进Context
- 算法实现与Context混合
- 难理解、难维护、难扩展
- 不能动态改变算法

策略封装在独立Strategy类中，可独立于Context改变。

### 消除条件语句

不用Strategy时：
```cpp
switch (algorithm) {
    case SIMPLE: // simple algorithm
    case TEX: // TeX algorithm
    case ARRAY: // array algorithm
}
```

用Strategy后委托给Strategy对象，消除case语句。

## 心法 (Best Practices)

### 潜在缺点

1. **客户须知Strategy差异**：选择合适Strategy必须知道有何不同，可能暴露实现问题
2. **通信开销**：Strategy接口传递数据，可能有些ConcreteStrategy不使用，Context创建初始化未用参数
3. **增加对象数目**：Strategy增加应用对象数目，可实现为无状态共享对象减少开销

### 实现技巧

- **接口定义**：Context将数据传给Strategy（解耦），或将自身传给Strategy（紧密耦合）
- **模板参数**：C++可用模板用Strategy配置类
- **共享无状态Strategy**：Flyweight模式减少对象数目

### 与Decorator对比

Decorator改变对象外壳，Strategy改变对象内核。Component类庞大时，Strategy比Decorator代价更低。

### 一句话总结

Strategy是**用委托替代继承的算法封装**——消除条件语句、独立变化、运行时切换。

## Wikilinks

- [[设计模式]] — 行为型模式之一
- [[MVC架构]] — View-Controller关系是Strategy
- [[Decorator]] — 改变外壳vs改变内核
- [[State]] — 结构相似但意图不同
- [[设计模式：可复用面向对象软件的基础]]