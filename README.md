# Face-Learning — F｜五折驗證與結果整合

產生唯一的 group-stratified fold manifest，執行四條 pipeline 的共同評估並整理簡報/報告數值。

## 六人共用的固定規格

課程要求 200 張訓練圖（男女各 100）做五折交叉驗證，並另以獨立的 100 張正式測試圖（男女各 50）做最終評估。訓練資料交付包含 200 張；正式測試圖由 A 向授課端取得並單獨封存，程式與設定鎖定後再交 F 評估。不可把 validation fold 稱為正式測試結果。

流程圖可編輯原始檔和 SVG 預覽位於 assets/。

- 專題比較四條 MATLAB 管線：PCA→Gaussian Naive Bayes、PCA→MLP、Fisher LDA→Gaussian Naive Bayes、Fisher LDA→MLP。
- 目前訓練資料是 200 張 640×640 RGB PNG，man/woman 各 100 張；每類 50 個檔名群組，每組 2 張。檔名第一段是此資料集的 class tag，第二段只當 fold group key，不宣稱是真實身分。
- A 產生私人 train_dataset.mat：X 為 200×1024 double、y 為 200×1 categorical、sampleID/groupID 各 200 筆、另有 preprocessSpec。X 的每列是一張影像，欄為特徵。
- 固定前處理：RGB 先轉 double 除以 255；每張 640×640 影像切成 32×32 個 20×20×3 區塊，對每個區塊全部 RGB 值取平均；按影像網格列優先展平成 1,024 維。各角色不得另做 resize、crop 或 scaling。
- F 產生私人 fold_manifest.csv，欄位 sampleID、groupID、label、outerFold。每類的 50 組以 Twister seed 2026 分別打散，平均分到五折；每折 validation 是 40 張、每類 20 張，train 是 160 張、每類 80 張。兩張同組影像永遠在同一折。
- 四條管線讀同一份 fold manifest。每折的 PCA/LDA 和分類器都只用該折 train fit；validation 僅 transform、predict 和計分。
- PCA q = 中心化 Xtrain 的 MATLAB rank；採 rank 預設 tolerance max(size(A))*eps(norm(A))。二分類 LDA 輸出 K−1=1 維；Sw 使用 SVD Moore-Penrose 最小範數解，不加猜測的 ridge 常數。
- Bayes 固定 fitcnb normal distribution、empirical prior。MLP 固定 fitcnet 一層 10-unit ReLU，Standardize=true、Lambda=0、IterationLimit=1000；每次 fit 前重設 Twister seed 2026。
- 正類固定 woman；prediction scores 欄位依 model.ClassNames 找出。交叉驗證報告 balanced accuracy 及 fold AUC 的 mean±sample SD；AUC 先逐 fold 計算。五折結果不得稱正式 test 結果。
- 影像、train_dataset.mat、原始檔名映射、fold manifest、sample-level predictions 和私人路徑不得上傳公開 GitHub 或網站。程式、schema、synthetic tests 和審核後的 aggregate results 才能公開。
- 全員使用同一 MATLAB release；每次 run 記錄 version -release、ver、Git commit、data/spec version 和設定。簡報與書面報告用相同的方法名、設定、指標和數字。

共用規格與交付文件：[PROJECT_SPECIFICATIONS.md](docs/PROJECT_SPECIFICATIONS.md) · [DATA_CONTRACT.md](docs/DATA_CONTRACT.md) · [TEAM_WORKING_RULES.md](docs/TEAM_WORKING_RULES.md) · [AI_COLLABORATION_GUIDE.md](docs/AI_COLLABORATION_GUIDE.md)

## 本角色的工作順序

F 僅用 200 張訓練圖建立 folds；程式和設定鎖定、A 交付測試集後，再以完整訓練集重訓四條管線並評估 100 張正式測試圖。

從 A 拿 train_dataset.mat；為每個類別分別打散 50 個 groupID，平均分配到五折，輸出私人 fold_manifest.csv。所有 reducer/classifier 每折只 fit train rows。彙整逐折指標、OOF predictions 和 run_config，交給全組。

1. 先讀本分支 AGENTS.md 的 AI 協作背景與操作步驟。
2. 在 MATLAB 記錄 version -release、ver 與本角色函式的 which -all。
3. 先跑 synthetic tests，再讀私人 train_dataset.mat 和 fold_manifest.csv。
4. 用同一 outer folds 執行，整理本角色 artifacts，和配對角色互相 review。
5. 把已驗證的方法和 F 的結果放進簡報與書面報告，兩份使用一致文字和數字。

## 配對合作

和 A 對齊資料語意與固定前處理；和 B/C 核對每折 fit boundaries、q/rank 和 reducer summary；和 D/E 核對 ClassNames、score columns、predictions rows 和固定設定。F 統一結果名稱與統計定義。

## 本角色交付

matlab/createFoldManifest.m；matlab/runCV.m；synthetic fold/leakage tests；private fold_manifest.csv、oof_predictions.csv、fold_metrics.csv、summary_metrics.csv、run_config.json；核准後的報告圖表。

## 第一階段：建立全組共用 folds

真實 MAT 與三個輸出都放在核准的私人資料夾，不能放進本 repo。先在 MATLAB 將 Current Folder 切到 repo 根目錄，再執行：

```matlab
addpath('matlab');
[manifest, counts, outputPaths, testResults] = ...
    runFStageOne('D:\private\train_dataset.mat');
```

`runFStageOne` 會先跑只使用合成資料的單元測試，全部通過後才讀取私人
MAT。若只想選檔，可執行 `prepareFHandoff()`；正式交付前仍須先確認合成測試通過。

`prepareFHandoff` 會先驗證 v1.1 資料契約，再以 MATLAB
`rng(2026,'twister')` 建立唯一切分，並寫出：

- `fold_manifest.csv`：`sampleID,groupID,label,outerFold`，交給 A–E 共用。
- `fold_counts.csv`：每折 validation/train 的 sample、class 與 group 數量。
- `fold_config.json`：seed、MATLAB release/toolboxes、Git commit 與資料包 SHA-256；不記錄私人路徑。

組員在第 `k` 折使用同一份 MAT 與 manifest：

```matlab
[trainData, validationData] = loadFoldData( ...
    'D:\private\train_dataset.mat', ...
    'D:\private\fold_manifest.csv', k);
```

`loadFoldData` 會先確認 MAT 與 CSV 的 sampleID、groupID、label 逐列一致；
`trainData` 固定 160 列、`validationData` 固定 40 列。降維器與分類器只能用
`trainData` fit，`validationData` 僅能 transform/predict。

## Git 操作

    git clone https://github.com/heetah/Face-Learning.git
    cd Face-Learning
    git switch --track origin/feature/f-cv-runner
    git status --short
    git diff --check
    git add README.md AGENTS.md matlab/createFoldManifest.m matlab/runCV.m tests/testFoldManifest.m tests/testRunCV.m
    git commit -m "F: implement grouped CV and reporting"
    git push -u origin feature/f-cv-runner

公開 repo 不放 face images、MAT 檔、逐筆 predictions、原始檔名、私人路徑、password 或 token。完成後開 Pull Request 到 main，請其他組員 review。

## 官方參考

https://www.mathworks.com/help/stats/cvpartition.html
