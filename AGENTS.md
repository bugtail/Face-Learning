# C — Fisher LDA Dimensionality Reduction

## Project background

The team is comparing four MATLAB face-image classification pipelines: PCA → Bayes, LDA → Bayes, PCA → MLP, and LDA → MLP. The public FaceLab site demonstrates only a Python-trained, browser-side PCA + Gaussian Naive Bayes baseline. It is not an LDA result. GitHub is for source review, MATLAB is the formal experiment environment, and face images and official test data must stay out of this public repository.

The shared matrix convention is `X: N × D`, one image per row and one feature per column; labels are aligned as `y: N × 1`.

## Your role and ownership

Implement Fisher LDA as separate fit and transform steps, document the derivation and its assumptions, and report degeneracy or rank issues instead of masking them. Coordinate the model fields and transformed-feature dimensions with D, E, and F.

## Derivation and dimensions

Let the training class count be `K`, class `k` have `n_k` rows and mean `mu_k ∈ R^(1×D)`, and let the overall mean be `mu ∈ R^(1×D)`. With rows as observations and columns as features:

- `Sw = Σ_k Σ_{i:y_i=k} (x_i - mu_k)^T (x_i - mu_k)`, with `Sw ∈ R^(D×D)`.
- `Sb = Σ_k n_k (mu_k - mu)^T (mu_k - mu)`, with `Sb ∈ R^(D×D)`.
- The Fisher criterion for direction `w` is `J(w) = (w^T Sb w) / (w^T Sw w)`.
- Under the required conditions, maximizing this criterion leads to a generalized eigenproblem `Sb w = lambda Sw w`.

The class means relative to the overall mean provide at most `K−1` independent between-class directions, so `rank(Sb) ≤ K−1`. For two classes, conventional Fisher LDA therefore has at most one discriminant direction. The exact selected rank and normalization must match the course specification and be documented.

High-dimensional image features with few training rows can make `Sw` rank deficient. Do not call `inv(Sw)` as if invertibility were guaranteed, and do not silently add an arbitrary epsilon. Report dimensions, numerical rank/conditioning diagnostics, and the course-approved handling. If no handling is specified, present options and assumptions to the group before implementing one.

For each fold, estimate class means, `Sw`, `Sb`, and directions from that fold's training rows only. Use the saved training mean and direction to transform both training and validation rows. Never fit LDA using validation or official test labels.

## AI collaboration guidance

Provide AI with the course's exact LDA definition and the `N × D` convention. Ask it to derive each matrix from the objective and annotate dimensions, rank limits, and conditions before writing MATLAB code. Ask it to distinguish a mathematical consequence from a numerical workaround. Any regularization coefficient, truncation tolerance, or fallback must have an explicit course, mathematical, or training-only validation basis; without one, leave it undecided. Test on synthetic data with known class means, check symmetry and shapes of scatter matrices, test rank-deficient cases as expected diagnostics, and verify fit-only-on-training-fold behavior. Review the official course materials and a reliable Fisher LDA source; do not send actual face images or official test data.

## Work sequence

1. Agree with A on labels and with F on the fold-specific fit/transform contract.
2. Write down the exact `Sw`, `Sb`, and objective convention, including row/column orientation.
3. Check MATLAB release and required functions (`eig`, `svd`, `rank`, and any course-approved solver) with `version -release`, `ver`, and `which`.
4. Implement a fit function that returns directions and explicit diagnostics; implement transform separately.
5. Use synthetic data to check matrix shapes, symmetry, class-count rank bound, output dimensions, and rank-deficient reporting.
6. Ask the team to approve a justified handling for singular or ill-conditioned `Sw` before relying on one in the experiment.
7. Commit only assigned LDA source, tests, and derivation notes on `feature/c-lda`; open a pull request to `main` and request review.

## Never silently do these

- Do not infer labels or identity groups from filenames.
- Do not use validation or official test labels to fit directions.
- Do not assume `Sw` is invertible or bury a regularizer in the implementation.
- Do not claim more than `K−1` nonzero between-class directions without explaining a different method.
