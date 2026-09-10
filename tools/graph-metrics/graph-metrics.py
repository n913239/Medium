#!/usr/bin/env python3
"""Day 2 的度量腳本 —— 從 graphify 的 graph.json 算出文章裡的每一個百分比。

用法:
    python3 graph-metrics.py <graphify-out/graph.json> [...]

歸屬規則(通則,不做任何 repo 專屬的特別處理):
    路徑中出現 Sources/ 或 Tests/ 時(不限第一層,巢狀如 vminitd/Sources/X/ 也算),
    取其後一段作為 target;其餘一律視為「無法歸屬」。
    這是一條通則 —— 不對任何 repo 的目錄結構做特別處理。
"""
import json, sys, collections


def target_of(path):
    if not path:
        return None
    parts = path.split('/')
    for i, seg in enumerate(parts[:-1]):
        if seg in ('Sources', 'Tests') and i + 1 <= len(parts) - 2:
            return parts[i + 1]
    return None


def metrics(path):
    g = json.load(open(path))
    nodes, links = g['nodes'], g['links']
    owner = {n['id']: target_of(n.get('source_file')) for n in nodes}
    attributed = {k: v for k, v in owner.items() if v}

    # 群集純度(以群集內「可歸屬節點數」加權)
    per_comm = collections.defaultdict(collections.Counter)
    for n in nodes:
        t = owner[n['id']]
        if t:
            per_comm[n.get('community')][t] += 1
    num = den = 0
    for c, cnt in per_comm.items():
        size = sum(cnt.values())
        num += cnt.most_common(1)[0][1]
        den += size
    purity = num / den * 100 if den else 0.0

    # 邊:兩端都可歸屬時,落在同一個 target 內的比例
    inner = both = 0
    for l in links:
        a, b = owner.get(l['source']), owner.get(l['target'])
        if a and b:
            both += 1
            inner += (a == b)

    # 連接度排行 + method 邊佔比
    deg = collections.Counter()
    meth = collections.Counter()
    for l in links:
        for end in (l['source'], l['target']):
            deg[end] += 1
            if l['relation'] == 'method':
                meth[end] += 1
    label = {n['id']: n['label'] for n in nodes}

    return {
        'commit': g.get('built_at_commit'),
        'nodes': len(nodes), 'edges': len(links),
        'communities': len({n.get('community') for n in nodes}),
        'attributable': len(attributed) / len(nodes) * 100,
        'targets': len(set(attributed.values())),
        'purity': purity,
        'edges_both': both, 'edges_within': inner / both * 100 if both else 0.0,
        'top': [(label.get(i, i), d, meth[i], meth[i] / d * 100)
                for i, d in deg.most_common(6)],
    }


for p in sys.argv[1:]:
    m = metrics(p)
    print(f"=== {p}")
    print(f"  commit         {m['commit']}")
    print(f"  節點 / 邊 / 群集   {m['nodes']:,} / {m['edges']:,} / {m['communities']}")
    print(f"  可對回 target   {m['attributable']:.1f}%   (target 數 {m['targets']})")
    print(f"  群集加權純度     {m['purity']:.1f}%")
    print(f"  邊留在 target 內 {m['edges_within']:.1f}%   跨 target {100 - m['edges_within']:.1f}%"
          f"   (兩端可歸屬的邊 {m['edges_both']:,})")
    print(f"  {'節點':<28}{'總邊':>6}{'method':>8}{'佔比':>9}")
    for lab, d, mm, pct in m['top']:
        print(f"    {lab:<26}{d:>6}{mm:>8}{pct:>8.1f}%")
