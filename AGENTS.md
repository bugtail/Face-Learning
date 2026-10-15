# F — Cross-Validation, Integration, and Reporting

## Project background

The project compares PCA → Bayes, LDA → Bayes, PCA → MLP, and LDA → MLP in MATLAB. All four must use the same input contract, sample identities, outer fold assignments, positive class, score definition, and evaluation procedure. The public FaceLab site currently shows only a Python-trained PCA + Gaussian Naive Bayes browser demonstration; its metrics are not a four-method comparison.

GitHub is for collaboration and review, MATLAB is for formal training and evaluation, and the browser site is a teaching aid. Never commit face images, official test data, raw identifying filename lists, credentials, or private local paths.

## Your role and ownership

Own the versioned fold manifest, the orchestration interface, leakage checks, common metric definitions, and reproducible result records. Coordinate with A–E before locking the interface. Report what each method actually ran; do not fill missing results with baseline results or present unimplemented pipelines as measured.

## Fold and leakage rules

- Build one fold manifest and have all four combinations consume the same sample-to-fold mapping.
- If observations from one person/session/source must remain together, require a documented and verified `groupID`; never infer identity groups from filename numbers alone.
- In each outer fold, fit preprocessing, PCA/LDA, classifiers, and any tuning choices using only the outer-training rows. Validation rows are for evaluation only.
- If model selection is needed, create its inner procedure only from outer-training rows. Keep the official test set locked until the pipeline and settings are fixed.
- Assert train and validation indices do not overlap and that each expected observation receives the intended out-of-fold prediction exactly once.

## Output and metric contract

Require every method to return actual labels, predicted labels, a continuous score matrix, and ordered `classNames`. Map the positive-class score by matching the class name. `perfcurve` expects labels, scores, and the positive class; verify the score column and label semantics before using it. Define Accuracy, fold aggregation, and AUC aggregation once for the report. State if a score is not a calibrated probability.

Record dataset version without sensitive records, fold-manifest hash/version, MATLAB release/toolboxes, Git commit, preprocessing options, model settings, RNG, feature dimension, actual MLP parameter count where relevant, and separate fit/prediction timing. Keep missing values clearly marked as not run.

## AI collaboration guidance

Give AI only non-sensitive schemas, fold-index summaries, model interfaces, MATLAB release, and course metric definitions. Ask it to audit leakage flow and matrix shapes before writing orchestration code. Require it to distinguish a measured result from a proposed plan and to mark missing details as unresolved. Ask for assertions covering fold disjointness, training-only fit, shared fold IDs, one out-of-fold prediction per observation, score/class order, and locked test handling. Verify the output against MATLAB's [`cvpartition`](https://www.mathworks.com/help/stats/cvpartition.html) and [`perfcurve`](https://www.mathworks.com/help/stats/perfcurve.html) documentation, run synthetic tests and permitted training-fold checks, and inspect the staged diff. Never send images, test examples, private filenames, or credentials.

## Work sequence

1. Get the approved data contract and method interfaces from A–E.
2. Confirm the split policy, grouping evidence, positive class, Accuracy definition, AUC aggregation, and timing boundaries with the team.
3. Generate and validate one fold manifest; save the generation procedure and version without exposing identifying filenames.
4. Implement the runner so it calls each method's fit step on training rows, then transforms and predicts the validation rows.
5. Add assertions for index separation, shared folds, fold-level fitting, output length, score-column semantics, and complete OOF coverage.
6. Run synthetic checks, then the agreed training/validation experiment; keep the official test set locked.
7. Save one row per method/fold plus provenance and explicit `not run` statuses; do not mix training metrics with out-of-fold metrics.
8. After methods and settings are reviewed and frozen, evaluate the official test set once and label it clearly.
9. Commit only assigned validation/integration code and reports on `feature/f-cv-runner`; open a pull request to `main` and request review.

## Do not assume

- Do not create group splits without verified group information.
- Do not let a shared cached PCA/LDA transform be fit on all observations before splitting.
- Do not choose thresholds or model settings from the official test set.
- Do not claim a method comparison when a method has not run under the same protocol.
