# B — PCA Dimensionality Reduction

## Project background

The team is implementing four MATLAB pipelines for face-image classification: PCA → Bayes, LDA → Bayes, PCA → MLP, and LDA → MLP. The public FaceLab site currently has only a browser-local PCA + Gaussian Naive Bayes teaching baseline trained in Python. Do not treat that model or its two-dimensional visualization setting as the course result or as an evidence-based choice of PCA rank.

The shared data convention is `X: N × D`, with images in rows and features in columns, plus aligned labels `y: N × 1`. GitHub holds source and review; MATLAB runs the formal experiments. Never commit face images, official test data, private paths, credentials, or identifying filename lists.

## Your role and ownership

Implement a fit/transform PCA module that B's collaborators and F can call consistently. Define a saved model object containing the training mean, principal directions, chosen output dimension, and any diagnostics required by the agreed interface. Do not hide fitting inside a transform call.

## Mathematical and evaluation constraints

For training data `Xtrain ∈ R^(Ntrain×D)`, the per-feature training mean is `mu ∈ R^(1×D)`. If the retained loading matrix is `Wq ∈ R^(D×q)`, then `Ztrain = (Xtrain - mu) Wq ∈ R^(Ntrain×q)`. Apply exactly the same saved `mu` and `Wq` to validation or new data: `Znew = (Xnew - mu) Wq`.

Fit `mu` and the PCA directions using only the current fold's training rows. Never recompute them from validation or official test rows. Select `q` only from an explicit course requirement or a selection procedure contained inside the outer training data. A website plot using two axes is only a visualization choice, not a justified project setting.

MathWorks documents `pca` with observations in rows and variables in columns and describes its centering behavior. Verify the behavior and returned outputs for the team's actual MATLAB release; store the values needed to reproduce the transform. If the course requires an SVD implementation or forbids a toolbox function, follow that requirement instead.

## AI collaboration guidance

When asking AI for help, include the exact function signature, `Xtrain` and output dimensions, MATLAB release, and verified course constraints. Ask for the PCA derivation and shape of every returned array before requesting code. Require a clear distinction between centering, projection, and any optional scaling. Every retained dimension or tolerance must have a stated source; otherwise leave it configurable and pending. Ask for synthetic tests covering a known low-rank matrix, row/column orientation, finite outputs, and applying one fit to both train and validation data. Verify against the official [`pca` documentation](https://www.mathworks.com/help/stats/pca.html), run MATLAB tests, and inspect the staged diff. Never send actual face images or official test data to AI.

## Work sequence

1. Get A's input contract and F's fold interface before choosing function signatures.
2. Check `version -release`, `ver`, and `which pca -all`; document availability and release-specific behavior.
3. Write down fit and transform equations, matrix dimensions, model fields, and how `q` is decided.
4. Implement fit and transform as separate operations. Keep validation and new-image transforms free of fitting code.
5. Test on synthetic matrices and one permitted training fold; confirm the model was fit only from that fold's training indices.
6. Hand D and E the output interface and hand F the fold-specific fit requirement.
7. Commit only assigned PCA source and tests on `feature/b-pca`; open a pull request to `main` and request review.

## Do not assume

- Do not set `q = 2` because the browser site shows a 2-D plot.
- Do not tune `q` on an outer validation fold or the official test set.
- Do not silently transpose `X`, recenter validation rows, or omit the training mean from the saved model.
- Do not add an undocumented numerical threshold or fallback. Explain its source and ask the group when the course materials do not specify it.
