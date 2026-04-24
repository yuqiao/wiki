---
title: Flyweight 享元模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Flyweight 享元模式

## 概念 (Concept)

运用共享技术有效地支持大量细粒度的对象。

## 价值 (Value)

### 解决什么问题

- 文档编辑器用对象表示每个字符会极大提高灵活性，但代价太大
- 中等大小文档可能要求成百上千字符对象，耗费大量内存
- 字符和嵌入成分可在绘制和格式化时统一处理

### 带来什么收益

1. **减少存储开销**：不同字符对象数远小于文档字符数，对象总数远小于初次执行程序数目
2. **细粒度对象可行**：对单个字符对象抽象具有实际意义
3. **共享池**：特定字符对象每次出现指向同一实例，实例位于共享池

## 用法 (Usage)

### 适用场景（所有条件都成立）

- 应用程序使用大量对象
- 完全由于使用大量对象造成很大存储开销
- 对象大多数状态可变为外部状态
- 删除对象外部状态可用相对较少共享对象取代很多组对象
- 应用程序不依赖于对象标识

### 参与者

- **Flyweight**：描述接口，通过接口flyweight可接受并作用于外部状态
- **ConcreteFlyweight**：实现Flyweight接口，为内部状态增加存储空间，必须可共享
- **UnsharedConcreteFlyweight**：并非所有Flyweight子类需被共享，通常将ConcreteFlyweight作为子节点

### 内部vs外部状态

- **内部状态**：存储于flyweight中，独立于flyweight场景，可共享（如字符代码）
- **外部状态**：取决于flyweight场景，根据场景变化，不可共享（如位置和字体）

## 原理 (Principle)

### flyweight是共享对象

可同时在多个场景使用，在每个场景中可作为独立对象——与非共享对象实例无区别。flyweight不能对它运行场景做出假设。

### Glyph例子

Glyph是图形对象抽象类。Draw和Intersects执行前必须知道glyph所在场景。Row glyph知道子女应在哪儿绘制才能保证横向排列，可在绘制请求中向每个子女传递位置。

## 心法 (Best Practices)

### 字符代码是内部状态

表示字母"a"的flyweight只存储字符代码，不需存储位置或字体。用户提供与场景相关信息，flyweight绘出自己。

### 对象标识问题

Flyweight对象可被共享，概念上明显有别的对象标识测试返回真值——应用不依赖对象标识。

### 一句话总结

Flyweight是**用共享减少细粒度对象存储开销的内部外部状态分离器**——共享池、减少存储、支持大量对象。

## Wikilinks

- [[设计模式]] — 结构型模式之一
- [[Composite]] — Flyweight常用于共享Composite叶子节点
- [[Factory Method]] — Flyweight工厂创建并管理共享对象
- [[State]] — State对象可共享时可用Flyweight实现
- [[设计模式：可复用面向对象软件的基础]]