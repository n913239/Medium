# graph-metrics —— 從 graphify 的 `graph.json` 算度量

兩支純標準庫的腳本,把知識圖的 `graph.json` 換成可以核對的數字。
2026 iThome 鐵人賽 Day 2、Day 3 的每一張表都由它們產生。

```bash
# Day 2:規模、target 歸屬、群集純度、連接度 vs method 佔比
python3 graph-metrics.py <repo>/graphify-out/graph.json [...]

# Day 3:檔案層級度數排行、過濾後的閱讀清單、跨 target 樞紐、群集表
python3 day03-metrics.py <repo>/graphify-out/graph.json
```

## 歸屬規則(讓你可以自己重算)

節點的 `source_file` 路徑中若出現 `Sources/` 或 `Tests/`
(含 `vminitd/Sources/X/` 這種巢狀),取其後一段當作 target;其餘視為無法歸屬。

**純度以「群集內可歸屬的節點數」為分母**,不是全部節點 ——
這兩種算法會差很多,而百分比不會告訴你它用的是哪一種。

## 過濾規則(`day03-metrics.py`)

- 丟掉 `Tests/` 底下的:測試反映的是驗證方式,不是設計
- 丟掉產生碼:`.pb.swift`、`.grpc.swift`、`+Generated`、`/Resources/`

## 前提

輸入是 graphify(PyPI 套件名 `graphifyy`)產生的 `graph.json`。
文章裡的數字出自 **0.9.22**,標的是 `apple/container` @ `d6de5694`,
語意抽取一律跳過(純 AST,0 tokens)。

同一份圖用不同版本的工具重建,節點與邊會相同,但**共用符號的 `source_file`
歸屬可能改變** —— 所以引用數字時要同時記下 commit 與工具版本。
