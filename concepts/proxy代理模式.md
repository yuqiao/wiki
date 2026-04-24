---
title: Proxy 代理模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Proxy 代理模式

## 概念 (Concept)

为其他对象提供一种代理以控制对这个对象的访问。

## 价值 (Value)

### 解决什么问题

- 需要控制对象访问但直接访问不合适
- 对象创建代价高，需延迟创建
- 对象在不同地址空间，需远程代理
- 需要保护对象，控制访问权限

### 带来什么收益

1. **远程代理**：隐藏对象在不同地址空间的事实
2. **虚拟代理**：延迟创建开销大的对象，按需创建
3. **保护代理**：控制对原始对象的访问权限
4. **智能引用**：在访问对象时执行额外操作（引用计数、持久化）

## 用法 (Usage)

### 适用场景

- **远程代理**：对象在不同地址空间，如.NET Remoting、RPC
- **虚拟代理**：创建开销大的对象按需创建，如图片延迟加载
- **保护代理**：控制访问权限，如权限检查
- **智能引用**：访问时执行额外操作，如引用计数

### 参与者

- **Proxy**：保存引用使得代理可访问实体；提供与Subject相同接口；控制对实体访问并负责创建删除
- **Subject**：定义RealSubject和Proxy共用接口
- **RealSubject**：定义代理所代表的实体

### 协作方式

Proxy转发请求给RealSubject，可能在转发前后执行额外操作。

## 原理 (Principle)

### 代理代替实体

Proxy代替RealSubject，客户通过Proxy访问RealSubject。Proxy控制访问，可能延迟创建、保护访问、添加智能引用。

### 与实体相同接口

Proxy实现与RealSubject相同接口，客户不知道访问的是代理还是实体。

## 心法 (Best Practices)

### 与Adapter区别

Adapter转换接口，Proxy保持接口不变。Adapter让不兼容接口协同，Proxy控制访问。

### 与Decorator区别

Decorator添加职责，Proxy控制访问。Decorator透明添加功能，Proxy可能完全替代实体。

### 一句话总结

Proxy是**控制对象访问的接口保持代理器**——远程代理、虚拟代理、保护代理、智能引用。

## Wikilinks

- [[设计模式]] — 结构型模式之一
- [[Adapter]] — 结构相似但目的不同：Adapter转换接口，Proxy控制访问
- [[Decorator]] — 都是包装器，但Decorator添加职责，Proxy控制访问
- [[Facade]] — Facade简化接口，Proxy保持接口控制访问
- [[设计模式：可复用面向对象软件的基础]]