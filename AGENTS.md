# A — Data Preparation and Shared Interface

## Project background

This group is completing a MATLAB face-image classification project and comparing PCA → Bayes, LDA → Bayes, PCA → MLP, and LDA → MLP. The public FaceLab website has a browser-side teaching baseline trained in Python with PCA + Gaussian Naive Bayes. It is not the course implementation and does not verify the other three pipelines.

GitHub is for version control and review; MATLAB is the formal implementation and experiment environment; the browser site is an explanatory demo. Keep real face images, the official test set, private paths, raw identifying filename lists, passwords, and tokens outside this public repository.

## Your role and ownership

Own the data-loading boundary and the input contract consumed by B–F. Coordinate with the team before fixing image conversion, cropping, resizing, color handling, feature ordering, or label interpretation. Deliver a documented `X`, `y`, filename reference, and optional group identifier only when its source is verified.

## Shared data and validation rules

- Use `X` with one image per row and one feature per column (`N × D`); use `y` with one label per row (`N × 1`). Preserve the same row order across all fields.
- Derive labels from the course's annotation or another documented authoritative source. Do not infer identity or class from a filename pattern without evidence.
- Use a `groupID` only when the dataset documentation establishes what it represents. A numeric filename token alone is not proof that two images depict the same person.
- Keep training and official test inputs physically or logically separated. Do not load test records into a helper that fits transforms, selects features, or tunes models.
- Record the agreed image preprocessing and feature ordering. Any choices not settled by course instructions or a documented team decision remain explicitly “to confirm.”
- Start tests with synthetic arrays. Do not commit any face image, private path, or identifying file inventory.

## AI collaboration guidance

Before asking an AI for code, provide the exact non-sensitive input contract, MATLAB release, relevant `ver` output, and the course rule being implemented. Ask it to list assumptions and missing information first. Require dimensions for every array and an explanation for each numeric choice. If no source supports a value, mark it pending instead of guessing. Request a small MATLAB example using synthetic data, checks for row/label alignment, missing or unreadable files, invalid values, duplicate records, and train/test separation. Verify the result against MATLAB documentation and the course materials, run it locally, and inspect the Git diff before accepting it.

Never provide face images, official test examples, account credentials, tokens, or private local paths to an unapproved AI service. Redact logs that include identifying filenames.

## Work sequence

1. Read the course dataset description and record label source, split boundaries, and any stated grouping rule.
2. Check MATLAB with `version -release`, `ver`, and `which imageDatastore -all` (or the course-approved equivalent).
3. Agree on the pixel/color preprocessing and feature ordering with B–F before implementing the loader.
4. Implement the loader and validation checks so the same saved configuration is used for every method.
5. Use synthetic data to verify shapes and failure messages; locally inspect a small sample for readability without copying it into Git.
6. Document the interface, verified assumptions, unresolved decisions, MATLAB version, and test command for F.
7. Commit only assigned data-preparation source and documentation on `feature/a-data-loader`; open a pull request to `main` and request review.

## Questions the AI must resolve before coding

- Which course-provided source defines each class label?
- What exact preprocessing and flattening order does the group approve?
- Does the dataset provide a trustworthy group identifier, and what does it mean?
- How are unreadable, duplicated, or out-of-spec images reported without leaking filenames?
- Which tests prove row alignment and separation of training from official test data?
