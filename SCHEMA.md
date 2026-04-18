# Wiki Schema

## Domain
个人知识管理（PKM）—— 学习笔记、项目追踪、技术积累、思维模型、工具与方法论。

## Conventions
- 文件名：小写字母、连字符、无空格（如 `transformer-architecture.md`）
- 每个页面以 YAML frontmatter 开头（见下方模板）
- 使用 `[[wikilinks]]` 链接页面（每页至少 2 个出站链接）
- 更新页面时必须更新 `updated` 日期
- 新页面必须添加到 `index.md` 对应分类下
- 每次操作必须追加到 `log.md`

## Frontmatter
```yaml
---
title: 页面标题
created: YYYY-MM-DD
updated: YYYY-MM-DD
type: entity | concept | comparison | query | summary
tags: [来自下方标签体系]
sources: [raw/articles/source-name.md]
---
```

## Tag Taxonomy

### 知识类型
- `concept` — 概念、理论、方法论
- `technique` — 技术、技巧、实践方法
- `framework` — 框架、模型、体系
- `principle` — 原则、定律、公理

### 主题领域
- `ai-ml` — 人工智能与机器学习
- `programming` — 编程与软件工程
- `productivity` — 效率与时间管理
- `thinking` — 思维方法与认知科学
- `business` — 商业、创业、产品
- `health` — 健康、运动、生活

### 资源类型
- `tool` — 工具、软件、服务
- `book` — 书籍、课程、教程
- `paper` — 论文、研究文章
- `project` — 项目、实践案例

### 元标签
- `comparison` — 对比分析
- `timeline` — 时间线、演进
- `controversy` — 争议、不同观点
- `prediction` — 预测、趋势
- `todo` — 待研究、待完善

## Page Thresholds
- **创建页面**：当一个实体/概念在 2+ 来源中出现，或对某个来源核心重要
- **添加到现有页面**：当来源提到了已覆盖的内容
- **不创建页面**：对于仅提及、次要细节、或超出领域范围的内容
- **拆分页面**：当页面超过 ~200 行时 —— 拆分为子主题并交叉链接
- **归档页面**：当内容完全过时时 —— 移动到 `_archive/`，从 index 移除

## Entity Pages
每个重要实体一个页面。包含：
- 概述 / 是什么
- 关键事实和日期
- 与其他实体的关系（[[wikilinks]]）
- 来源引用

### Entity 子分类（index.md 显示规则）
在 `index.md` 的 Entities 下，按子类别分组显示：
- **### Books** — 书籍、课程、教程
- **### Authors** — 作者、演讲者、创作者
- **### Articles** — 文章、博客、访谈（如有）
- **### Tools** — 工具、软件、产品（如有）

每个子类别内按字母顺序排列。

## Concept Pages
每个概念或主题一个页面。包含：
- 定义 / 解释
- 当前认知状态
- 开放问题或争议
- 相关概念（[[wikilinks]]）

## Comparison Pages
对比分析。包含：
- 比较对象和原因
- 比较维度（表格格式优先）
- 结论或综合
- 来源

## Update Policy
当新信息与现有内容冲突时：
1. 检查日期 —— 较新来源通常取代较旧来源
2. 如果确实矛盾，记录两个立场及其日期和来源
3. 在 frontmatter 中标记矛盾：`contradictions: [page-name]`
4. 在 lint 报告中标记供用户审查