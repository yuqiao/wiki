---
title: Memory Folder
created: 2026-04-26
updated: 2026-04-26
type: concept
tags: [technique, ai-ml, agent]
sources:
  - raw/articles/anthropic-harnessing-claudes-intelligence-2026.md
---

# Memory Folder（记忆文件夹）

> Claude 持久化上下文到文件的简单方式。

## 概念 (Concept)

**Memory Folder**：允许 Claude 写上下文到文件，之后按需读取的机制。

Anthropic Claude Platform 团队成员 Lance Martin 在《Harnessing Claude's Intelligence》中描述。

与传统 retrieval infrastructure 不同：给 Claude 简单方式自己选择持久化什么内容。

## 价值 (Value)

### 解决什么问题

Long-running agents 超过单个 context window 限制。

传统假设：memory systems 应该依赖围绕模型的 retrieval infrastructure。

Memory folder 给 Claude 选择权：自己决定持久化什么。

### BrowseComp-Plus 数据

| 模型 | 配置 | Accuracy |
|------|------|----------|
| Sonnet 4.5 | 无 memory folder | 60.4% |
| Sonnet 4.5 | + memory folder | 67.2% |

+6.8% 提升。

## 用法 (Usage)

### 机制

Claude 可以：
- 写上下文到 memory folder
- 之后读取需要的部分
- 组织文件结构

### Pokémon Case Study

展示 Claude 用 memory folder 的演进：

**Sonnet 3.5 (14,000 steps)**：
- 31 files
- Transcript-style（记录 NPC 说了什么）
- 包含 duplicate（caterpie_weedle_info）
- Still in second town

**Opus 4.6 (14,000 steps)**：
- 10 files organized into directories
- Tactical notes
- `/gameplay/learnings.md`：蒸馏失败经验
- 3 gym badges

**Learnings.md 示例**：
```
- Bellsprout Sleep+Wrap combo: KO FAST with BITE before Sleep Powder lands.
- Gen 1 Bag Limit: 20 items max. Toss unneeded TMs before dungeons.
- Spin tile mazes: Different entry y-positions lead to DIFFERENT destinations.
```

## 原理 (Principle)

### Transcript vs Tactical

Sonnet 3.5：记录"发生了什么"（transcript）
Opus 4.6：记录"学到了什么"（tactical notes）

后者更高效——蒸馏经验而非复述事件。

### 目录组织

Opus 4.6 用目录组织文件：
- 更易检索
- 语义清晰
- 避免重复

## 心法 (Best Practices)

### 让 Claude 自己组织

不要预设文件结构，让 Claude 决定如何组织。

### 鼓励蒸馏而非复述

Prompt 或 skill 中提示：写 tactical notes，不写 transcript。

### 定期清理

Old files 可能过时。考虑 context editing 清理 stale memory。

## 关联

- [[Lance Martin]]
- [[Anthropic]]
- [[Compaction]]
- [[渐进式披露]]
- [[Context Anxiety]]
- [[长任务连贯性]]