# Face-Learning — B｜PCA 降維

實作每折獨立 fit 的 PCA 模型與 transform，和 C 對齊降維輸出，讓 D/E 能直接接分類器。

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

從 A 拿 train_dataset.mat、從 F 拿 fold_manifest.csv。每個 fold 只用 Xtrain 計算平均和 PCA 方向，以中心化矩陣 numerical rank 決定 q；train/validation 共用同一模型。和 C 共同驗收維度及 reduction_summary.csv。

1. 先讀本分支 AGENTS.md 的 AI 協作背景與操作步驟。
2. 在 MATLAB 記錄 version -release、ver 與本角色函式的 which -all。
3. 先跑 synthetic tests，再讀私人 train_dataset.mat 和 fold_manifest.csv。
4. 用同一 outer folds 執行，整理本角色 artifacts，和配對角色互相 review。
5. 把已驗證的方法和 F 的結果放進簡報與書面報告，兩份使用一致文字和數字。

## 配對合作

B/C 使用同一 X、同一 fold manifest、相同 fit/transform 契約；比較 PCA 無監督投影與 LDA 使用 y 的判別軸。共同交 reduction_summary.csv（每個 reducer/fold 一列：nTrain、nValid、inputD、outputQ、rank、fit/transform 秒數）。D/E 透過同一 reducer API 接線。

## 本角色交付

matlab/fitPCA.m；matlab/transformPCA.m；synthetic PCA tests；private reduction_summary.csv；報告中的 PCA 方法與 fold 結果。

## Git 操作

    git clone https://github.com/heetah/Face-Learning.git
    cd Face-Learning
    git switch --track origin/feature/b-pca
    git status --short
    git diff --check
    git add README.md AGENTS.md matlab/fitPCA.m matlab/transformPCA.m tests/testPCA.m
    git commit -m "B: implement PCA fit and transform"
    git push -u origin feature/b-pca

公開 repo 不放 face images、MAT 檔、逐筆 predictions、原始檔名、私人路徑、password 或 token。完成後開 Pull Request 到 main，請其他組員 review。

## 官方參考

https://www.mathworks.com/help/stats/pca.html；https://www.mathworks.com/help/matlab/ref/rank.html
