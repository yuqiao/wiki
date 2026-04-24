---
title: Abstract Factory 抽象工厂模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Abstract Factory 抽象工厂模式

## 概念 (Concept)

提供一个创建一系列相关或相互依赖对象的接口，而无需指定它们具体的类。

别名：Kit。

## 价值 (Value)

### 解决什么问题

- 支持多种视感标准的用户界面工具包（Motif、Presentation Manager）
- 不应为特定视感外观硬编码窗口组件
- 实例化特定视感风格窗口组件类使以后很难改变视感风格

### 带来什么收益

1. **分离具体的类**：控制应用创建对象的类，客户通过抽象接口操纵实例
2. **易于交换产品系列**：具体工厂类仅出现一次（初始化时），改变具体工厂即改变产品配置
3. **有利于产品一致性**：当系列中产品对象被设计成一起工作时，一次只能使用同一系列对象
4. **难以支持新种类的产品**：AbstractFactory接口确定可被创建的产品集合，支持新产品需扩展接口

## 用法 (Usage)

### 适用场景

- 系统要独立于产品创建、组合和表示
- 系统要由多个产品系列中的一个来配置
- 强调一系列相关产品对象的设计以便联合使用
- 提供产品类库，只显示接口而不是实现

### 参与者

- **AbstractFactory**：声明创建抽象产品对象的操作接口
- **ConcreteFactory**：实现创建具体产品对象的操作
- **AbstractProduct**：为一类产品对象声明接口
- **ConcreteProduct**：定义被相应具体工厂创建的产品对象
- **Client**：仅使用AbstractFactory和AbstractProduct类声明的接口

### 协作方式

通常在运行时刻创建一个ConcreteFactory类的实例，具体工厂创建具有特定实现的产品对象。为创建不同产品对象，客户应使用不同具体工厂。

## 原理 (Principle)

### 视感标准对应具体工厂

每种视感标准对应一个具体WidgetFactory子类，每子类实现创建合适视感风格窗口组件的操作。客户仅通过WidgetFactory接口创建窗口组件，不知道哪些类实现了特定视感风格窗口组件。

### 自动增强依赖关系

WidgetFactory增强具体窗口组件类之间依赖关系。Motif滚动条应与Motif按钮、Motif正文编辑器一起使用，这一约束条件作为使用MotifWidgetFactory的结果被自动加上。

## 心法 (Best Practices)

### 工厂作为单件

应用中一般每个产品系列只需一个ConcreteFactory实例，工厂通常最好实现为Singleton。

### 创建产品方法

- **Factory Method**：为每个产品定义一个工厂方法，具体工厂重定义该方法指定产品
- **Prototype**：具体工厂用产品系列中每个产品的原型实例初始化，通过复制原型创建新产品

### 一句话总结

Abstract Factory是**创建产品家族系列的相关对象工厂**——分离具体类、易于交换产品系列、保证一致性。

## Wikilinks

- [[设计模式]] — 创建型模式之一
- [[Singleton]] — Abstract Factory通常用Singleton实现
- [[Factory Method]] — Abstract Factory用Factory Method实现
- [[Prototype]] — Abstract Factory可用Prototype实现
- [[Builder]] — 都创建复杂对象，但Builder分步构建，Abstract Factory立即返回
- [[设计模式：可复用面向对象软件的基础]]