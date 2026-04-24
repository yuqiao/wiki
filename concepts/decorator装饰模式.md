---
title: Decorator 装饰模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Decorator 装饰模式

## 概念 (Concept)

动态地给一个对象添加一些额外的职责。就增加功能来说，Decorator模式相比生成子类更为灵活。

别名：包装器(Wrapper)。

## 价值 (Value)

### 解决什么问题

- 给某个对象（不是整个类）添加功能
- 继承添加功能不够灵活，边框选择是静态的，用户不能控制方式和时机
- 可能大量独立扩展，组合产生子类爆炸增长
- 类定义被隐藏或不能用于生成子类

### 带来什么收益

1. **比静态继承灵活**：运行时刻增加删除职责，混合匹配职责
2. **避免高层类太多特征**：即用即付方法，不从复杂可定制类支持所有特征
3. **可重复添加特性**：双边框只需添加两个BorderDecorator
4. **透明包装**：装饰过的组件可在任何Component出现处使用

## 用法 (Usage)

### 适用场景

- 不影响其他对象下，以动态透明方式给单个对象添加职责
- 处理可撤消的职责
- 不能采用生成子类扩充时（大量独立扩展/类定义隐藏）

### 参与者

- **Component**：定义对象接口，可动态添加职责
- **ConcreteComponent**：定义可添加职责的对象
- **Decorator**：维持指向Component指针，定义与Component一致接口
- **ConcreteDecorator**：向组件添加职责

### 协作方式

Decorator将请求转发给Component，可能在转发前后执行附加动作。

### 组合示例

TextView + BorderDecorator + ScrollDecorator = 有边框有滚动条的文本显示窗口。

## 原理 (Principle)

### 递归嵌套

透明性使可递归嵌套多个装饰，添加任意多功能。装饰与所装饰组件接口一致，对客户透明。

### 外壳vs内核

Decorator改变对象外壳（行为），Strategy改变对象内核。

当Component类庞大时，用Decorator代价高，Strategy相对更好。

## 心法 (Best Practices)

### 潜在缺点

1. **Decorator与Component不一样**：从对象标识角度，装饰组件与原组件有差别，不应依赖对象标识
2. **许多小对象**：产生许多相似小对象，仅连接方式不同，学习排错困难

### 实现技巧

- **接口一致性**：装饰对象接口必须与所装饰Component一致
- **省略抽象Decorator**：仅添加一个职责时，可合并转发职责到ConcreteDecorator
- **保持Component简单**：集中定义接口不存储数据，避免复杂庞大

### 现代应用

- **Java I/O**：InputStream → BufferedInputStream → DataInputStream
- **Python装饰器**：@decorator语法糖，函数包装
- **TypeScript Mixin**：类功能组合

### 与Strategy选择

- Component类原本庞大：Strategy代价更低
- Component类简单：Decorator更直观

### 一句话总结

Decorator是**动态透明添加职责的对象外壳**——递归嵌套、运行时组合、比继承灵活。

## Wikilinks

- [[设计模式]] — 结构型模式之一
- [[Strategy]] — 改变内核vs改变外壳
- [[Composite]] — 结构图相似但意图不同
- [[Proxy]] — 结构相似但目的不同
- [[设计模式：可复用面向对象软件的基础]]