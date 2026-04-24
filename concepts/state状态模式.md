---
title: State 状态模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# State 状态模式

## 概念 (Concept)

允许一个对象在其内部状态改变时改变它的行为。对象看起来似乎修改了它的类。

别名：状态对象Objects for States。

## 价值 (Value)

### 解决什么问题

- TCPConnection对象状态处于若干不同状态之一：已建立Established、正在监听Listening、已关闭Closed
- 收到请求时根据自身当前状态作出不同反应
- Open请求结果依赖连接是处于已关闭还是已建立状态

### 带来什么收益

1. **局部化状态相关行为**：所有与特定状态相关行为放入一个对象，通过定义新子类增加新状态和转换
2. **状态转换显式化**：为不同状态引入独立对象使转换更明确，State对象保证Context不会发生内部状态不一致
3. **State对象可被共享**：如果State对象没有实例变量，它们表示状态完全以类型表示，可共享

## 用法 (Usage)

### 适用场景

- 对象行为取决于状态，必须在运行时刻根据状态改变行为
- 操作含庞大多分支条件语句，分支依赖对象状态（用枚举常量表示），多个操作包含相同条件结构

### 参与者

- **Context**：定义客户感兴趣接口，维护ConcreteState子类实例定义当前状态
- **State**：定义接口封装与Context特定状态相关行为
- **ConcreteState**：每一子类实现与Context一个状态相关行为

### 协作方式

Context将与状态相关请求委托给当前ConcreteState对象处理。Context可将自身作为参数传递给状态对象。Context或ConcreteState子类都可决定哪个状态是后继者及状态转换条件。

## 原理 (Principle)

### 引入TCPState抽象类

表示网络连接状态。TCPState为各操作状态子类声明公共接口，子类实现特定状态相关行为。TCPEstablished和TCPClosed分别实现连接已建立和已关闭状态行为。

### TCPConnection委托状态对象

TCPConnection维护表示当前状态的状态对象，将所有与状态相关请求委托给这个状态对象。连接状态改变时，TCPConnection改变它使用的状态对象。

## 心法 (Best Practices)

### 避免巨大条件语句

不用State模式则需巨大if或switch语句，不受欢迎——形成一大整块、不够清晰、难以修改和扩展。State模式将每个状态转换和动作封装到类中，把着眼点从执行状态提高到整个对象状态。

### 状态转换原子性

从Context角度看，状态转换是原子——只需重新绑定一个变量（State对象变量），无需为多个变量赋值。

### 一句话总结

State是**将状态相关行为局部化的类修改模拟器**——状态转换显式化、避免条件语句、增加新状态容易。

## Wikilinks

- [[设计模式]] — 行为型模式之一
- [[Strategy]] — 结构相似：Strategy改变算法，State改变状态行为
- [[Singleton]] — State对象可共享时用Singleton实现
- [[Flyweight]] — State对象可共享时可用Flyweight
- [[设计模式：可复用面向对象软件的基础]]