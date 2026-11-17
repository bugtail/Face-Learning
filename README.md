# Face Learning Project

This repository is the team's MATLAB implementation workspace for the face-image classification project. The goal is to compare four pipelines under the same data split and evaluation rules:

- PCA → Bayes
- LDA → Bayes
- PCA → MLP
- LDA → MLP

The public FaceLab site is a teaching demo. The course results come from the MATLAB experiments in this repository.

## Current implementation

| Stage | MATLAB entry points | Output |
|---|---|---|
| A · Prepare data | [`inspectTrainingData`](matlab/inspectTrainingData.m), [`prepareData`](matlab/prepareData.m) | Checks the 200 training PNGs and creates a private `train_dataset.mat` with `X` (200 × 1,024), `y`, `sampleID`, `groupID`, and `preprocessSpec`. |
| F · Create and read folds | [`runFStageOne`](matlab/runFStageOne.m), [`loadFoldData`](matlab/loadFoldData.m) | Creates `fold_manifest.csv`, `fold_counts.csv`, and `fold_config.json`. Loads 160 training rows and 40 validation rows for a selected fold. The two images in a filename group stay in the same fold. |
| B · PCA | [`fitPCA`](matlab/fitPCA.m), [`transformPCA`](matlab/transformPCA.m) | Learns projection directions from the training rows. The retained dimension is the numerical rank of the centered training matrix. |
| C · Fisher LDA | [`fitLDA`](matlab/fitLDA.m), [`transformLDA`](matlab/transformLDA.m) | Uses the training rows and labels to learn a projection to one feature. |

Bayes (D), MLP (E), and the end-to-end evaluation of all four pipelines are pending. F's current entry point prepares the folds. The independent 100-image course test set is reserved for final evaluation after the methods and settings are fixed.

See the [data contract](docs/DATA_CONTRACT.md), [project specifications](docs/PROJECT_SPECIFICATIONS.md), and [team working rules](docs/TEAM_WORKING_RULES.md) for the shared interface and evaluation protocol.

## Start here

1. Read the `AGENTS.md` on your assigned branch for role-specific context and AI-collaboration guidance.
2. Read the [team working rules](docs/TEAM_WORKING_RULES.md) and [AI collaboration guide](docs/AI_COLLABORATION_GUIDE.md).
3. Keep images, MAT packages, source filename maps, fold files, private paths, and credentials in approved private locations outside this repository.
4. Test with synthetic matrices first. For each fold, fit PCA or LDA on the training rows and use the fitted model to transform both the training and validation rows. Use the same folds for all four pipelines.
5. Commit only your assigned files on your task branch and open a pull request to your assigned team branch for review. See the [Git workflow](docs/TEAM_WORKING_RULES.md#git-workflow) for integration into `main`.

## Branches

| Member | Branch | Focus |
|---|---|---|
| A | `feature/a-data-loader` | Dataset checks and shared input contract |
| B | `feature/b-pca` | PCA fit/transform |
| C | `feature/c-lda` | Fisher LDA fit/transform |
| D | `feature/d-bayes` | Bayes classifier |
| E | `feature/e-mlp` | MLP classifier |
| F | `feature/f-cv-runner` | Fold manifest, integration, and evaluation |

Each role branch has its own top-level `AGENTS.md`. Branch names are part of the shared workflow; coordinate before renaming them.

## Run the synthetic checks in MATLAB

Set MATLAB's **Current Folder** to the repository root. In a remote MATLAB session, keep the `matlab/`, `matlab/tests/`, and `tests/` directory structure when transferring the code.

```matlab
addpath(fullfile(pwd, 'matlab'))
testPoolFaceImage
assertSuccess(runtests('tests/testPCA.m'))
assertSuccess(runtests('tests/testFoldManifest.m'))
run('matlab/tests/test_LDA_math.m')
run('matlab/tests/test_LDA_synthetic.m')
```

## Prepare the shared training folds

1. **A** opens `matlab/prepareData.m` in MATLAB and clicks **Run**. Select the folder containing the 200 PNGs, then select a private output folder. Share `train_dataset.mat` with the team through the approved private location. Keep `data_manifest.csv`, which contains the source filenames, in A's private storage.
2. **F** runs `runFStageOne(matPath)` with the path to that private MAT file. It runs the synthetic fold tests and saves the three fold files alongside the MAT file. Use the same `fold_manifest.csv` for every pipeline.
3. **B–E** use `[trainData, validationData] = loadFoldData(matPath, manifestPath, fold)` for each fold from 1 to 5. Fit PCA with `trainData.X` or LDA with `trainData.X` and `trainData.y`. Apply the returned model to `trainData.X` and `validationData.X` separately using the matching `transform` function.

## Git quick start

```powershell
git clone https://github.com/heetah/Face-Learning.git
cd Face-Learning
git switch --track origin/feature/a-data-loader
```

The last command is an example for member A. Replace it with your assigned branch from the table above; `--track` creates a local branch that follows the existing GitHub branch. The A–F detail pages on the website give each role its exact command.

For later sessions, switch to your assigned branch and run `git pull --ff-only` before editing. Before sharing work, inspect `git status --short` and `git diff --check`, stage only named files, commit, then run `git push` to update its upstream branch. Do not force-push shared work.

The website's A–F pages include step-by-step MATLAB and Git commands: <https://face-learning-lab-heetah-20261015.divine-siren-9327.chatgpt.site/#team-workflow>.

