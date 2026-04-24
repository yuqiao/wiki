# SOLID原则

created: 2026-04-24
updated: 2026-04-24
type: concept
tags:
  - 软件工程
  - 设计模式
  - OOP
  - 代码质量
sources:
  - Robert C. Martin (Uncle Bob)

---

## 概念

面向对象设计的五大核心原则，由 Robert C. Martin (Uncle Bob) 提出。指导如何组织代码以提高可维护性、可扩展性和可测试性。

## 价值

- **可维护性**：职责清晰，修改影响范围可控
- **可扩展性**：新增功能无需改动现有代码
- **可测试性**：依赖抽象，易于mock和单元测试
- **降低耦合**：模块间依赖最小化

## 用法

### S - 单一职责原则 (Single Responsibility Principle)

一个类只做一件事，只有一个改变理由。

```
❌ UserService: 注册 + 登录 + 发邮件 + 记日志
✅ UserService: 用户业务逻辑
   EmailService: 发送邮件
   LogService: 记录日志
```

### O - 开闭原则 (Open/Closed Principle)

对扩展开放，对修改关闭。

```python
# ❌ 每增加一个形状都要改AreaCalculator
def area(shape):
    if shape.type == 'circle': ...
    elif shape.type == 'square': ...

# ✅ 使用多态扩展
class Shape:
    def area(self): pass

class Circle(Shape):
    def area(self): return pi * r * r
```

### L - 里氏替换原则 (Liskov Substitution Principle)

子类必须能替换父类而不破坏程序正确性。

```python
# ❌ 违反：子类抛出父类没有的异常
class Bird:
    def fly(self): ...

class Penguin(Bird):
    def fly(self): raise Exception("不会飞!")

# ✅ 正确：重新设计继承层次
class Bird: ...
class FlyingBird(Bird):
    def fly(self): ...
```

### I - 接口隔离原则 (Interface Segregation Principle)

不应强迫客户依赖它不使用的方法。

```python
# ❌ 胖接口
class Machine:
    def print(self): ...
    def scan(self): ...
    def fax(self): ...

# ✅ 拆分接口
class Printer:
    def print(self): ...
class Scanner:
    def scan(self): ...
```

### D - 依赖倒置原则 (Dependency Inversion Principle)

高层模块不应依赖低层模块，两者都应依赖抽象。

```python
# ❌ 高层依赖低层具体实现
class UserService:
    def __init__(self):
        self.db = MySQLDatabase()  # 紧耦合

# ✅ 依赖抽象
class UserService:
    def __init__(self, db: Database):  # 注入接口
        self.db = db
```

## 原理

| 原则 | 解决的问题 | 核心机制 |
|------|-----------|---------|
| SRP | 职责混乱、修改困难 | 分离关注点 |
| OCP | 每次修改影响多处 | 抽象+多态 |
| LSP | 继承滥用、行为不一致 | 行为兼容性约束 |
| ISP | 接口臃肿、依赖冗余 | 接口拆分 |
| DIP | 高层依赖低层细节 | 依赖注入 |

## 心法

1. **SRP优先** — 职责混乱是万恶之源
2. **先组合后继承** — 继承耦合度高于组合
3. **面向接口编程** — 具体实现随时可换
4. **适度原则** — 过度设计也是设计问题
5. **渐进应用** — 不必一次性全部满足，重构中逐步改善

## 与其他概念的关系

- [[设计模式]] — SOLID是设计模式的理论基础
- [[代码重构]] — 重构的目标状态往往符合SOLID
- [[测试驱动开发]] — TDD产生的代码天然符合SOLID
- [[Clean Architecture]] — SOLID是其核心设计原则

## 常见误区

1. **过度拆分** — SRP不是"每个类只有一个方法"
2. **滥用继承** — LSP不是禁止继承，而是正确使用
3. **教条主义** — 实际项目中需要权衡，不必100%遵守