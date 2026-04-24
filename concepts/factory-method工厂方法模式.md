---
title: Factory Method 工厂方法模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Factory Method 工厂方法模式

## 概念 (Concept)

定义一个用于创建对象的接口，让子类决定实例化哪一个类。Factory Method使一个类的实例化延迟到其子类。

别名：虚构造器(Virtual Constructor)。

## 价值 (Value)

### 解决什么问题

- 框架用抽象类定义和维护对象关系，对象创建也由框架负责
- 框架必须实例化类，但只知道不能被实例化的抽象类
- 类不知道它必须创建的对象的类

### 带来什么收益

1. **解耦**：不再将与应用有关的类绑定到代码中，仅处理Product接口
2. **挂钩**：给子类提供挂钩，提供对象扩展版本
3. **连接平行类层次**：将哪些类应一同工作的信息局部化

## 用法 (Usage)

### 适用场景

- 类不知道它必须创建的对象的类
- 类希望由子类指定它创建的对象
- 类将创建对象的职责委托给多个帮助子类中的某一个，希望将哪个帮助子类是代理者局部化

### 参与者

- **Product**：定义工厂方法所创建的对象的接口
- **ConcreteProduct**：实现Product接口
- **Creator**：声明工厂方法，返回Product类型对象，可定义默认实现
- **ConcreteCreator**：重定义工厂方法返回ConcreteProduct实例

### 协作方式

Creator依赖子类定义工厂方法，返回适当ConcreteProduct实例。

## 原理 (Principle)

### 延迟实例化

工厂方法将实例化延迟到子类。Creator只知道何时创建，不知道哪个类被创建。

### 虚构造器

工厂方法像虚构造器，子类决定具体类型。调用者不需要知道具体类。

### 参数化工厂方法

工厂方法可采用参数标识要创建的对象种类，创建多种产品共享Product接口。

## 心法 (Best Practices)

### 潜在缺点

客户可能仅为创建特定ConcreteProduct对象，不得不创建Creator子类。但客户本就必须创建子类时，这可行。

### 两种情况

1. **Creator抽象类**：不提供工厂方法实现，子类必须定义
2. **Creator具体类**：为工厂方法提供默认实现

### 平行类层次

当类将职责委托给独立类时产生平行类层次。工厂方法定义两个类层次之间的连接，局部化哪些类应一同工作。

### 现代演变

- **简单工厂**：静态方法创建对象，非严格Factory Method
- **工厂模式**：Abstract Factory常组合Factory Method
- **IoC容器**：依赖注入框架内置工厂机制

### 一句话总结

Factory Method是**让子类决定实例化哪个类的虚构造器**——延迟绑定、解耦框架与应用。

## Wikilinks

- [[设计模式]] — 创建型模式之一
- [[Abstract Factory]] — 常用Factory Method实现
- [[Singleton]] — 可替代Factory Method某些场景
- [[设计模式：可复用面向对象软件的基础]]