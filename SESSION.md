# SESSION.md

## 当前目标

- 把 OpenClaw 的日常使用（写作/材料收集/学技能）沉淀成可复用的规范与模板；并持续接入新能力（如 MCP）。

## 关键决策（含理由）

- 采用固定的“任务汇报排版”模板（`docs/report-template.md` + `templates/REPORT.template.md`）。
  - 理由：减少沟通成本；wik 可以快速扫读；便于长期复盘。
- 复杂任务启用 `SESSION.md` 机制。
  - 理由：防止长会话压缩导致丢掉“为什么这么做/否决过什么”。

## 明确否决的方案（含理由）

- 不依赖某个特定 UI 指令（例如某个客户端的 `/compact`）作为唯一记忆方案。
  - 理由：不同运行环境/通道不一定支持；文件化规范更稳定可复用。

## 当前进度 / 下一步

- 已完成：
  - 建立工作流规范与模板（见 `docs/agent-workflow.md`、`templates/`）。
  - 接入 `wexin-read-mcp` 作为公众号阅读能力。
  - 增加网关鉴权限速配置与加固文档（见 `docs/security-hardening.md`）。
  - 补全 `USER.md`（wik / Asia-Shanghai）与 `IDENTITY.md`（助手默认行为）。
  - 新增汇报模板（见 `docs/report-template.md`、`templates/REPORT.template.md`）。

- 下一步（待 wik 选）：
  1) 处理剩余安全告警：收紧飞书 doc 工具权限（避免自动授权）。
  2) 把 `SESSION.md` 机制写成更强的 checklist（何时必须建/更新），并加入示例。
