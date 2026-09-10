#!/usr/bin/env python3
"""Day 3 的度量腳本:從 graph.json 走到「該先讀哪三個檔」。

用法: day03-metrics.py <graphify-out/graph.json>
歸屬規則與 graph-metrics.py 相同(路徑中的 Sources/ 或 Tests/ 之後一段)。
"""
import json, sys, collections

GENERATED = ('.pb.swift', '.grpc.swift', '+Generated', '/Resources/')

def target_of(path):
    if not path: return None
    parts = path.split('/')
    for i, seg in enumerate(parts[:-1]):
        if seg in ('Sources', 'Tests') and i + 1 <= len(parts) - 2:
            return parts[i + 1]
    return None

g = json.load(open(sys.argv[1]))
nodes, links = g['nodes'], g['links']
src   = {n['id']: n.get('source_file') for n in nodes}
owner = {i: target_of(p) for i, p in src.items()}
comm  = {n['id']: n.get('community') for n in nodes}
label = {n['id']: n['label'] for n in nodes}

deg = collections.Counter()
for l in links:
    deg[l['source']] += 1; deg[l['target']] += 1

file_deg = collections.Counter(); file_nodes = collections.Counter()
for i, d in deg.items():
    f = src.get(i)
    if f: file_deg[f] += d; file_nodes[f] += 1
for i in src:
    if src[i] and i not in deg: file_nodes[src[i]] += 1

def is_test(f): return f.startswith('Tests/') or '/Tests/' in f
def is_gen(f):  return any(k in f for k in GENERATED)

print('== 檔案總度數 Top 6(未過濾)')
for f, d in file_deg.most_common(6):
    print(f'  {d:5d} {file_nodes[f]:5d}  {f}')

print('== 過濾 Tests/ 與產生碼之後 Top 3')
kept = [(f, d) for f, d in file_deg.most_common() if not is_test(f) and not is_gen(f)]
for f, d in kept[:3]:
    print(f'  {d:5d} {file_nodes[f]:5d}  {f}')

print('== 跨 target 邊數 Top 4(依檔案)')
cross = collections.Counter()
for l in links:
    a, b = owner.get(l['source']), owner.get(l['target'])
    if a and b and a != b:
        for end in (l['source'], l['target']):
            if src.get(end): cross[src[end]] += 1
for f, c in cross.most_common(4):
    print(f'  {c:5d}  {f}')
print('  -- 扣掉測試後的第一名:')
for f, c in cross.most_common():
    if not is_test(f): print(f'  {c:5d}  {f}'); break

print('== 最大的六個群集')
members = collections.defaultdict(list)
for i, c in comm.items(): members[c].append(i)
rows = []
for c, ids in members.items():
    tg = collections.Counter(owner[i] for i in ids if owner.get(i))
    dom, purity = ('—', 0.0)
    if tg:
        dom, n = tg.most_common(1)[0]
        purity = n / sum(tg.values()) * 100
    top = [label[i] for i, _ in sorted(((i, deg[i]) for i in ids), key=lambda x: -x[1])[:3]]
    rows.append((len(ids), c, dom, purity, top))
for size, c, dom, purity, top in sorted(rows, reverse=True)[:6]:
    print(f'  群集 {c:<4} 節點 {size:4d}  {dom:<28} 純度 {purity:5.1f}%  {", ".join(top)}')

tsize = collections.Counter(t for t in owner.values() if t)
t, n = tsize.most_common(1)[0]
print(f'== 最大 target: {t} {n} 節點,佔全圖 {n/len(nodes)*100:.0f}%')
