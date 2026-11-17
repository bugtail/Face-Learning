# Face-Learning｜MATLAB 人臉影像分類專題

本專題以同一份分組五折交叉驗證，比較四條管線：PCA ＋ Gaussian Naive Bayes、LDA ＋ Gaussian Naive Bayes、PCA ＋ MLP、LDA ＋ MLP。正式實驗在 MATLAB 執行。[FaceLab 網站](https://face-learning-lab-heetah-20261015.divine-siren-9327.chatgpt.site/)提供課程概念與操作示範。

## 目前進度

| 角色 | 模組 | 進度與入口 |
| --- | --- | --- |
| A | 資料整理 | 已進入 `main`。[檢查訓練影像](matlab/inspectTrainingData.m)並用 [`prepareData`](matlab/prepareData.m) 將 200 張訓練圖轉為私有的 `train_dataset.mat`，特徵矩陣為 200 × 1,024。 |
| B | PCA | 已進入 `main`。[`fitPCA`](matlab/fitPCA.m) 與 [`transformPCA`](matlab/transformPCA.m) 可在各折訓練資料上擬合與投影，保留維度由中心化矩陣的數值秩決定。 |
| C | Fisher LDA | 已進入 `main`。[`fitLDA`](matlab/fitLDA.m) 與 [`transformLDA`](matlab/transformLDA.m) 將二分類資料投影到一維。 |
| D | Gaussian Naive Bayes | 已進入 `main`。[`fitBayes`](matlab/fitBayes.m)、[`predictBayes`](matlab/predictBayes.m) 和[合成測試](tests/testBayes.m)已納入。輸出標籤、類別後驗機率及 fit／predict 計時。 |
| E | MLP | 訓練、預測與合成測試已交付到 [`feature/e-mlp`](https://github.com/heetah/Face-Learning/tree/feature/e-mlp)，整合到 `main` 待完成。 |
| F | 共用五折與評估 | 建立與載入 folds 已進入 `main`。[`runFStageOne`](matlab/runFStageOne.m) 產生共用清單，[`loadFoldData`](matlab/loadFoldData.m) 載入指定折的 160 筆訓練與 40 筆驗證資料。同組影像會放在同一折。 |

四條管線的端到端評估與結果彙整待完成。獨立的 100 張正式測試圖保留到程式與設定定稿後使用。

## 快速開始

### 1. 下載 `main`

```bash
git clone --branch main https://github.com/heetah/Face-Learning.git
cd Face-Learning
```

在 MATLAB 把 **Current Folder** 設成 `Face-Learning` 根目錄。GitHub 的整合測試使用 **MATLAB R2025b**。執行 Bayes 測試或訓練時，另需 **Statistics and Machine Learning Toolbox**。

### 2. 跑合成測試

以下命令可以直接貼到 MATLAB Command Window。合成測試不需要下載課程影像或準備私有 MAT 檔。

```matlab
addpath(fullfile(pwd, 'matlab'))
testPoolFaceImage
assertSuccess(runtests('tests/testPCA.m'))
assertSuccess(runtests('tests/testFoldManifest.m'))
run('matlab/tests/test_LDA_math.m')
run('matlab/tests/test_LDA_synthetic.m')
assertSuccess(runtests('tests/testFoldReducerIntegration.m'))
```

已安裝 Statistics and Machine Learning Toolbox 時，可另外測試 Bayes：

```matlab
run('tests/testBayes.m')
```

### 3. 用團隊私有資料準備共用 folds

1. **A** 在 MATLAB 執行 `prepareData`，依提示選取直接包含 200 張 PNG 的訓練目錄及團隊核准的私有輸出位置，再透過私有管道交付 `train_dataset.mat`。
2. **F** 在 MATLAB 執行下列命令，把路徑換成收到的 MAT 檔位置。入口會先跑合成測試，再在 MAT 檔所在目錄建立 `fold_manifest.csv`、`fold_counts.csv` 和 `fold_config.json`。

   ```matlab
   matPath = 'path/to/train_dataset.mat';
   [~, ~, outputPaths] = runFStageOne(matPath);
   [trainData, validationData] = loadFoldData(matPath, outputPaths.manifest, 1);
   ```

3. **B–E** 共用 F 提供的清單，依序載入第 1 到第 5 折。使用 `fitPCA(trainData.X, trainData.y)` 或 `fitLDA(trainData.X, trainData.y)`，再用同一個 reducer 分別轉換訓練與驗證資料。分類器只讀取該折訓練資料來擬合，驗證資料用於預測和計分。

影像、MAT 資料、樣本對照表、fold 清單與逐筆預測都存放在團隊核准的私有位置。

## 團隊開發

先讀共用 [`AGENTS.md`](AGENTS.md)，依角色找到分支名稱和工作指引。從對應的團隊角色分支建立工作分支，完成後以該角色分支為 PR 目標。以 B 為例，若 `origin` 是自己的 fork，可在該 clone 裡執行：

```bash
git remote add upstream https://github.com/heetah/Face-Learning.git
git fetch upstream
git switch -c work/pca upstream/feature/b-pca
git push -u origin work/pca
```

已設定 `upstream` 時，從 `git fetch upstream` 開始。送出 PR 前確認 **Files changed** 只有本次交付的檔案。角色成果合回 `main` 時，維護者從最新 `main` 建立 `integration/*`，帶入已審查的 `matlab/` 和 `tests/` 檔案。文件、素材與儲存庫設定使用專用 PR。

- [專題規格](docs/PROJECT_SPECIFICATIONS.md)
- [資料契約](docs/DATA_CONTRACT.md)
- [團隊工作規則](docs/TEAM_WORKING_RULES.md)
- [AI 協作指引](docs/AI_COLLABORATION_GUIDE.md)
