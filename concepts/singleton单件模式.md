---
title: Singleton 单件模式
created: 2026-04-24
updated: 2026-04-24
type: concept
tags: [concept, programming, technique, design-pattern]
sources: [raw/papers/设计模式.pdf]
---

# Singleton 单件模式

## 概念 (Concept)

保证一个类仅有一个实例，并提供一个访问它的全局访问点。让类自身负责保存它的唯一实例，截取创建新对象的请求，并提供访问该实例的方法。

## 价值 (Value)

### 解决什么问题

- 系统中某些类只能有一个实例（打印机假脱机、文件系统、窗口管理器）
- 全局变量可以访问对象但无法防止实例化多个对象
- 需要控制唯一实例的访问方式

### 带来什么收益

1. **受控访问**：类封装唯一实例，严格控制客户怎样何时访问
2. **缩小名空间**：避免全局变量污染名空间
3. **可扩展**：允许子类化，运行时刻配置应用使用所需实例
4. **灵活实例数**：易于改变想法，允许多实例，控制数目
5. **比类操作灵活**：C++静态成员函数非虚函数，子类无法多态重定义

## 用法 (Usage)

### 适用场景

- 类只能有一个实例且客户可从众所周知的访问点访问
- 唯一实例应通过子类化可扩展，客户无需更改代码使用扩展实例

### 实现要点

```cpp
class Singleton {
public:
    static Singleton* Instance();
protected:
    Singleton();
private:
    static Singleton* _instance;
};

Singleton* Singleton::_instance = 0;

Singleton* Singleton::Instance() {
    if (_instance == 0) {
        _instance = new Singleton;
    }
    return _instance;
}
```

关键：构造器保护型，防止直接实例化；Instance用惰性初始化。

### 创建子类的方法

1. **Instance操作中决定**：用环境变量选择子类
2. **链接时刻决定**：链入不同实现的对象文件
3. **单件注册表**：根据名字在注册表查询，更灵活

## 原理 (Principle)

### 为什么有效

类自身控制实例化过程，比外部控制更可靠。通过静态成员函数封装创建逻辑，保证只有首次访问时创建。

### C++实现注意

不能用全局/静态对象依赖自动初始化，原因：
- 不能保证只有一个实例被声明
- 可能没有足够信息在静态初始化时实例化
- C++没有定义跨转换单元全局对象构造器调用顺序

## 心法 (Best Practices)

### 使用陷阱

- **不要滥用**：不是所有"全局"概念都需要Singleton
- **多线程问题**：双重检查锁定模式，或用静态初始化
- **测试困难**：单件状态影响测试隔离，需考虑测试友好设计
- **隐藏依赖**：使用Singleton意味着隐式依赖，影响代码可读性

### 替代方案

- 依赖注入：通过构造器/参数传递，更显式
- 模块模式：Python/JavaScript中的模块天然单件
- Service Locator：注册表中查找服务

### 一句话总结

Singleton是**用类本身来保证唯一性的全局变量替代方案**——控制访问、缩小名空间、可扩展。

## Wikilinks

- [[设计模式]] — 创建型模式之一
- [[Abstract Factory]] — 可用Singleton实现
- [[Builder]] — 可用Singleton实现
- [[设计模式：可复用面向对象软件的基础]]