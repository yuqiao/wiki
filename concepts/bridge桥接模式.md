---
title: Bridge 桥接模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Bridge 桥接模式

## 概念 (Concept)

将抽象部分与它的实现部分分离，使它们都可以独立地变化。

别名：Handle/Body。

## 价值 (Value)

### 解决什么问题

- 当抽象可能有多个实现时，通常用继承协调它们
- 继承机制将抽象与实现固定在一起，难以独立修改、扩充和重用
- 扩展Window抽象适用于不同种类窗口或新系统平台不方便
- 继承机制使客户代码与平台相关

### 带来什么收益

1. **分离接口及实现**：实现未必不变地绑定在接口上，可在运行时刻配置，甚至改变实现
2. **提高可扩充性**：独立对Abstraction和Implementor层次结构进行扩充
3. **实现细节对客户透明**：隐藏实现细节，如共享Implementor对象及引用计数机制

## 用法 (Usage)

### 适用场景

- 不希望抽象与实现部分有固定绑定关系（运行时刻实现部分可被选择或切换）
- 抽象及实现都应可通过生成子类扩充（对不同抽象接口和实现部分组合并分别扩充）
- 对抽象的实现部分修改应对客户不产生影响（客户代码不必重新编译）
- 想对客户完全隐藏抽象的实现部分（C++中类表示在类接口中可见）
- 有许多类要生成（嵌套的普化nested generalizations）
- 多个对象间共享实现（引用计数），客户不知道这一点

### 参与者

- **Abstraction**：定义抽象类接口，维护指向Implementor类型对象的指针
- **RefinedAbstraction**：扩充由Abstraction定义的接口
- **Implementor**：定义实现类接口，接口不一定要与Abstraction接口完全一致
- **ConcreteImplementor**：实现Implementor接口并定义具体实现

### 协作方式

Abstraction将client请求转发给Implementor对象。

## 原理 (Principle)

### 独立类层次结构

Bridge将Window抽象和实现部分分别放在独立的类层次结构中：一个针对窗口接口（Window、IconWindow、TransientWindow），另一个针对平台相关窗口实现（WindowImp、XWindowImp、PMWindowImp）。

### 桥接关系

Window与WindowImp之间关系称为桥接，因为它在抽象类与实现之间起到桥梁作用，使它们可独立变化。

## 心法 (Best Practices)

### 仅有一个Implementor

仅有一个实现时，不必创建抽象Implementor类（Bridge退化情况）。但分离机制仍有用——改变类实现不影响已有客户程序，不需重新编译。

### 创建正确Implementor

- Abstraction知道所有ConcreteImplementor类，在构造器中实例化其中一个
- 选择缺省实现，根据需要改变（如collection大小超出阈值切换实现）
- 代理给另一个对象决定（引入factory对象封装系统平台细节）

### 一句话总结

Bridge是**分离抽象与实现的独立变化器**——两个类层次结构独立扩充、运行时切换实现、隐藏实现细节。

## Wikilinks

- [[设计模式]] — 结构型模式之一
- [[Abstract Factory]] — Bridge可用Abstract Factory创建正确Implementor
- [[Adapter]] — 结构相似但目的不同：Adapter让不兼容接口协同，Bridge分离抽象与实现
- [[Strategy]] — 结构相似：Strategy改变算法，Bridge改变实现
- [[设计模式：可复用面向对象软件的基础]]