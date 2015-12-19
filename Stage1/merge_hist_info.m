% Function to integrate histogram features.
% Input
%   - varargin: List of histogram features.
% Output
%   feature: A two dimension array with integrated hist feature.
% Writen by chenzy.

function feature = merge_hist_info(varargin)
    feature = [];
    for index = 1:numel(varargin)
        histFeat = varargin{index};
        feature = [feature; histFeat(1); histFeat(2); histFeat(3)];
    end
    % Normalization.
    feature = feature ./ (sum(feature) + eps);
end