# OpenClaw 安全加固清单（可复用）

这份清单把常见的“立刻能落地”的加固项写成可复制配置。

## 1) 网关鉴权：增加暴力破解限速

适用场景：`gateway.bind` 不是 loopback（例如 `lan`），网关对局域网可达。

在 `~/.openclaw/openclaw.json` 加入（或更新）如下字段：

```json
{
  "gateway": {
    "auth": {
      "rateLimit": {
        "maxAttempts": 10,
        "windowMs": 60000,
        "lockoutMs": 300000
      }
    }
  }
}
```

含义：

- `maxAttempts`: 在 `windowMs` 时间窗口内允许的失败次数
- `windowMs`: 统计窗口（毫秒）
- `lockoutMs`: 超限后锁定时长（毫秒）

验证方式：

- 运行 `openclaw security audit`，应不再出现 `gateway.auth_no_rate_limit` 警告。

## 2) 配置文件权限（防止 token 泄露）

建议权限：

- `~/.openclaw/openclaw.json`：`600`
- `~/.openclaw/`：`700`

验证方式：

- `ls -l ~/.openclaw/openclaw.json` 显示 `-rw-------`
- `openclaw security audit` 不再提示 world-readable。

## 3) 备注：不要把 `~/.openclaw/` 提交到仓库

该目录可能包含 token、凭据、运行状态等敏感信息。

仓库中建议 `.gitignore`：

```gitignore
.openclaw/
```
