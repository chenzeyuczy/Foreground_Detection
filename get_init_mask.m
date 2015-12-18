function init_prop = get_init_mask(frames, sp_map, props, frameIndex)
   currentFrame = frames{frameIndex};
   lastFrame = frames{frameIndex - 1};
   currentProp = props{frameIndex};
   lastProp = props{frameIndex - 1};
   superpixel = sp_map{frameIndex};
   max_prop_num = 100;
   curr_prop_num = min(length(currentProp), max_prop_num);
   last_prop_num = min(length(lastProp), max_prop_num);
   
   diffThld = 0.01;
   regionDiff = diff_between_images(currentFrame, lastFrame, diffThld);
   
   for index1 = 1:last_prop_num
       lastHist = getMaskHist(lastFrame, lastProp{index1});
       area1 = sum(lastProp{index1}(:));
       for index2 = 1:curr_prop_num
           currHist = getMaskHist(currentFrame, currentProp{index2});
           area2 = sum(currentProp{index2}(:));
           size_similarity = 1.0 - 1.0 * abs(area1 - area2) / max(area1, area2);
           propDist = 0.5 * (sum((currHist - lastHist).^2 ./ (currHist + lastHist + eps)));
       end
   end
   
   propDiff = diff_of_proposals(currentFrame, lastFrame, currentProp, lastProp);
   alternativeProp = filterProp(propDiff, regionDiff, currentProp);
   init_prop = convertToSp(alternativeProp, superpixel);
end
