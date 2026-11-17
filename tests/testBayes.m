%TESTBAYES Synthetic smoke tests; no private images or MAT files are used.
% Run after adding the repository's matlab directory to the MATLAB path.

% Both columns vary within each class (Gaussian variance is nonzero).
Ztrain = [-4.0 -2.0; -3.1 -1.5; -2.5 -2.8; -3.6 -3.1; ...
           2.4  2.0;  3.2  3.1;  4.1  2.4;  3.6  3.8];
ytrain = categorical(["man";"man";"man";"man"; ...
                      "woman";"woman";"woman";"woman"], ...
                     ["man";"woman"]);
Zvalid = [-3.0 -2.2; 3.3 3.0; -2.7 -1.8; 3.9 2.6];
expected = ["man";"woman";"man";"woman"];

[model, fitSeconds] = fitBayes(Ztrain, ytrain);
[labels, scores, classNames, predictSeconds] = predictBayes(model, Zvalid);
assert(isequal(size(labels), [4 1]) && iscategorical(labels));
assert(isequal(size(scores), [4 2]) && isa(scores, 'double'));
assert(isequal(classNames, ["man";"woman"]));
assert(isequal(string(labels), expected));
assert(all(isfinite(scores(:))) && all(scores(:) >= 0) && ...
       all(scores(:) <= 1));
assert(all(abs(sum(scores, 2) - 1) < 1e-10));
assert(all(scores(string(labels) == "man", 1) > 0.5));
assert(all(scores(string(labels) == "woman", 2) > 0.5));
assert(isfinite(fitSeconds) && fitSeconds >= 0);
assert(isfinite(predictSeconds) && predictSeconds >= 0);

% LDA produces exactly one feature; the same classifier must handle q = 1.
[model1D, ~] = fitBayes(Ztrain(:, 1), ytrain);
[labels1D, scores1D, names1D] = predictBayes(model1D, Zvalid(:, 1));
assert(isequal(string(labels1D), expected));
assert(isequal(size(scores1D), [4, 2]));
assert(isequal(names1D, ["man";"woman"]));

% Reject mismatched feature dimensions rather than silently mispredicting.
caught = false;
try
    predictBayes(model1D, Zvalid);
catch ME
    caught = strcmp(ME.identifier, 'FaceLab:Bayes:FeatureDimensionMismatch');
end
assert(caught, 'Expected the feature-dimension validation error.');

fprintf('Bayes synthetic tests passed (q=2, q=1, class order, probabilities, validation).\n');
fprintf('Fit: %.6f s | Predict: %.6f s\n', fitSeconds, predictSeconds);
