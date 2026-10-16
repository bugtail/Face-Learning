# Face-Learning — A｜資料整理與共用介面

整理原始影像並產生全組唯一的 train_dataset.mat；A 不切 fold、不 fit PCA/LDA、不訓練 classifier。

## 六人共用的固定規格

課程要求 200 張訓練圖（男女各 100）做五折交叉驗證，並另以獨立的 100 張正式測試圖（男女各 50）做最終評估；測試集必須等程式與設定鎖定後才使用。目前在已提供位置尚未找到測試集，不能以 validation fold 代替。

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

A 負責製作私人訓練資料與正式測試資料；測試集到手後先核對並封存，待所有程式與設定鎖定，再交 F 評估。

從私有 PNG 資料夾讀檔，核對 200 張、兩類各 100 張、640×640 RGB 與每群組兩張。依共同前處理產生 X/y/sampleID/groupID/preprocessSpec，私下交給 B–F。交付 prepareData.m、DATA_CONTRACT.md、合成測試和不含檔名的品質摘要。

1. 先讀本分支 AGENTS.md 的 AI 協作背景與操作步驟。
2. 在 MATLAB 記錄 version -release、ver 與本角色函式的 which -all。
3. 先跑 synthetic tests，再讀私人 train_dataset.mat 和 fold_manifest.csv。
4. 用同一 outer folds 執行，整理本角色 artifacts，和配對角色互相 review。
5. 把已驗證的方法和 F 的結果放進簡報與書面報告，兩份使用一致文字和數字。

## 配對合作

和 F 一起核對標籤/群組意義、樣本數與每折資料表；A 校對資料來源與前處理文字，F 校對切分與指標。兩人共同檢查簡報和書面報告使用相同名詞、圖表標籤與數據說法。

## 本角色交付

matlab/prepareData.m；docs/DATA_CONTRACT.md；synthetic tests；private train_dataset.mat、data_manifest.csv、data_quality_summary.csv。

## Git 操作

    git clone https://github.com/heetah/Face-Learning.git
    cd Face-Learning
    git switch --track origin/feature/a-data-loader
    git status --short
    git diff --check
    git add README.md AGENTS.md matlab/prepareData.m docs/DATA_CONTRACT.md tests/testPrepareData.m
    git commit -m "A: prepare shared dataset"
    git push -u origin feature/a-data-loader

公開 repo 不放 face images、MAT 檔、逐筆 predictions、原始檔名、私人路徑、password 或 token。完成後開 Pull Request 到 main，請其他組員 review。

## 官方參考

https://www.mathworks.com/help/matlab/ref/imread.html
