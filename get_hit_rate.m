% Function to calculate accuracy and recall of result.
% Input
%   mask: Mask to be judged.
%   gt: Ground truth.
% Output
%   accuracy: Accuracy of result.
%   recall: Recall of result.
% Writen by chenzy.

function [accuracy, recall] = get_hit_rate(mask, gt)
    if size(mask) ~= size(gt)
        error('Size not match');
        accuracy = 0.0;
        recall = 0.0;
        return;
    end
    hit = mask & gt;
    accuracy = sum(hit(:)) / sum(mask(:));
    recall = sum(hit(:)) / sum(gt(:));
end
