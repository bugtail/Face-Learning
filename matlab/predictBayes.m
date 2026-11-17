function [labels, scores, classNames, predictSeconds] = predictBayes(model, Zvalid)
%PREDICTBAYES Predict labels and posterior probabilities using FITBAYES.
%   [LABELS, SCORES, CLASSNAMES, PREDICTSECONDS] = ...
%       PREDICTBAYES(MODEL, ZVALID)
%   ZVALID         M-by-q finite, full double matrix; q matches training.
%   LABELS         M-by-1 categorical labels ('man' or 'woman').
%   SCORES         M-by-2 double posterior probabilities in fixed order.
%   CLASSNAMES     2-by-1 string array: ["man"; "woman"].
%   PREDICTSECONDS Classifier prediction time in seconds.
%
%   SCORES(:,2) represents P(woman | feature row), useful for ROC/AUC.
%   This function never refits the classifier or learns from validation data.

narginchk(2, 2);
if ~isobject(model) || ~isprop(model, 'ClassNames') || ...
        ~isprop(model, 'PredictorNames')
    error('FaceLab:Bayes:InvalidModel', ...
        'model must be a trained fitcnb classification model.');
end

validateattributes(Zvalid, {'double'}, ...
    {'2d', 'real', 'finite', 'nonsparse', 'nonempty'}, mfilename, 'Zvalid', 2);
expectedFeatures = numel(model.PredictorNames);
if size(Zvalid, 2) ~= expectedFeatures
    error('FaceLab:Bayes:FeatureDimensionMismatch', ...
        'Expected %d feature columns, received %d.', ...
        expectedFeatures, size(Zvalid, 2));
end

% Map the model's score-column order to the team's fixed class order.
classNames = ["man"; "woman"];
modelClasses = string(model.ClassNames(:));
if numel(modelClasses) ~= 2 || ~isequal(sort(modelClasses), classNames)
    error('FaceLab:Bayes:UnexpectedClassNames', ...
        'The model must contain exactly the classes man and woman.');
end
[~, columnOrder] = ismember(classNames, modelClasses);

started = tic;
[rawLabels, rawScores] = predict(model, Zvalid);
predictSeconds = toc(started);

labels = categorical(string(rawLabels(:)), classNames);
scores = double(rawScores(:, columnOrder));
if ~isequal(size(scores), [size(Zvalid, 1), 2]) || ...
        any(~isfinite(scores(:))) || any(scores(:) < -1e-12) || ...
        any(scores(:) > 1+1e-12) || ...
        any(abs(sum(scores, 2) - 1) > 1e-8) || any(isundefined(labels))
    error('FaceLab:Bayes:InvalidPrediction', ...
        'The classifier returned invalid labels or posterior probabilities.');
end
end
