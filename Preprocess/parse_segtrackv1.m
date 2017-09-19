% Extract data from SegTrackV1.

% Input:
% segtrack_root=[pwd '/Dataset/SegTrackv1/'];

% Output:
% dataset_info: A cell with raw images and ground-truth.


function [dataset_info] = parse_segtrackv1(segtrack_root)

	video_name = dir(segtrack_root);
    % Remove first two elements from array.
	video_name(1:2) = [];
    dataset_info = cell(length(video_name), 1);

	for i = 1:length(video_name)
		dataset_info{i}.data_name = video_name(i).name;
		video_root = [segtrack_root video_name(i).name '/'];
		video_info = dir(video_root);
        % Remove first two elements from array.
		video_info(1:2) = [];
        
        % Remove ground-truth from array.
		for j = 1:length(video_info)
            % Find index of ground-truth.
			if strcmp(video_info(j).name, 'ground-truth') == 1
				delete_flag = j;
				break;
			end
		end 
		video_info(delete_flag) = [];
        
		for j = 1:length(video_info)
			img_path = [video_root video_info(j).name];
			dataset_info{i}.data{j, 1} = imread(img_path);
			dataset_info{i}.img_name{j, 1} = video_info(j).name;
		end

		gt_info = dir([video_root 'ground-truth/']);
		gt_info(1:2) = [];
		for j = 1:length(gt_info)
			gt_path = [video_root 'ground-truth/' gt_info(j).name];
			dataset_info{i}.gt_name{j, 1} = gt_info(j).name;
			dataset_info{i}.gt{j, 1} = imread(gt_path);
			dataset_info{i}.gt{j, 1} = im2bw(dataset_info{i}.gt{j});
		end
	end

end
