---
title: Mediator 中介者模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Mediator 中介者模式

## 概念 (Concept)

用一个中介对象来封装一系列的对象交互。中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互。

## 价值 (Value)

### 解决什么问题

- 对象间交互复杂，形成网状依赖关系
- 多个对象相互引用，紧密耦合难以独立改变
- GUI对话框中多个组件相互协作，但直接引用导致复杂依赖

### 带来什么收益

1. **减少子类生成**：Mediator将原本分布于多个对象的行为集中在一起，改变这些行为只需生成Mediator子类
2. **解耦同事对象**：同事对象松散耦合，可独立改变和复用
3. **简化对象协议**：用Mediator替换多对多交互为一对多交互，更易理解维护
4. **集中控制**：交互复杂性集中在Mediator，同事对象更简单

## 用法 (Usage)

### 适用场景

- 一组对象以定义良好但复杂方式通信，产生的相互依赖关系难以理解
- 一个对象引用其他很多对象并直接通信，导致难以复用该对象
- 想定制分布在多个类中的行为，不想生成太多子类

### 参与者

- **Mediator**：定义与各Colleague对象通信接口
- **ConcreteMediator**：协调各Colleague对象实现协作行为，了解并维护各Colleague
- **Colleague**：知道Mediator对象，与Mediator通信而非与其他Colleague直接通信

### 协作方式

Colleague向Mediator发送接收请求，Mediator在各Colleague间分发请求。

## 原理 (Principle)

### 中介者替代直接交互

对象不直接相互引用，而是通过中介者通信。中介者封装交互逻辑，各对象只需知道中介者。

### 网状变星状

多对多交互变为一对多交互：每个Colleague只与Mediator交互，Mediator协调所有Colleague。

## 心法 (Best Practices)

### Mediator可能复杂

Mediator自身可能变得复杂，因为它需要协调所有Colleague交互。复杂中介者可能需要分解。

### 与Facade区别

Facade简化子系统接口，提供单向视图；Mediator协调同事对象交互，提供多向协作。Facade不定义新功能，Mediator定义协作行为。

### 一句话总结

Mediator是**封装对象间交互的网状依赖松散解耦器**——集中控制、简化协议、独立改变。

## Wikilinks

- [[设计模式]] — 行为型模式之一
- [[Facade]] — 都简化系统交互，但Facade提供单向接口，Mediator协调多向交互
- [[Observer]] — 都涉及对象间通信，但Observer广播通知，Mediator集中协调
- [[Command]] — Command封装单一请求，Mediator封装系列交互
- [[设计模式：可复用面向对象软件的基础]]