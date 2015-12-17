% This funnction is used to detect foreground regions in a series of
% frames.
% Writen by chenzy.

function foreground = foregroundDetection(frames)
    % Set number of frames required to generate initial proposals.
    slide_window = 3;
    
    % Declare some variables.
    frame_num = length(frames);
    sp_map = cell(frame_num, 1);
    props = cell(frame_num, 1);
    foreground = cell(frame_num, 1);
    
    % Start loop.
    for frameIndex = 1:frame_num
        sp_map{frameIndex} = get_superpixels(frames(frameIndex));
        [props{frameIndex}, ~] = get_proposals(frames(frameIndex));
        init_prop = genertateInitialProposal(frames, frameIndex);
        if frameIndex > slide_window
            foreground{frameIndex} = constructForeground(frames, sp_map, init_prop, frameIndex);
%             saliency_map = rankSaliency(sp_map, init_prop, frameIndex);
%             generateForeground(frames(frameIndex), saliency_map);
        end
    end
end