% Function to calculate accuracy and recall of result.
% Input
%   mask: Mask to be judged.
%   gt: Ground truth.
% Output
%   precision: Accuracy of result.
%   recall: Recall of result.
%   error_rate: Error rate of result using xor operation.
% Writen by chenzy.

function [precision, recall, error_rate] = get_hit_rate(mask, gt)
    if size(mask) ~= size(gt)
        precision = 0.0;
        recall = 0.0;
        error_rate = 1.0;
        fprintf('Size not match');
        return;
    end
    hit = mask & gt;
    precision = sum(hit(:)) / sum(mask(:));
    recall = sum(hit(:)) / sum(gt(:));
    unmatch = xor(mask, gt);
    error_rate = sum(unmatch(:)) / (size(mask, 1) * size(mask, 2));
end
