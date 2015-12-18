% Extract hist color features, given a proposal mask.
% Input
%     - img: Original image.
%     - propMask: Mask for proposal with the same size as image.
%     - dim: Number of bins in histogram.
% Output
%     - feat: Histogram features extracted from an image.
% Attention:
%   This function is deprecated since it execute image convertion
% many times, use get_mask_hist and merge_hist_info instead.

function feat = getMaskHist(img, propMask, dim)
    % Parameter initialization.
    if nargin < 3
        dim = 16;
    end
    
    % Convert mask matrix into a logical type.
    propMask = logical(propMask);
	
	% Convert to diverse color space.
	labImg = rgb2lab(img);
	ycbcrImg = rgb2ycbcr(img);
	hsvImg = rgb2hsv(img);
	
	% RGB color space.
	rCh = img(: ,:,1);
	gCh = img(: ,:,2);
	bCh = img(: ,:,3);
	rPix = rCh(propMask);
	gPix = gCh(propMask);
	bPix = bCh(propMask);
	rTmp = hist(double (rPix), dim);
	gTmp = hist(double (gPix), dim);
	bTmp = hist(double (bPix), dim);
	rTmp = rTmp(:);
	gTmp = gTmp(:);
	bTmp = bTmp(:);
	
	% LAB color space.
	lCh = labImg(: ,:,1);
	aCh = labImg(: ,:,2);
	brCh = labImg(: ,:,3);
	lPix = lCh(propMask);
	aPix = aCh(propMask);
	brPix = brCh(propMask);
	lTmp = hist(double (lPix), dim);
	aTmp = hist(double (aPix), dim);
	brTmp = hist(double (brPix), dim);
	lTmp = lTmp(:);
	aTmp = aTmp(:);
	brTmp = brTmp(:);
	
	% YCbCr color space.
	yCh = ycbcrImg(: ,:,1);
	cbCh = ycbcrImg(: ,:,2);
	crCh = ycbcrImg(: ,:,3);
	yPix = yCh(propMask);
	cbPix = cbCh(propMask);
	crPix = crCh(propMask);
	yTmp = hist(double (yPix), dim);
	cbTmp = hist(double (cbPix), dim);
	crTmp = hist(double (crPix), dim);
	yTmp = yTmp(:);
	cbTmp = cbTmp(:);
	crTmp = crTmp(:);
	
	% HSV color space.
	hCh = hsvImg(: ,:,1);
	sCh = hsvImg(: ,:,2);
	vCh = hsvImg(: ,:,3);
	hPix = hCh(propMask);
	sPix = sCh(propMask);
	vPix = vCh(propMask);
	hTmp = hist(double (hPix), dim);
	sTmp = hist(double (sPix), dim);
	vTmp = hist(double (vPix), dim);
	hTmp = hTmp(:);
	sTmp = sTmp(:);
	vTmp = vTmp(:);
	
	feat =[rTmp;gTmp;bTmp;lTmp;aTmp;brTmp;yTmp;cbTmp;crTmp;hTmp;sTmp;vTmp];
	% Histogram normalization.
	feat = feat./ (eps + sum(feat));
	
end