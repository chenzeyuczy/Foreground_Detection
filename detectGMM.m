% foreground detection 
% if the bg changes fast, then use a small numTrain and large learning rate, to make the bg update fast; or vice versa.

function detectGMM()
	iDataset = 1;
	switch iDataset
		case 1
			numTrain = 5; learnRate = 0.005;
			fgMask = getMaskGMM(iDataset, numTrain,learnRate);
		case 2
			numTrain = 2; learnRate = 0.02;
			fgMask = getMaskGMM(iDataset, numTrain, learnRate);
		case 3
			numTrain = 8;learnRate = 0.005;
			fgMask = getMaskGMM(iDataset, numTrain, learnRate);
		case 4
			numTrain = 2;learnRate = 0.03;
			fgMask = getMaskGMM(iDataset, numTrain, learnRate);
		case 5
			numTrain = 8; learnRate = 0.005;
			fgMask = getMaskGMM(iDataset, numTrain, learnRate);
	end
end


function fgMask = getMaskGMM(iDataset, numTrain,learnRate)
    % Import data.
    dataset_path = 'D:\Dataset\SegTrack_V1\';
	dataset_info = parse_segtrackv1(dataset_path);
	img_cell = dataset_info{iDataset}.data;
    img_num = length(img_cell);
    fgMask = cell(img_num, 1);

    % Find foreground at the begining.
	detector = vision.ForegroundDetector('NumTrainingFrames', numTrain, ...
        'NumGaussians', 3, 'LearningRate', learnRate, 'InitialVariance', 30*30);
	for i = 1:numTrain+1
		img = img_cell{i};
		fgMask{i} = step(detector, img);
		% figure(1),imshow(fgMask{i}),,title(num2str(i)),pause(0.7);
    end

    % Find foreground with enough previous frames.
	for k = numTrain + 2:length(img_cell)
		clearvars detector;
		detector = vision.ForegroundDetector('NumTrainingFrames', numTrain ,...
            'NumGaussians', 5, 'LearningRate', 0.005, 'InitialVariance', 30*30);
		for i = k-numTrain-1:k-1
			fgTmp = step(detector, img_cell{i});
		end
		fgMask{k} = step(detector, img_cell{k});
    end

    % Show image.
	for i = 1:img_num
		figure(1);
        imshow(fgMask{i});
        title(num2str(i));
        pause(0.7);
	end
end