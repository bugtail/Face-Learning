# FaceLab data contract v1.1

This schema is the handoff from A to B–F. Read PROJECT_SPECIFICATIONS.md and TEAM_WORKING_RULES.md before changing it.

## Course data split

The course handout specifies 200 training images (100 per class) and a separate 100-image official test set (50 per class). The supplied training folder checked for this update contains the 200 training PNGs. The official test set was not found in the checked locations, so final test evaluation is pending until authorized files are provided.

## Private files

A creates these packages in the approved private team folder, never in this public repository:

- train_dataset.mat: X (200 × 1,024 double), y (200 categorical labels, 100 man and 100 woman), sampleID, groupID, and preprocessSpec.
- test_dataset.mat: separate X and y for the 100 official test images (50 man and 50 woman), with anonymous IDs and the same preprocessSpec. Use a 100 × 1,024 X only if the official images are verified to have the same 640 × 640 RGB input format.
- data_manifest.csv and test_data_manifest.csv: private source-file audit tables. Do not commit them.

F creates fold_manifest.csv from the training package only. It has one row per training sample with sampleID, groupID, label, and outerFold. It contains no test IDs.

## Conversion

The checked training inputs are 640 × 640 RGB PNGs. A averages each non-overlapping 20 × 20 × 3 pixel block over all channels after dividing by 255. The 32 × 32 cell values are flattened row-major into X. Apply this identical conversion to test images only after confirming matching dimensions and RGB mode. If official test images differ, pause and update the shared preprocessing contract before evaluation; do not silently resize, crop, or change color mode.

## Validation and evaluation boundary

For training data, check counts, label categories, group sizes, image shape/mode, row alignment, finite values, and [0,1] range. The expected set has 100 rows per class, 50 filename groups per class, and two training rows per group.

For test data, check the handout's 100 total images and 50/50 class balance, then verify input shape/mode and the same feature schema. Keep it sealed during development and five-fold cross-validation. After method code and settings are frozen, F evaluates it once using models refit on all 200 training images. Test rows, labels, and predictions stay private; publish aggregate metrics only. Never substitute a cross-validation fold for the official test set.

## Privacy

Training/test images, both MAT files, raw filename maps, fold manifest, sample-level predictions, and private paths stay private. Public GitHub contains this schema, code, synthetic examples, and reviewed aggregate results only.
