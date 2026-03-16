# Humanizer-zh (for wik)

Use this as an editing rubric to make drafts (self-media + technical docs) more natural, professional, and concise.

## Target voice

- Professional, not pretentious
- Concise and calm
- Prefer concrete claims over "big words"
- Allow mild opinion when appropriate (self-media), stay factual in docs

## Two-pass workflow

### Pass 1: De-AI patterns (structure + wording)

Remove or rewrite these patterns:

- Overstated significance: "标志着/见证/体现/里程碑/不可磨灭"
- Promotional language: "令人叹为观止/开创性/充满活力/无缝体验"
- Vague attribution: "专家认为/行业报告显示" (replace with specific source or remove)
- Formulaic sections: "挑战与展望" (replace with concrete constraints + next steps)
- Copula avoidance: use "是/有/做" instead of "作为/充当/拥有"
- Forced triplets: change 3-item lists into 2 items or a single sharper item
- Excess connectors: reduce "此外/同时/因此"; use paragraph breaks instead

### Pass 2: Add human signal (without fluff)

- Add 1-2 concrete details: numbers, time, location, constraint, tradeoff
- Vary sentence length; allow a short punch line sentence per paragraph
- Self-media: add one personal stance ("我更倾向..."), but keep it bounded
- Tech docs: add "why" once, then instructions + edge cases

## Copy-paste prompt (rewrite)

Paste this into chat with your draft:

"""
你是我的中文编辑。目标：专业但不装，简洁冷静。

要求：
1) 保留原意，不编造事实；不确定的地方用【待补充】标注。
2) 删除宣传腔、夸大意义、空泛归因；把抽象句改成具体句。
3) 句子更短更直，减少连接词；能用“是/有/做”就别用“作为/充当”。
4) 自媒体文章允许有轻度观点，但不下结论式口号；技术文档保持可操作性。

输出：
- 改写后的正文
- 变更清单（列出你删掉/替换的 AI 痕迹类型）
"""
