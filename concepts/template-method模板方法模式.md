---
title: Template Method 模板方法模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Template Method 模板方法模式

## 概念 (Concept)

定义一个操作中的算法骨架，而将一些步骤延迟到子类中。Template Method使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。

## 价值 (Value)

### 解决什么问题

- 应用框架中抽象类定义算法骨架，具体子类实现特定步骤
- 不同应用需要不同实现，但算法结构相同
- 需要控制子类扩展点

### 带来什么收益

1. **代码复用**：算法骨架在抽象类中定义一次，子类共享
2. **控制扩展**：模板方法调用抽象操作（hook操作），子类可重定义
3. **反向控制**：父类调用子类方法（好莱坞原则：不要调用我们，我们会调用你）

## 用法 (Usage)

### 适用场景

- 一次性实现算法不变部分，将可变行为留给子类实现
- 各子类中公共行为应被提取并集中到一个公共父类，避免代码重复
- 控制子类扩展——模板方法只在特定点调用hook操作，只允许在这些点扩展

### 参与者

- **AbstractClass**：定义抽象的原语操作，具体子类重定义实现算法步骤；实现模板方法定义算法骨架，调用原语操作
- **ConcreteClass**：实现原语操作完成算法特定步骤

### 协作方式

ConcreteClass实现AbstractClass声明的原语操作完成算法特定步骤。AbstractClass实现模板方法定义算法骨架。

## 原理 (Principle)

### 算法骨架不变

模板方法定义算法骨架，调用原语操作。原语操作是抽象的，ConcreteClass重定义实现。

### 好莱坞原则

高层组件（父类）决定何时调用低层组件（子类），低层组件被动等待调用。反向控制：父类调用子类方法。

## 心法 (Best Practices)

### 原语操作命名

C++中实现模板方法的原语操作用protected确保子类可访问。原语操作命名用Do前缀（如DoRead、DoWrite）区分普通操作。

### hook操作

模板方法可调用缺省操作（hook操作），子类可选择重定义或不重定义。缺省操作通常什么都不做或提供缺省行为。

### 一句话总结

Template Method是**定义算法骨架让子类填充步骤的骨架控制器**——代码复用、反向控制、控制扩展点。

## Wikilinks

- [[设计模式]] — 行为型模式之一
- [[Strategy]] — Strategy用委托改变整个算法，Template Method用继承改变部分步骤
- [[Factory Method]] — Factory Method是Template Method的特化，创建对象是模板方法调用
- [[设计模式：可复用面向对象软件的基础]]