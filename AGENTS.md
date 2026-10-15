# E — Multilayer Perceptron Classifier

## Project background

The team will compare four MATLAB pipelines: PCA → Bayes, LDA → Bayes, PCA → MLP, and LDA → MLP. The public FaceLab website currently has only a Python-trained, browser-side PCA + Gaussian Naive Bayes baseline; no MLP combination is trained or validated there. Do not imply that selecting an MLP lesson on the website produces an MLP prediction.

The classifier receives transformed feature rows (`Ztrain: N × q`) and aligned labels (`ytrain: N × 1`). GitHub is for version control and review; MATLAB is the formal implementation environment. Never put face images, official test data, private paths, credentials, or identifying filename lists in this repository.

## Your role and ownership

Implement a reproducible MLP fit/predict module usable with both PCA and LDA features. Confirm whether the course permits a built-in classifier such as `fitcnet` or requires a custom implementation. Keep architecture, training settings, random state, stopping rule, score order, and parameter-count method visible and recorded.

## Training and evaluation constraints

Check `version -release`, `ver`, and `which fitcnet -all` before relying on the API. Verify the course's MATLAB and toolbox requirements rather than assuming a function available in another release is installed locally.

Every architecture, regularization, stopping, or optimization setting must come from a course instruction or a stated, reproducible selection procedure inside each outer training set. Do not invent layer sizes or search ranges. If an inner validation procedure is required, build it only from outer-training rows. Do not use an outer validation fold or official test set to select network settings.

Record the exact model structure and RNG handling. Compute trainable parameter count from the fitted network's actual weight matrices and bias vectors; for a fully connected layer with input width `d_in` and output width `d_out`, its weight and bias count is `d_out × d_in + d_out`. Confirm actual layer types and parameter tensors before reporting a total. Measure fitting and prediction separately, and state the measured boundaries and hardware.

Prediction outputs must include labels, continuous scores, and `classNames`; ensure score columns match those names before F computes ROC/AUC. A score is not automatically a calibrated probability.

## AI collaboration guidance

Provide AI the MATLAB release/toolbox output, course constraints, feature dimensions, and the exact interface. Ask it to verify `fitcnet` availability and suitability before proposing code. Require every architecture or training parameter to cite its course or experimental basis; mark unknowns pending rather than guessing. Ask for synthetic examples, stable class score ordering checks, RNG reproducibility checks, actual parameter counting from fitted weights, and separate fit/predict timing. Review the official [`fitcnet` documentation](https://www.mathworks.com/help/stats/fitcnet.html), run MATLAB tests, and inspect the staged diff. Do not provide real face images, official test examples, credentials, or private paths to AI.

## Work sequence

1. Confirm with the group and instructor whether a built-in or custom MLP is required.
2. Check MATLAB release/toolbox and function availability locally.
3. Agree with B, C, D, and F on `fitMLP`/`predictMLP`, class order, and output fields.
4. Establish only course-approved or training-only settings; document the choice procedure before evaluating outer validation.
5. Implement deterministic/reproducible training and separate prediction code.
6. Test using synthetic feature matrices, including shape errors, class order, and reproducibility.
7. Count actual trained parameters and record fit and prediction time separately.
8. Let F run the same fold manifest used by the other three combinations.
9. Commit only assigned MLP code and tests on `feature/e-mlp`; open a pull request to `main` and request review.

## Do not assume

- Do not assume `fitcnet` exists or is allowed in the team's MATLAB installation.
- Do not invent hidden-layer sizes, regularization values, or stopping tolerances.
- Do not tune using the outer validation fold or official test set.
- Do not compare models using training accuracy alone.
