---
title: Interpreter 解释器模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Interpreter 解释器模式

## 概念 (Concept)

给定一个语言，定义它的文法的一种表示，并定义一个解释器，这个解释器使用该表示来解释语言中的句子。

## 价值 (Value)

### 解决什么问题

- 特定类型问题发生频率足够高，值得将实例表述为简单语言句子
- 搜索匹配模式字符串是常见问题，正则表达式是描述字符串模式的标准语言
- 为每个模式构造特定算法不如用通用搜索算法解释执行正则表达式

### 带来什么收益

1. **易于改变和扩展文法**：用类表示文法规则，可用继承改变或扩展文法
2. **易于实现文法**：定义抽象语法树各节点类实现大体类似，易于直接编写
3. **复杂文法难以维护**：文法每条规则至少定义一个类，类层次变得庞大无法管理

## 用法 (Usage)

### 适用场景（效果最好）

- 有语言需要解释执行，可将句子表示为抽象语法树
- 文法简单（复杂文法类层次庞大无法管理，语法分析程序生成器更好选择）
- 效率不是关键问题（最高效解释器通常先转换成另一种形式，如正则表达式转状态机）

### 参与者

- **AbstractExpression**：声明抽象解释操作，接口为抽象语法树所有节点共享
- **TerminalExpression**：实现与文法终结符相关联的解释操作，句子中每个终结符需该类实例
- **NonterminalExpression**：文法每条规则需要一个类，维护每个符号实例变量，递归调用子表达式解释操作
- **Context**：包含解释器之外全局信息
- **Client**：构建表示特定句子的抽象语法树，调用解释操作

### 协作方式

Client构建句子（抽象语法树），初始化上下文并调用解释操作。每一非终结符表达式节点定义子表达式解释操作，终结符表达式解释操作构成递归基础。每节点解释操作用上下文存储和访问解释器状态。

## 原理 (Principle)

### 正则表达式文法

符号expression是开始符号，literal是定义简单字的终结符。文法用五个类表示：RegularExpression抽象类和四个子类LiteralExpression、AlternationExpression、SequenceExpression、RepetitionExpression。

### 抽象语法树

正则表达式raining & (dogs | cats) *表示为抽象语法树。RegularExpression子类定义Interpret操作，得到解释器。上下文包含输入字符串和已匹配信息。

## 心法 (Best Practices)

### 可使用Visitor

访问者模式可避免在每一子类定义Interpret操作，一个Visitor可访问所有节点。Visitor可执行解释操作。

### 与Composite关系

抽象语法树是Composite实例——NonterminalExpression包含子表达式（TerminalExpression或其他NonterminalExpression）。

### 一句话总结

Interpreter是**用类表示文法规则构建抽象语法树的解释执行器**——易于改变扩展文法、适合简单文法、效率非关键。

## Wikilinks

- [[设计模式]] — 行为型模式之一
- [[Composite]] — 抽象语法树是Composite实例
- [[Visitor]] — Visitor可执行解释操作
- [[Flyweight]] — 抽象语法树终端节点可共享
- [[设计模式：可复用面向对象软件的基础]]