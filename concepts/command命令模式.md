---
title: Command 命令模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Command 命令模式

## 概念 (Concept)

将一个请求封装为一个对象，从而使你可用不同的请求对客户进行参数化；对请求排队或记录请求日志，以及支持可撤消的操作。

别名：动作Action、事务Transaction。

## 价值 (Value)

### 解决什么问题

- 用户界面工具箱对象（按钮、菜单）执行请求响应用户输入
- 工具箱不能显式在按钮或菜单中实现请求，只有应用知道哪个对象做哪个操作
- 工具箱设计者无法知道请求的接受者或执行的操作

### 带来什么收益

1. **解耦调用者和接收者**：调用操作的对象与知道如何实现操作的对象解耦
2. **头等的对象**：Command可像其他对象一样被操纵和扩展
3. **复合命令**：可将多个命令装配成一个复合命令（MacroCommand）
4. **容易增加新Command**：无需改变已有类

## 用法 (Usage)

### 适用场景

- 抽象出待执行动作以参数化某对象（回调的面向对象替代品）
- 在不同时刻指定、排列和执行请求
- 支持取消操作
- 支持修改日志，系统崩溃时可重做
- 用构建在原语操作上的高层操作构造系统（支持事务）

### 参与者

- **Command**：声明执行操作的接口
- **ConcreteCommand**：将接收者对象绑定于一个动作，调用接收者相应操作实现Execute
- **Client**：创建具体命令对象并设定接收者
- **Invoker**：要求命令执行这个请求
- **Receiver**：知道如何实施与执行请求相关的操作

### 协作流程

1. Client创建ConcreteCommand对象并指定Receiver
2. Invoker对象存储该ConcreteCommand对象
3. Invoker调用Command的Execute提交请求
4. ConcreteCommand调用Receiver操作执行请求

## 原理 (Principle)

### 将请求本身变成对象

可被存储并像其他对象一样被传递。关键是一个抽象Command类，定义执行操作接口（Execute操作）。具体Command子类将接收者作为实例变量，实现Execute。

### MacroCommand复合命令

执行一个命令序列。MacroCommand是具体Command子类，没有明确接收者，序列中命令各自定义其接收者。

## 心法 (Best Practices)

### 智能程度选择

- **极端1**：仅确定接收者和执行请求动作
- **极端2**：自己实现所有功能，不需要额外接收者对象（当没有合适接收者或隐式知道接收者时）
- **中间**：有足够信息可动态找到接收者

### 支持取消和重做

Command提供Unexecute或Undo操作逆转执行。ConcreteCommand需存储：
- 接收者对象
- 接收者上执行操作的参数
- 如果操作会改变接收者值，这些值必须先存储

历史列表存储被执行命令序列，向后遍历Unexecute取消，向前遍历Execute重做。

### 一句话总结

Command是**将请求封装为对象的回调替代品**——解耦调用者与接收者、支持取消/重做/日志/事务。

## Wikilinks

- [[设计模式]] — 行为型模式之一
- [[Composite]] — MacroCommand是Composite实例
- [[Memento]] — Command可用Memento保持状态用于取消
- [[Observer]] — Command可触发Observer通知
- [[设计模式：可复用面向对象软件的基础]]