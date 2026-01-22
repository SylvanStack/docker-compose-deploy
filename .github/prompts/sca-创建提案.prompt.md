---
description: Scaffold a new OpenSpec change and validate strictly.
---

$ARGUMENTS
<!-- OPENSPEC:START -->
**防护栏**
- 优先采用简单直接、最小化的实现，仅在明确请求或明显需要时才增加复杂性。
- 将变更严格限定在请求的结果范围内。
- 如果需要额外的 OpenSpec 约定或澄清，请参考 `openspec/AGENTS.md`（位于 `openspec/` 目录内——如果看不到，运行 `ls openspec` 或 `openspec update`）。
- 识别任何模糊或不明确的细节，并在编辑文件之前提出必要的后续问题。
- 在提案阶段不要编写任何代码。仅创建设计文档（proposal.md、tasks.md、design.md 和规范增量）。实施在批准后的应用阶段进行。

**步骤**
1. 查看 `openspec/project.md`，运行 `openspec list` 和 `openspec list --specs`，并检查相关代码或文档（例如，通过 `rg`/`ls`）以基于当前行为制定提案；记录任何需要澄清的差距。
2. 选择唯一的动词开头的 `change-id`，并在 `openspec/changes/<id>/` 下搭建 `proposal.md`、`tasks.md` 和 `design.md`（需要时）。
3. 将变更映射为具体的功能或需求，将多范围工作分解为具有明确关系和顺序的不同规范增量。
4. 当解决方案跨越多个系统、引入新模式或在提交规范之前需要权衡讨论时，在 `design.md` 中捕获架构推理。
5. 在 `changes/<id>/specs/<capability>/spec.md`（每个功能一个文件夹）中起草规范增量，使用 `## ADDED|MODIFIED|REMOVED Requirements`，每个需求至少一个 `#### Scenario:`，并在相关时交叉引用相关功能。
6. 将 `tasks.md` 起草为有序的小型、可验证的工作项列表，提供用户可见的进度，包括验证（测试、工具），并突出显示依赖关系或可并行化的工作。
7. 使用 `openspec validate <id> --strict --no-interactive` 进行验证，并在共享提案之前解决所有问题。

**参考**
- 当验证失败时，使用 `openspec show <id> --json --deltas-only` 或 `openspec show <spec> --type spec` 检查详细信息。
- 在编写新需求之前，使用 `rg -n "Requirement:|Scenario:" openspec/specs` 搜索现有需求。
- 使用 `rg <keyword>`、`ls` 或直接读取文件探索代码库，以便提案与当前实施现实保持一致。
<!-- OPENSPEC:END -->
