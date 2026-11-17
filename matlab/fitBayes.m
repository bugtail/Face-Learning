function [model, fitSeconds] = fitBayes(Ztrain, ytrain)
%FITBAYES Train a Gaussian Naive Bayes classifier on reduced face features.
%   [MODEL, FITSECONDS] = FITBAYES(ZTRAIN, YTRAIN)
%   ZTRAIN    N-by-q real, finite, full double matrix (q >= 1).
%   YTRAIN    N-by-1 categorical vector with labels 'man' and 'woman'.
%   MODEL     MATLAB ClassificationNaiveBayes model for PREDICTBAYES.
%   FITSECONDS Elapsed classifier fitting time, in seconds.
%
%   This function consumes only training-fold features and labels. PCA/LDA
%   fitting, cross-validation splits, and evaluation belong to other stages.
%   The class order is always man, woman (scores column 1 and column 2).
%   Requires Statistics and Machine Learning Toolbox (fitcnb).

narginchk(2, 2);
validateattributes(Ztrain, {'double'}, ...
    {'2d', 'real', 'finite', 'nonsparse', 'nonempty'}, mfilename, 'Ztrain', 1);

[nRows, nFeatures] = size(Ztrain);
if nRows < 4 || nFeatures < 1
    error('FaceLab:Bayes:InvalidFeatureShape', ...
        'Ztrain must have at least four rows and one feature column.');
end

if ~iscategorical(ytrain) || ~isvector(ytrain) || ...
        numel(ytrain) ~= nRows || any(isundefined(ytrain(:)))
    error('FaceLab:Bayes:InvalidLabels', ...
        'ytrain must be a defined categorical label for every training row.');
end

ytrain = ytrain(:);
labelStrings = string(ytrain);
classOrder = ["man"; "woman"];
if any(~ismember(labelStrings, classOrder)) || ...
        sum(labelStrings == "man") < 2 || sum(labelStrings == "woman") < 2
    error('FaceLab:Bayes:InvalidClasses', ...
        'Only man/woman labels are allowed, with at least two rows per class.');
end

% Make label categories and class ordering independent of input category order.
ytrain = categorical(labelStrings, classOrder);
fixedClasses = categorical(classOrder, classOrder);

started = tic;
model = fitcnb(Ztrain, ytrain, ...
    'DistributionNames', 'normal', ...
    'Prior', 'empirical', ...
    'ClassNames', fixedClasses);
fitSeconds = toc(started);
end
