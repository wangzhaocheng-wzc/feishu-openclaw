# 共享资产（shared/）规范（可复用）

目的：当一个 OpenClaw 实例下有多个 Agent/多个 workspace 时，避免“复制粘贴脚本与配置”，用共享目录统一维护。

## 1) shared/ 放什么

- 可复用脚本：上传、校验、批处理、辅助工具
- 可复用模板：SESSION/REPORT/DELIVERABLE 等
- 可复用规范文档：工作流、安全、配置变更流程

禁止放：

- token、密钥、个人隐私
- 运行时状态目录（例如 `~/.openclaw/`）

## 2) 推荐目录结构

- `shared/scripts/`
- `shared/templates/`
- `shared/docs/`

当前仓库已同步：

- 规范文档：`shared/docs/*.md`
- 模板：`shared/templates/*.md`

## 3) 多 Agent 复用方式

如果每个 Agent 有独立 workspace：

- 把仓库里的 `shared/` 用符号链接挂到各个 workspace 内部，名称也叫 `shared`。
- 提供的脚本：`shared/scripts/link-shared-into-agent.sh`

示例：

```bash
shared/scripts/link-shared-into-agent.sh /path/to/agent/workspace
```

## 4) 引用策略（建议）

- 对外输出（给 wik 的交付物/规范）：优先引用仓库根目录的 `docs/`、`templates/`（阅读路径更直观）。
- 对内复用（多 Agent/多 workspace）：优先从 `shared/` 读取同名文档/模板。

> 约定：`shared/` 与根目录的 `docs/`、`templates/` 保持内容一致（shared 为“共享层镜像”）。

## 5) 变更策略

- shared/ 里的东西必须可复用、可验证。
- 任何修改都要配最小验证方式（命令/用例），并用中文 commit。
