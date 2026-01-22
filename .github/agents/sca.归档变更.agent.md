---
description: 归档已完成的 OpenSpec 变更，将其移至 archive/ 并更新规范
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

## 大纲

### 1. 确定要归档的变更 ID

**从用户输入确定**：
- 如果用户输入包含特定的变更 ID（例如在 `<ChangeId>` 块中），修剪空格后使用该值
- 如果对话模糊地引用了某个变更（例如通过标题或摘要），继续下一步

**通过 CLI 确认**：
- 运行 `openspec list` 显示所有活跃的变更
- 如果有多个变更，列出候选项并请求用户确认
- 如果没有变更 ID，询问用户："请提供要归档的变更 ID"

**停止条件**：
- 如果无法识别单个变更 ID，停止并告知用户无法继续

### 2. 验证变更状态

```bash
# 验证变更存在
openspec list
openspec show <id>
```

**检查项**：
- [ ] 变更存在于 `openspec/changes/<id>/`
- [ ] 变更未已归档（不在 `changes/archive/` 中）
- [ ] 变更已准备好归档（所有任务完成）

**如果验证失败**：
- **变更不存在**：显示 `openspec list` 输出，让用户选择正确的 ID
- **已归档**：告知用户该变更已在 archive/ 中
- **任务未完成**：警告用户 tasks.md 中有未完成的任务，询问是否仍要继续

### 3. 检查任务完成状态

读取 `openspec/changes/<id>/tasks.md`：
- 统计总任务数：所有 `- [ ]` 和 `- [x]` 行
- 统计已完成任务：所有 `- [x]` 行
- 统计未完成任务：所有 `- [ ]` 行

显示状态：
```text
任务状态检查：
- 总计：N 个任务
- 已完成：M 个任务
- 待完成：K 个任务
```

**如果有未完成任务**：
- 显示未完成任务的数量
- 询问："此变更有 K 个未完成任务。你确定要归档吗？(是/否)"
- 等待用户响应
- 如果用户说"否"或"等待"，停止归档
- 如果用户说"是"或"继续"，继续归档

**如果所有任务完成**：
- 显示 "✓ 所有任务已完成"
- 自动继续归档流程

### 4. 执行归档

```bash
# 运行归档命令（使用 --yes 跳过交互提示）
openspec archive <id> --yes
```

**使用 --skip-specs 的情况**：
- **仅当**这是纯工具变更（如更新 OpenSpec CLI 本身）
- 对于功能变更，**不要**使用 --skip-specs

**监控输出**：
- 检查变更是否成功移动到 `changes/archive/YYYY-MM-DD-<id>/`
- 检查目标规范是否已更新（如果适用）
- 记录任何错误或警告

### 5. 验证归档结果

```bash
# 验证项目状态
openspec validate --strict --no-interactive
```

**检查归档**：
- [ ] 变更目录移至 `changes/archive/YYYY-MM-DD-<id>/`
- [ ] 原始 `changes/<id>/` 目录已删除
- [ ] 相关规范已更新（检查 `openspec/specs/<capability>/spec.md`）
- [ ] 验证通过，无错误

**如果发现问题**：
```bash
# 检查特定变更
openspec show <id>

# 查看刷新的规范
openspec list --specs
openspec show <spec> --type spec
```

### 6. 审查规范更新

对于每个受影响的功能：

**读取更新后的规范**：
- 检查 `openspec/specs/<capability>/spec.md`
- 确认增量已正确合并：
  - ADDED 需求已添加
  - MODIFIED 需求已更新
  - REMOVED 需求已删除
  - RENAMED 需求已重命名

**验证完整性**：
- 所有需求仍有场景
- 格式仍然正确（`#### Scenario:`）
- 没有重复的需求

### 7. 生成归档报告

创建摘要：

```text
✓ 归档完成

变更 ID：<id>
归档位置：changes/archive/YYYY-MM-DD-<id>/

任务完成度：M/N (100%)

更新的规范：
- specs/<capability1>/spec.md
- specs/<capability2>/spec.md

变更摘要：
- [从 proposal.md 提取的主要变更]

验证状态：✓ 通过
```

### 8. 清理和建议

**可选的后续步骤**：
- 提示创建 Git commit：`git add openspec/ && git commit -m "Archive <id>"`
- 建议清理任何相关的功能分支
- 如果是重大功能，建议更新项目文档

**下一步行动**：
- 运行 `openspec list` 查看剩余的活跃变更
- 运行 `openspec list --specs` 查看更新后的规范列表

## 参考命令

```bash
# 查看活跃的变更
openspec list

# 查看特定变更
openspec show <id>

# 归档变更
openspec archive <id> --yes              # 标准归档
openspec archive <id> --skip-specs --yes # 仅工具变更

# 验证结果
openspec validate --strict --no-interactive

# 查看更新的规范
openspec list --specs
openspec show <spec> --type spec
```

## 错误处理

**变更不存在**：
```text
❌ 错误：找不到变更 '<id>'

活跃的变更：
- change-1: 描述 1
- change-2: 描述 2

请选择一个有效的变更 ID。
```

**归档命令失败**：
- 显示完整的错误消息
- 检查是否有文件权限问题
- 验证 OpenSpec CLI 是否正确安装
- 提示用户手动检查 `changes/<id>/` 目录

**验证失败**：
```text
⚠️ 警告：归档后验证失败

错误：
- [具体错误消息]

建议操作：
1. 检查 openspec/specs/ 中的规范文件
2. 运行 openspec show <spec> 查看详情
3. 如需要，手动修复格式问题
```

**规范更新问题**：
- 比较归档前后的规范文件
- 检查是否有合并冲突
- 确认增量操作（ADDED/MODIFIED/REMOVED）正确应用

## 边缘情况

**部分完成的任务**：
- 警告用户有未完成的任务
- 要求明确确认
- 记录未完成的任务以供将来参考

**多个同名功能**：
- 如果规范更新影响多个同名文件
- 列出所有受影响的文件
- 让用户确认每个更新都符合预期

**工具变更 vs 功能变更**：
- 工具变更：使用 `--skip-specs`（不更新 specs/）
- 功能变更：正常归档（更新 specs/）
- 如不确定，询问用户

## 最佳实践

1. **确认优先**：在归档前始终确认正确的变更 ID
2. **任务检查**：警告未完成的任务
3. **验证必需**：归档后始终运行严格验证
4. **审查更新**：检查规范文件是否正确更新
5. **清晰报告**：提供详细的归档摘要
6. **建议后续**：提示 Git 提交和其他清理步骤
