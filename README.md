# Face-Learning — E｜MLP 分類器

以固定 fitcnet baseline 對 PCA/LDA 特徵訓練分類器，記錄標準化、seed、訓練狀態與參數數。

## 六人共用的固定規格

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

完整規格與操作圖解：https://face-learning-lab-heetah-20261015.divine-siren-9327.chatgpt.site/docs/PROJECT_SPECIFICATIONS.md


## 本角色的工作順序

從 A/F 拿 train_dataset.mat 與 fold_manifest.csv，呼叫 B/C 的 reducer。fitcnet 固定單層 10-unit ReLU、Standardize=true、Lambda=0、IterationLimit=1000，seed Twister 2026。逐折產生 PCA→MLP 與 LDA→MLP validation 預測。

1. 先讀本分支 AGENTS.md 的 AI 協作背景與操作步驟。
2. 在 MATLAB 記錄 version -release、ver 與本角色函式的 which -all。
3. 先跑 synthetic tests，再讀私人 train_dataset.mat 和 fold_manifest.csv。
4. 用同一 outer folds 執行，整理本角色 artifacts，和配對角色互相 review。
5. 把已驗證的方法和 F 的結果放進簡報與書面報告，兩份使用一致文字和數字。

## 配對合作

D/E 共用每折的 PCA/LDA features、資料列、label order、positive class、score columns 和衡量方式。比較 Gaussian Naive Bayes 與固定 MLP baseline，不只比較 training accuracy。一起給 F 四條 pipeline 的私有 oof_predictions.csv 逐筆列和 classifier_summary.csv。

## 本角色交付

matlab/fitMLP.m；matlab/predictMLP.m；synthetic output/score tests；private classifier_summary.csv、私有 oof_predictions.csv 的兩條 pipeline rows；MLP 網路示意與簡報、書面報告結果。

## Git 操作

    git clone https://github.com/heetah/Face-Learning.git
    cd Face-Learning
    git switch --track origin/feature/e-mlp
    git status --short
    git diff --check
    git add README.md AGENTS.md matlab/fitMLP.m matlab/predictMLP.m tests/testMLP.m
    git commit -m "E: implement fixed MLP baseline"
    git push -u origin feature/e-mlp

公開 repo 不放 face images、MAT 檔、逐筆 predictions、原始檔名、私人路徑、password 或 token。完成後開 Pull Request 到 main，請其他組員 review。

## 官方參考

https://www.mathworks.com/help/stats/fitcnet.html
