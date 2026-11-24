# sre-lab

從零打造一套 SRE 實作環境：服務 → 容器化 → CI → IaC → 可觀測性 → GitOps，全部使用免費工具在本機完成。

## Roadmap

- [x] Stage 1：FastAPI 服務（`/health`、`/metrics`、可注入故障的 `/work`）
- [ ] Stage 2：Docker 化（multi-stage、非 root）
- [ ] Stage 3：CI（GitHub Actions → GHCR）
- [ ] Stage 4：Terraform 建立 kind 叢集並部署
- [ ] Stage 5：Prometheus / Grafana 監控、SLO 與燃燒率告警
- [ ] Stage 6：Helm + ArgoCD GitOps、HPA
- [ ] 壓測、故障演練與 postmortem

## 本機執行

```bash
uv venv --python 3.12 && source .venv/bin/activate
uv pip install -r app/requirements.txt -r requirements-dev.txt
python -m pytest -q
uvicorn app.main:app --reload
```

## 端點

| 端點 | 說明 |
|---|---|
| `/` | 回傳版本資訊 |
| `/health` | 健康檢查 |
| `/metrics` | Prometheus 指標 |
| `/work` | 模擬工作；以 `ERROR_RATE`、`MAX_DELAY` 環境變數注入錯誤與延遲，供 SLO 告警與故障演練使用 |

## 環境建置踩雷紀錄

- 在 PowerShell 執行 Linux 指令失敗 → 需先進入 WSL（Ubuntu）
- `ssh-keygen` 誤輸入檔名導致金鑰路徑錯誤 → 預設路徑直接按 Enter
- kind 下載網址版本號未替換，下載到 404 頁面 → 改用 GitHub API 自動取得最新版本
- ruff 檢查出 import 排序問題（I001）→ `ruff check --fix` 自動修正
