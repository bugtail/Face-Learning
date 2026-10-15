# D — Bayes Classifier

## Project background

The goal is to compare PCA → Bayes, LDA → Bayes, PCA → MLP, and LDA → MLP in MATLAB using identical splits and evaluation rules. The public FaceLab website currently demonstrates one browser-side model trained in Python: PCA + Gaussian Naive Bayes. That baseline does not establish that the course's Bayes definition is Gaussian Naive Bayes or that the MATLAB implementation is complete.

The feature input is expected to have one sample per row (`Ztrain: N × q`), with labels aligned in `ytrain: N × 1`. GitHub stores code and review, MATLAB runs the formal experiments. Do not commit face images, official test data, credentials, private paths, or identifying filename lists.

## Your role and ownership

Own a classifier interface that can consume either PCA or LDA features without duplicating feature preprocessing. Agree with the course specification and group before selecting the meaning of “Bayes,” the likelihood family, prior rule, parameter estimation, or any smoothing. Return predictions and score metadata in an unambiguous class order for F.

## Model and output requirements

“Bayes” alone does not determine a classifier. Identify the course-required conditional likelihood assumptions, class priors, parameter estimation, and prediction rule. MATLAB `fitcnb` is a Naive Bayes implementation; use it only if its documented options and actual release match the course's required method. Check toolbox availability with `version -release`, `ver`, and `which fitcnb -all`.

Define and document fit/predict behavior. Prediction output should include labels, a continuous class score matrix, and `classNames` in the corresponding column order. The positive-class score used for ROC/AUC must be selected by matching the class name, not by assuming a column index. Do not call an uncalibrated score a probability unless that property is established. Handle unseen or malformed inputs explicitly.

Fit classifier parameters only from the current fold's training features and labels. If a model option or prior is tuned, tune it only within the outer training data. Validation assesses the fitted model; the official test set remains locked until settings are fixed.

## AI collaboration guidance

Give AI the course's exact “Bayes” wording, MATLAB release/toolbox details, expected feature shapes, and class names. First request a comparison of the course definition to the selected MATLAB implementation, including assumptions, priors, estimation rules, and score semantics. Ask it to list mismatches and questions for the instructor before generating code. Every smoothing value or numeric fallback needs a documented source; do not accept a guessed epsilon. Request synthetic tests for class order, score columns, class priors, and both PCA/LDA feature inputs. Verify behavior in the official [`fitcnb` documentation](https://www.mathworks.com/help/stats/fitcnb.html) or the course-approved implementation, run MATLAB tests, and inspect the staged diff. Never disclose face images or official test examples to an AI tool.

## Work sequence

1. Obtain the course's exact Bayes definition before picking the implementation.
2. Check the MATLAB release, toolbox, and implementation documentation.
3. Agree with B, C, E, and F on input shape, labels, score columns, and class-name ordering.
4. Implement fit and predict functions with explicit model assumptions and outputs.
5. Test on synthetic data; verify class order and positive-score selection using names.
6. Run only on training folds and produce validation predictions through F's shared fold manifest.
7. Record MATLAB version, model options, test command, and unresolved assumptions.
8. Commit only assigned classifier source and tests on `feature/d-bayes`; open a pull request to `main` and request review.

## Do not assume

- Do not equate every Bayes classifier with Naive Bayes.
- Do not assume Gaussian likelihoods, equal priors, or built-in defaults match the assignment.
- Do not report raw classifier scores as calibrated probabilities.
- Do not select model settings by inspecting outer validation or official test results.
