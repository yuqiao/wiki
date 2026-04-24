---
title: Composite 组合模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Composite 组合模式

## 概念 (Concept)

将对象组合成树形结构以表示"部分-整体"的层次结构。Composite使得用户对单个对象和组合对象的使用具有一致性。

## 价值 (Value)

### 解决什么问题

- 图形应用中用户可用简单组件创建复杂图表
- 简单实现需区别对待图元对象与容器对象，程序复杂
- 大多数情况下用户认为图元和容器是一样的

### 带来什么收益

1. **定义层次结构**：包含基本对象和组合对象的类层次结构，递归组合
2. **简化客户代码**：一致使用组合结构和单个对象，不需知道处理的是叶节点还是组合组件
3. **容易增加新组件**：新定义的Composite或Leaf子类自动与已有结构和客户代码工作
4. **设计一般化**：容易增加新组件，但难以限制组合中组件（运行时刻检查）

## 用法 (Usage)

### 适用场景

- 想表示对象的部分-整体层次结构
- 希望用户忽略组合对象与单个对象的不同，统一使用组合结构中所有对象

### 参与者

- **Component**：为组合中对象声明接口，实现共有接口缺省行为，声明访问管理子组件接口
- **Leaf**：表示叶节点对象，没有子节点，定义图元对象行为
- **Composite**：定义有子部件的部件行为，存储子部件，实现与子部件有关操作
- **Client**：通过Component接口操纵组合部件对象

### 协作方式

用户用Component类接口与组合结构中对象交互。接收者是叶节点则直接处理请求；是Composite则将请求发送给子部件，可能执行辅助操作。

## 原理 (Principle)

### 递归组合

关键是一个抽象类，既可代表图元，又可代表图元的容器。Graphic声明与特定图形对象相关操作（Draw），也声明组合对象共享操作（访问管理子部件）。

### Picture递归组合

Picture的Draw操作通过对子部件调用Draw实现。Picture接口与Graphic接口一致，Picture对象可递归组合其他Picture对象。

## 心法 (Best Practices)

### 安全性vs透明性权衡

- **透明性**：在类层次根部定义子节点管理接口，一致使用所有组件，但客户可能做无意义的事（在Leaf增加删除对象）
- **安全性**：只在Composite声明子节点管理操作，需检查类型，但失去透明性

### 实现要点

- **父部件引用**：保持从子部件到父部件引用，简化遍历和管理，支持Chain of Responsibility
- **共享组件**：减少存储需求，但只有一个父部件时难共享，可用Flyweight
- **最大化Component接口**：Composite类应为Leaf和Composite类尽可能多定义公共操作

### 一句话总结

Composite是**用统一接口处理部分-整体层次结构的树形组合器**——递归组合、透明使用、简化客户代码。

## Wikilinks

- [[设计模式]] — 结构型模式之一
- [[MVC架构]] — MVC中View用Composite管理子View
- [[iterator迭代器模式]] — 可用Iterator遍历Composite结构
- [[Visitor]] — Visitor常用于操作Composite结构
- [[Chain of Responsibility]] — Composite父部件引用支持该模式
- [[Flyweight]] — 可用Flyweight共享组件
- [[设计模式：可复用面向对象软件的基础]]