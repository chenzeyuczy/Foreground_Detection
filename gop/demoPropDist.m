% Demo
% feat is feature of proposals, stdFeat is the feature of a reliable fg image.

% Get features from provious foreground region.
dim = 16;
stdFeat = getMaskHist(reliableImg, reliableFgMask, dim);
areaThresh = sum(reliableFgMask(:));

% Get proposals.
[props, ~] = get_proposal(img);
numProp = size(props, 1);

% Sort proposals based on dist and area.
propDist = ones(numProp,1);
propArea = zeros(numProp,1);
areaMin = 0.4 * areaThresh;
areaMax = 1.5 * areaThresh;
for index = 1:numProp
	mask = props(index,:); 
	prop_mask = mask > 0;
	propArea(index) = sum(prop_mask(:));
	if propArea(index) > areaMin && propArea(index) < areaMax
		feat = getMaskHist(img, propMask, dim);
		propDist(index) = 0.5 * (sum((feat-stdFeat).^2 ./(feat+stdFeat+eps)));
	end
end
[sortDist,indDist] = sort(propDist,'ascend');


% Use proposals to generate the initial foreground for this frame,
% only the top 2 prposals are kept here.
numSelectProp = 2;  
fg = false(size(img,1),size(img,2));
for index = 1:numSelectProp
	propIdx = indDist(index);
	mask = props(propIdx,:);
	prop_mask = mask > 0;
	if true  % here is your conditions of a proposal: area, overlap ratio, position, etc.
		fg = fg | prop_mask;
	end
end