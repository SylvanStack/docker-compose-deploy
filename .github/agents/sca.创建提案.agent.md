---
description: 创建 OpenSpec 变更提案，包括 proposal.md、tasks.md、design.md 和规范增量
handoffs:
  - label: 实施提案
    agent: sca.执行提案
    prompt: 实施此变更
    send: true
---

## 用户输入

```text
$ARGUMENTS
```

在继续之前，你**必须**考虑用户输入（如果非空）。

## 防护栏

- 优先采用简单直接、最小化的实现，仅在明确请求或明显需要时才增加复杂性。
- 将变更严格限定在请求的结果范围内。
- 如果需要额外的 OpenSpec 约定或澄清，请参考 `openspec/AGENTS.md`（位于 `openspec/` 目录内——如果看不到，运行 `ls openspec` 或 `openspec update`）。
- 识别任何模糊或不明确的细节，并在编辑文件之前提出必要的后续问题。
- **在提案阶段不要编写任何代码**。仅创建设计文档（proposal.md、tasks.md、design.md 和规范增量）。实施在批准后的应用阶段进行。

## 大纲

### 1. 理解请求并收集上下文

**1.1 分析用户需求**
- 明确用户想要添加、修改还是删除功能
- 识别模糊或不明确的部分
- 如有必要，提出 1-2 个关键的澄清问题

**1.2 探索现有系统**
- 运行 `openspec list` 查看活跃的变更（避免冲突）
- 运行 `openspec list --specs` 查看现有功能
- 读取 `openspec/project.md` 了解项目约定
- 使用 `rg <keyword>` 或 `ls` 探索相关代码（如果需要）

**1.3 搜索现有需求**
```bash
# 在创建新需求前搜索类似的现有需求
rg -n "Requirement:|Scenario:" openspec/specs
```

### 2. 选择变更 ID

**命名约定**：
- 使用 kebab-case 格式
- 以动词开头：`add-`、`update-`、`remove-`、`refactor-`
- 简短且描述性强
- 确保唯一性

**示例**：
- `add-user-authentication`
- `update-api-endpoints`
- `remove-legacy-cache`
- `refactor-data-pipeline`

运行 `openspec list` 确认 ID 未被使用。

### 3. 搭建提案结构

```bash
# 创建变更目录
mkdir -p openspec/changes/<change-id>/specs
```

创建以下文件：
- `openspec/changes/<change-id>/proposal.md` - **必需**
- `openspec/changes/<change-id>/tasks.md` - **必需**
- `openspec/changes/<change-id>/design.md` - **有条件需要**
- `openspec/changes/<change-id>/specs/<capability>/spec.md` - **必需**（一个或多个）

### 4. 编写 proposal.md

使用以下结构：

```markdown
# 变更：[简要描述变更]

## 为什么
[1-2 句话说明问题或机会]

## 变更内容
- [变更的项目符号列表]
- [用 **BREAKING** 标记破坏性变更]

## 影响
- 受影响的规范：[列出功能]
- 受影响的代码：[关键文件/系统]
```

**关键点**：
- 清楚说明变更的动机
- 明确列出所有变更
- 识别受影响的系统和功能

### 5. 创建规范增量

对每个受影响的功能创建 `specs/<capability>/spec.md`：

**5.1 确定功能**
- 一个功能 = 一个单一的、聚焦的能力
- 使用动词-名词命名：`user-auth`、`data-export`
- 如果描述需要用"且"，则拆分功能

**5.2 编写增量**

```markdown
## ADDED Requirements
### Requirement: 新功能名称
系统应当（SHALL）提供...

#### Scenario: 成功案例
- **WHEN** 用户执行操作
- **THEN** 预期结果

#### Scenario: 错误案例
- **WHEN** 出现错误条件
- **THEN** 系统行为

## MODIFIED Requirements
### Requirement: 现有功能名称
[粘贴完整的修改后的需求，包括所有场景]

#### Scenario: 更新的场景
- **WHEN** 条件
- **THEN** 结果

## REMOVED Requirements
### Requirement: 旧功能名称
**原因**：[为什么移除]
**迁移**：[用户如何调整]

## RENAMED Requirements
- FROM: `### Requirement: 旧名称`
- TO: `### Requirement: 新名称`
```

**关键规则**：
- 每个需求至少一个 `#### Scenario:`（使用 4 个 #）
- 使用 SHALL/MUST 表示规范性需求
- MODIFIED 需求必须包含完整的更新内容（不是部分增量）
- 相关时交叉引用其他功能

