% Function to generate object proposal from image,
% using Geodestic Object Proposal Algorithm(GOP).
% Input
%   - img: Image to be processed.
%   - maxPropNum: Maximum number of object proposals to return, set as
%   size of proposals by default.
%   - showProp: Option to determine whether to show proposals or not.
% Output
%   - masks: Cell array which restore proposal info within a image.
%   - boxes: A two dimension matrix which restores bounding boxes around
%   proposals.
% Writen by chenzy.


function [masks, boxes] = get_proposals(img, maxPropNum, showProp)    
    % ---Initialization---
    
    % Set a boundary detector by calling (before creating an OverSegmentation!):
    % gop_mex( 'setDetector', 'SketchTokens("./data/st_full_c.dat")' );
    % gop_mex( 'setDetector', 'StructuredForest("./data/sf.dat")' );
    gop_mex( 'setDetector', 'MultiScaleStructuredForest("./gop/data/sf.dat")' );
    % Watch out for the path here.
    % Havn't found way to solve it yet.

    % Setup the proposal pipeline (baseline)
    p = Proposal('max_iou', 0.8,...
                 'unary', 130, 5, 'seedUnary()', 'backgroundUnary({0,15})',...
                 'unary', 130, 1, 'seedUnary()', 'backgroundUnary({})', 0, 0, ... % Seed Proposals (v1.2 and newer)
                 'unary', 0, 5, 'zeroUnary()', 'backgroundUnary({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15})' ...
                 );
    % Setup the proposal pipeline (learned)
    % p = Proposal('max_iou', 0.8,...
    %              'seed', './data/seed_final.dat',...
    %              'unary', 140, 4, 'binaryLearnedUnary("./data/masks_final_0_fg.dat")', 'binaryLearnedUnary("./data/masks_final_0_bg.dat"',...
    %              'unary', 140, 4, 'binaryLearnedUnary("./data/masks_final_1_fg.dat")', 'binaryLearnedUnary("./data/masks_final_1_bg.dat"',...
    %              'unary', 140, 4, 'binaryLearnedUnary("./data/masks_final_2_fg.dat")', 'binaryLearnedUnary("./data/masks_final_2_bg.dat"',...
    %              'unary', 140, 1, 'seedUnary()', 'backgroundUnary({})', 0, 0, ... % Seed Proposals (v1.2 and newer)
    %              'unary', 0, 5, 'zeroUnary()', 'backgroundUnary({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15})' ...
    %              );
            
    % Create an over-segmentation
    os = OverSegmentation(img);
    % Generate proposals
    props = p.propose(os);
        
    % Generate boxes around proposals, which is optional.
    boxes = os.maskToBox(props);
    
    % ---Set arguments---
    if nargin < 3
        showProp = false;
    end
    if nargin > 1
        maxPropNum = min(size(props, 1), maxPropNum);
    else
        maxPropNum = size(props, 1);
    end
    
    masks = cell(maxPropNum, 1);
    for index = 1:maxPropNum
        m = props(index, :);
        masks{index} = uint8(m(os.s() + 1));
        if showProp == 1
            show_op(img, masks{index}, boxes(index,:));
            pause();
        end
    end
end