% Explanation:
% Extract info of SegTrackV2: according to txt files, do not use all the frames.

% Input:
% segtrack_root=[pwd '/Dataset/SegTrackv1/'];



function [dataset_info] = parse_segtrackv1(segtrack_root)

	video_name = dir(segtrack_root);
	video_name(1:2) = [];
    % Remove first two elements from array.

	for i = 1:length(video_name)
		dataset_info{i}.data_name=video_name(i).name;
		video_root = [segtrack_root video_name(i).name '/'];
		video_info = dir(video_root);
		video_info(1:2) = [];
        % Remove first two elements from array.
        
		for j = 1:length(video_info)
			if strcmp(video_info(j).name,'ground-truth') == 1
				delete_flag = j;
                % Find index of ground-truth.
				break;
			end
		end 
		video_info(delete_flag) = [];
        % Remove ground-truth from array.
        
		for j = 1:length(video_info)
			img_path = [video_root video_info(j).name];
			dataset_info{i}.data{j,1} = imread(img_path);
			dataset_info{i}.img_name{j,1} = video_info(j).name;
		end

		gt_info = dir([video_root 'ground-truth/']);
		gt_info(1:2) = [];
		for j = 1:length(gt_info)
			gt_path = [video_root 'ground-truth/' gt_info(j).name];
			dataset_info{i}.gt_name{j,1} = gt_info(j).name;
			dataset_info{i}.gt{j,1} = imread(gt_path);
		end
	end

end
