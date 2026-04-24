---
title: Visitor 访问者模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Visitor 访问者模式

## 概念 (Concept)

表示一个作用于某对象结构中的各元素的操作。它使你可以在不改变各元素的类的前提下定义作用于这些元素的新操作。

## 价值 (Value)

### 解决什么问题

- 对象结构（如Composite）包含多种类型元素
- 需要对不同类型元素执行不同操作
- 操作逻辑分散在各元素类中，难以维护
- 新增操作时需修改每个元素类

### 带来什么收益

1. **易于添加新操作**：新增操作只需添加新Visitor，不需修改元素类
2. **相关操作集中**：相关操作集中在一个Visitor中，而非分散在多个元素类
3. **访问对象结构**：Visitor遍历对象结构，访问每个元素执行操作

## 用法 (Usage)

### 适用场景

- 对象结构稳定，但经常需要在此结构上定义新操作
- 需要对对象结构中不同类型元素执行不同操作
- 对象结构中元素类很少变动，但需频繁添加新操作

### 参与者

- **Visitor**：为对象结构中每个ConcreteElement声明Visit操作
- **ConcreteVisitor**：实现每个Visit操作，是操作的实现
- **Element**：定义Accept操作，以Visitor为参数
- **ConcreteElement**：实现Accept操作，调用Visitor相应Visit操作
- **ObjectStructure**：能枚举元素，提供高层接口让Visitor访问元素

### 协作方式

Client创建ConcreteVisitor对象，然后遍历ObjectStructure，调用每个元素Accept操作并以Visitor为参数。元素调用Visitor相应Visit操作，元素将自己作为参数传递给Visit操作。

## 原理 (Principle)

### 双分派

Visitor模式使用双分派技术：元素Accept操作调用VisitorVisit操作，Visit操作参数是元素类型。两次分派：第一次Accept确定元素类型，第二次Visit确定操作类型。

### 累积状态

Visitor在遍历过程中可累积状态。状态可存储在Visitor中，而非分散在各元素。

## 心法 (Best Practices)

### 破坏封装

Visitor可能破坏元素封装——Visit操作需要访问元素内部状态。可通过Element提供公共访问操作，或Visitor访问Element公共接口。

### 新增元素困难

新增ConcreteElement类需修改Visitor接口及所有ConcreteVisitor，新增Visitor容易但新增Element困难。对象结构稳定时Visitor模式适合。

### 一句话总结

Visitor是**不改变元素类添加新操作的双分派累积器**——集中操作、易于添加操作、遍历对象结构。

## Wikilinks

- [[设计模式]] — 行为型模式之一
- [[Composite]] — Visitor常用于操作Composite结构
- [[Iterator]] — Iterator遍历，Visitor访问并操作
- [[Interpreter]] — Interpreter可用Visitor执行语法树操作
- [[设计模式：可复用面向对象软件的基础]]