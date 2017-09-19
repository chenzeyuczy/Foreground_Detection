% Extract data from SegTrackV2.

% Input:
% segtrack_root: [pwd '/Dataset/SegTrackv2/']

% Output:
% 1*14 cell array. images are contained in another cell array in each big cell
% 3 fields:  img_path, img_name, data, data_name, gt


function [dataset_info] = parse_segtrackv2(segtrack_root)

    % Extract names of dataset.
	datasets_all = textread([segtrack_root 'ImageSets/all.txt'], '%s');
    % Remove asterisk(*) at the front.
	datasets_all = cellfun(@(str) str(2:end), datasets_all, 'UniformOutput',  false);
	
    multi_object_ind = [4 6 7 9 10 12];    % delete videos with multi-objects
	for i = 1:length(multi_object_ind)
		datasets_all(multi_object_ind(i) - i + 1) = [];   
	end

	dataset_info = cell(length(datasets_all), 1);   

	for i = 1:length(datasets_all)  % process 14 sub_datasets in SegTrackV2
		dataset_info{i}.data_name = datasets_all{i};    % store sub_dataset name
		
		% Load image names.
		img_names = textread([segtrack_root 'ImageSets/' datasets_all{i} '.txt'],  '%s' );
		dataset_info{i}.img_path = cell(length(img_names) - 1, 1);
		dataset_info{i}.img_name = cell(length(img_names) - 1, 1);
		img_folder = [segtrack_root 'JPEGImages/' datasets_all{i} '/'];
		files = dir(img_folder);
		[~, ~, ext] = fileparts(files(4).name);  % Avoid confusion extension caused by mat files.
		for j = 2:length(img_names)  % (j-1) is intended to skip folder name in first line of the txt
			dataset_info{i}.img_path{j-1} = [img_folder img_names{j} ext];
			dataset_info{i}.img_name{j-1} = img_names{j};
		end

		% Load image data.
		dataset_info{i}.data = cell(length(dataset_info{i}.img_path), 1);
        for k = 1:length(dataset_info{i}.img_path)    
            dataset_info{i}.data{k} = imread(dataset_info{i}.img_path{k});
        end

        % Load ground truth.
		gt_folder = [segtrack_root 'GroundTruth/' dataset_info{i}.data_name];
	    gt_files = dir([gt_folder '/*.*']);
	    [~, ~, gt_format] = fileparts(gt_files(3).name);  % Skip first 2 items returned by dir.
	    gt_format = gt_format(2:end);
	    dataset_info{i}.gt = cell(length(dataset_info{i}.data),1);
	    for j = 1:length(dataset_info{i}.data)
	        color_gt = imread([gt_folder '/' dataset_info{i}.img_name{j} '.' gt_format]);
            dataset_info{i}.gt{j} = im2bw(color_gt);
	    end

	end

end
