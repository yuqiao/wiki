---
title: Adapter 适配器模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Adapter 适配器模式

## 概念 (Concept)

将一个类的接口转换成客户希望的另外一个接口。Adapter模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。

别名：包装器Wrapper。

## 价值 (Value)

### 解决什么问题

- 复用设计的工具箱类接口与专业应用领域所需接口不匹配
- TextView类属于工具箱，没有考虑Shape接口存在
- 已存在且不相关的类如何协同工作

### 带来什么收益

1. **复用不兼容类**：让两个不兼容的接口能协同工作
2. **提高复用性**：创建可复用类，与其他不相关或不可预见类协同
3. **适配子类**：对象适配器可适配父类接口，无需对每个子类子类化

## 用法 (Usage)

### 适用场景

- 想使用已存在类，其接口不符合需求
- 想创建可复用类，与其他不相关或不可预见类协同工作
- 想使用已存在子类，但不可能对每个都子类化匹配接口（仅对象适配器）

### 类适配器vs对象适配器

**类适配器**：用多重继承对一个接口与另一个接口匹配
- 优点：可重定义Adaptee部分行为，不需额外指针
- 缺点：不能匹配类及其所有子类

**对象适配器**：依赖对象组合
- 优点：可与多个Adaptee及其子类工作，可一次添加功能
- 缺点：重定义Adaptee行为困难，需生成Adaptee子类

### 参与者

- **Target**：定义Client使用的与特定领域相关接口
- **Client**：与符合Target接口的对象协同
- **Adaptee**：定义已存在接口，需要适配
- **Adapter**：对Adaptee接口与Target接口进行适配

## 原理 (Principle)

### 接口转换

Adapter将一个类的接口转换成客户希望的另一个接口。客户在Adapter实例上调用操作，Adapter调用Adaptee操作实现请求。

### 双向适配器

提供透明操作，在两个不同客户需要用不同方式查看同一对象时尤其有用。ConstraintStateVariable是ConstraintVariable与StateVariable共同子类，使两个系统都可工作。

## 心法 (Best Practices)

### 可插入适配器

接口匹配使得可将类加入现有系统，这些系统对类接口可能不同。TreeDisplay窗口组件必须能显示不同树结构，有不同接口（GetSubdirectories vs GetSubclasses）。

### 匹配程度

Adapter工作量取决于Target接口与Adaptee接口相似程度。工作范围从简单接口转换（改变操作名）到支持完全不同操作集合。

### 一句话总结

Adapter是**让不兼容接口协同工作的接口转换器**——类适配器用继承，对象适配器用组合。

## Wikilinks

- [[设计模式]] — 结构型模式之一
- [[Decorator]] — 都是包装器，但目的不同：Decorator添加职责，Adapter转换接口
- [[Bridge]] — 结构相似但目的不同：Bridge分离抽象与实现，Adapter让不兼容接口协同
- [[Proxy]] — 都是代理，但Proxy控制访问，Adapter转换接口
- [[设计模式：可复用面向对象软件的基础]]