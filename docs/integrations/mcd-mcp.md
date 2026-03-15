# McDonald's China MCP (mcp.mcd.cn)

This note captures the key integration details for the McDonald's MCP platform at https://open.mcd.cn/mcp.

## Endpoint + Auth

- Base URL: `https://mcp.mcd.cn`
- Transport: Streamable HTTP
- Auth header:

```http
Authorization: Bearer <YOUR_MCP_TOKEN>
```

- Rate limit (per token): 600 requests/minute (HTTP 429 on exceed)

## Suggested mcporter setup

Project config lives at `config/mcporter.json`.

1) Add the server (no token):

```bash
mcporter config add mcd-mcp --url https://mcp.mcd.cn --scope project
```

2) Add the auth header (token):

```bash
mcporter config add mcd-mcp --url https://mcp.mcd.cn \
  --header 'Authorization=Bearer <YOUR_MCP_TOKEN>' \
  --scope project
```

Note: this stores the token in plain text inside the config. Prefer injecting secrets via your runtime/secret manager if possible.

## First calls

Once configured, these are the typical first checks:

```bash
mcporter list mcd-mcp --schema
mcporter call mcd-mcp.time_now
```

(Exact tool names depend on the server schema; use `--schema` to discover.)
