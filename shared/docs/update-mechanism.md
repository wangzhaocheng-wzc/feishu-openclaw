# 更新机制（可复用）

这份文档描述本仓库的“学习 -> 沉淀 -> 复用 -> 迭代”机制：你给材料，我把它变成可执行的规范/模板/脚本/配置，并通过版本化持续升级。

## 1) 学习 -> 沉淀（把资料变成可复用资产）

- 输入：公众号文章/网页/文件/代码仓库/报错日志。
- 读取：优先用工具拿到完整内容（例如公众号通过 `weixin-reader`）。
- 提炼：把经验抽象成可执行规则、清单、模板、脚本。
- 产出：落到仓库的 `docs/`、`templates/`、`scripts/`，必要时更新配置。

## 2) 过程管理（防跑偏/防失忆）

### 2.1 `SESSION.md`

适用：长任务（>30min / 多文件 / 反复试错 / 改配置）。

内容固定四块：

- 当前目标
- 关键决策（含理由）
- 明确否决的方案（含理由）
- 当前进度 / 下一步

配套：

- `docs/session-checklist.md`
- `templates/SESSION.template.md`
- `examples/session/*`

### 2.2 `memory/YYYY-MM-DD.md`

适用：每日关键决策与进度留痕。

原则：轻量记录，不粘贴巨量日志。

## 3) 输出机制（可扫读汇报）

- 规范：`docs/report-template.md`
- 模板：`templates/REPORT.template.md`

每次汇报建议包含：

- 结论/状态
- 我做了什么
- 产出与变更（文件清单）
- 验证与证据
- 风险/未决
- 下一步选项（让 wik 用数字回复）

## 4) 版本化与共享复用（多 Agent/多 workspace 一致）

### 4.1 仓库层版本化（git）

- 所有变更用中文 commit，做到可追溯。

### 4.2 共享层 `shared/`

用途：当多个 Agent/多个 workspace 共用一套脚本/模板/规范时，避免复制粘贴。

- `shared/docs/`：共享规范（镜像 `docs/`）
- `shared/templates/`：共享模板（镜像 `templates/`）
- `shared/scripts/`：共享脚本

配套：

- 共享规范：`docs/shared-assets.md`
- shared 版本：`shared/VERSION.md` + `shared/CHANGELOG.md`
- 同步脚本：`shared/scripts/sync-shared.sh`

## 5) 配置变更安全（防自毁）

- 流程规范：`docs/config-change.md`
- 护栏脚本：`scripts/config-guard.sh`

原则：先备份、再最小改动、再审计、再验证、可回滚。

## 6) 安全加固与审计

- 清单：`docs/security-hardening.md`
- 验证：`openclaw security audit`

---

## 参考目录

- `docs/`：规范与说明
- `templates/`：可复制模板
- `scripts/`：仓库级脚本
- `shared/`：共享层镜像与共享脚本
- `examples/`：示例（可复制）
