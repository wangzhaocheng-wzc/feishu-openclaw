#!/usr/bin/env python3
"""Daily digest for InStreet.

Default focuses on 思辨大讲坛 (submolt=philosophy), but can also scan other boards.

- Reads api_key from a local secrets file (not from chat).
- Fetches posts via InStreet API.
- Prints a concise markdown digest to stdout.

This script intentionally avoids posting/liking. It is read-only.
"""

import datetime as _dt
import json
import os
import re
import sys
import urllib.parse
import urllib.request

BASE_URL = os.environ.get("INSTREET_BASE_URL", "https://instreet.coze.site").rstrip("/")
SECRETS_PATH = os.environ.get(
    "INSTREET_SECRETS_PATH",
    "/home/node/.openclaw/workspace/secrets/instreet-account.txt",
)
SUBMOLTS = [s.strip() for s in os.environ.get("INSTREET_SUBMOLTS", "philosophy").split(",") if s.strip()]


def _read_api_key(path: str) -> str:
    try:
        with open(path, "r", encoding="utf-8") as f:
            for line in f:
                if line.startswith("api_key="):
                    return line.strip().split("=", 1)[1]
    except FileNotFoundError:
        pass
    raise SystemExit(
        f"Missing api_key. Expected {path} with a line like api_key=sk_inst_..."
    )


def _api_get_json(api_key: str, path: str, params: dict) -> dict:
    qs = urllib.parse.urlencode(params)
    url = f"{BASE_URL}{path}?{qs}" if qs else f"{BASE_URL}{path}"
    req = urllib.request.Request(
        url,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Accept": "application/json",
        },
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        raw = resp.read().decode("utf-8")
    return json.loads(raw)


def _short(text: str, n: int = 140) -> str:
    if not text:
        return ""
    text = re.sub(r"\s+", " ", text).strip()
    return text if len(text) <= n else text[: n - 1] + "…"


def _post_url(post_id: str) -> str:
    return f"{BASE_URL}/post/{post_id}"


def _fmt_dt(ts: str) -> str:
    # Input looks like: 2026-03-15T23:17:37.468115+08:00
    try:
        dt = _dt.datetime.fromisoformat(ts)
        return dt.strftime("%Y-%m-%d %H:%M")
    except Exception:
        return ts


def _score(post: dict) -> float:
    # Heuristic: prioritize upvotes & discussion, fall back to hot_score.
    up = post.get("upvotes") or 0
    cm = post.get("comment_count") or 0
    hot = post.get("hot_score") or 0
    return float(up) * 2.0 + float(cm) * 0.8 + float(hot) * 0.05


def main() -> int:
    api_key = _read_api_key(SECRETS_PATH)

    # Pull enough to rank and dedupe.
    # We only have one submolt per request; merge across SUBMOLTS.
    newest_posts = []
    hot_posts = []
    for sm in SUBMOLTS:
        newest = _api_get_json(
            api_key,
            "/api/v1/posts",
            {"sort": "new", "limit": 30, "submolt": sm},
        )
        hot = _api_get_json(
            api_key,
            "/api/v1/posts",
            {"sort": "hot", "limit": 30, "submolt": sm},
        )
        newest_posts.extend(((newest.get("data", {}) or {}).get("data", []) or []))
        hot_posts.extend(((hot.get("data", {}) or {}).get("data", []) or []))

    # Build maps for easy merge.
    by_id = {}
    for p in newest_posts + hot_posts:
        pid = p.get("id")
        if pid:
            by_id[pid] = p

    # Rank for different slices.
    hot_ranked = sorted(hot_posts, key=_score, reverse=True)
    newest_ranked = sorted(newest_posts, key=lambda p: p.get("created_at") or "", reverse=True)
    discussed = sorted(by_id.values(), key=lambda p: (p.get("comment_count") or 0, _score(p)), reverse=True)

    now = _dt.datetime.now(_dt.timezone(_dt.timedelta(hours=8)))
    sm_label = ",".join(SUBMOLTS)
    title = "InStreet｜每日精选"
    if sm_label == "philosophy":
        title = "InStreet｜思辨大讲坛 每日精选"
    print(f"【{title}｜{now.strftime('%Y-%m-%d %H:%M')}（上海）】")
    print(f"来源：InStreet API（submolt={sm_label}）")
    print()

    def block(title: str, posts: list, limit: int = 5) -> None:
        print(f"【{title}】")
        if not posts:
            print("- （空）")
            print()
            return
        for i, p in enumerate(posts[:limit], 1):
            pid = p.get("id", "")
            t = p.get("title", "(无标题)")
            author = ((p.get("agent") or {}).get("username")) or "?"
            up = p.get("upvotes") or 0
            cm = p.get("comment_count") or 0
            created = _fmt_dt(p.get("created_at", ""))
            snippet = _short(p.get("content", ""), 120)
            print(f"{i}. {t}")
            print(f"- 作者：{author}｜👍 {up}｜💬 {cm}｜时间：{created}")
            print(f"- 链接：{_post_url(pid)}")
            if snippet:
                print(f"- 摘要：{snippet}")
        print()

    block("热度最高（综合）", hot_ranked, limit=5)
    block("最新发布", newest_ranked, limit=5)
    block("讨论最多（按评论数）", discussed, limit=5)

    # Note on collections: platform doc doesn't describe bookmark/favorite; be explicit.
    print("备注：当前公开 API 返回字段中未看到“收藏/收藏数”指标（skill.md 未定义 bookmark/favorite），因此本摘要以 👍点赞与 💬评论作为主要信号。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
