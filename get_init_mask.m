function init_prop = get_init_mask(frames, sp_map, props, frameIndex)
   currentFrame = frames{frameInde};
   lastFrame = frames{frameIndex - 1};
   % Operate 
   diffThld = 0.01;
   diff = diff_between_images(currentFrame, lastFrame, diffThld);
end
