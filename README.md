# Face Learning Project

This repository is the team's MATLAB implementation workspace for the face-image classification project. The goal is to compare four pipelines under the same data split and evaluation rules:

- PCA → Bayes
- LDA → Bayes
- PCA → MLP
- LDA → MLP

The public FaceLab site explains the project and currently demonstrates one browser-local PCA + Gaussian Naive Bayes baseline. That demonstration is not a MATLAB result, and the other three pipelines must not be described as trained until their implementations and evaluations exist.

## Start here

1. Read the `AGENTS.md` on your assigned branch for role-specific context and AI-collaboration guidance.
2. Read the team's initial working rules on the website, then confirm or revise them together.
3. Keep training images, official test images, private file paths, credentials, and identifying filename lists out of this repository.
4. Implement and test with synthetic matrices first. Use only the training portion of each fold to fit preprocessing, dimensionality reduction, classifiers, and tuning choices.
5. Commit only your assigned files on your own branch and open a pull request to `main` for review.

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

## Current project status

The website contains a Python-trained PCA + Gaussian Naive Bayes teaching baseline. The formal course implementation and fair comparison of all four combinations are still team work. MATLAB release, toolbox availability, label provenance, data grouping, Bayes assumptions, feature preprocessing, and tuning rules must be verified from course materials and the actual data before being fixed.

## MATLAB and Git quick start

```powershell
git clone https://github.com/heetah/Face-Learning.git
cd face-learning
git switch feature/<your-role>
```

For each work session, update `main`, then bring its changes into your branch. Before sharing work, inspect `git status --short` and `git diff --check`, stage only named files, commit, and push your own branch. Do not force-push shared work.

The website's A–F pages include step-by-step MATLAB and Git commands: <https://face-learning-lab-heetah-20261015.divine-siren-9327.chatgpt.site/#team-workflow>.