### 6. 起草 tasks.md

```markdown
## 1. 准备
- [ ] 1.1 审查设计文档
- [ ] 1.2 设置开发环境
- [ ] 1.3 创建功能分支

## 2. 核心实施
- [ ] 2.1 实施功能 A
- [ ] 2.2 实施功能 B
- [ ] 2.3 添加错误处理

## 3. 测试
- [ ] 3.1 编写单元测试
- [ ] 3.2 编写集成测试
- [ ] 3.3 手动测试核心场景

## 4. 文档
- [ ] 4.1 更新 API 文档
- [ ] 4.2 更新用户指南
- [ ] 4.3 添加代码注释

## 5. 完成
- [ ] 5.1 代码审查
- [ ] 5.2 处理反馈
- [ ] 5.3 合并到主分支
```

**最佳实践**：
- 小型、可验证的工作项
- 按逻辑顺序排列
- 包含验证步骤（测试、工具）
- 突出显示依赖关系或可并行化的工作
- 每个任务提供用户可见的进度

### 7. 创建 design.md（有条件）

**何时创建 design.md**：
- 跨越多个系统/模块的变更
- 引入新的架构模式
- 新的外部依赖或重大数据模型变更
- 安全、性能或迁移复杂性
- 在编码前需要技术决策的模糊性

**何时跳过**：
- 简单的单模块变更
- 实现方式明显的情况
- 仅配置或文档更新

**最小化结构**：

```markdown
## 上下文
[背景、约束、利益相关者]

## 目标 / 非目标
- 目标：[...]
- 非目标：[...]

## 决策
- 决策：[是什么和为什么]
- 考虑的替代方案：[选项 + 理由]

## 风险 / 权衡
- [风险] → 缓解措施

## 迁移计划
[步骤、回滚]

## 待解决问题
- [...]
```

### 8. 验证提案

```bash
# 运行严格验证
openspec validate <change-id> --strict --no-interactive
```

**解决所有验证错误**：
- "变更必须至少有一个增量" → 检查 `specs/` 目录
- "需求必须至少有一个场景" → 添加 `#### Scenario:`
- "场景格式错误" → 确保使用 4 个 # 标题

**调试命令**：
```bash
# 检查增量解析
openspec show <change-id> --json --deltas-only

# 检查特定规范
openspec show <spec> --type spec --json
```

### 9. 完成检查清单

提案完成时应具备：
- [ ] proposal.md 清楚说明"为什么"和"是什么"
- [ ] tasks.md 包含有序的可操作任务
- [ ] 至少一个规范增量，格式正确
- [ ] design.md（如需要）记录架构决策
- [ ] 所有验证检查通过（`--strict` 模式）
- [ ] 没有模糊或未解决的问题

### 10. 展示提案

创建简洁的摘要：

```text
✓ 提案已创建

变更 ID：<change-id>
受影响的功能：<list>

主要变更：
- 变更点 1
- 变更点 2

文件创建：
- openspec/changes/<id>/proposal.md
- openspec/changes/<id>/tasks.md
- openspec/changes/<id>/design.md (如有)
- openspec/changes/<id>/specs/...

验证状态：✓ 通过

下一步：审查提案，批准后使用 /openspec:apply <id> 实施
```

## 参考命令

```bash
# 探索现有工作
openspec list                    # 活跃的变更
openspec list --specs            # 现有规范
openspec show <id>               # 查看详情

# 验证
openspec validate <id> --strict --no-interactive

# 搜索现有需求
rg -n "Requirement:|Scenario:" openspec/specs
rg -n "^#|Requirement:" openspec/changes

# 探索代码库
rg <keyword>
ls <directory>
```

## 常见错误

**场景格式错误**：
```markdown
# 错误 ❌
- **Scenario: 名称**
**Scenario**: 名称
### Scenario: 名称

# 正确 ✓
#### Scenario: 名称
```

**MODIFIED 需求不完整**：
- 必须包含完整的更新后需求
- 不要只添加新内容，忽略现有内容
- 从现有规范复制，然后编辑

**功能命名不清**：
- 使用动词-名词：`user-auth` 而非 `authentication`
- 保持聚焦：一个功能一个目的
- 如需要"且"就拆分

## 最佳实践

1. **提前澄清**：在搭建前提出问题
2. **保持简单**：默认 <100 行代码变更
3. **搜索优先**：检查现有需求和模式
4. **完整增量**：MODIFIED 需求包含全部内容
5. **场景驱动**：每个需求至少一个具体场景
6. **先验证**：在分享前修复所有问题
