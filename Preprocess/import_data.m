% This is a script to import data from dataset.
% Writen by chenzy.

dataset_path = 'D:\Dataset\SegTrack_V1\';
data_info = parse_segtrackv1(dataset_path);

data_info{4}.data = removeBoundary(data_info{4}.data);
data_info{4}.gt = removeBoundary(data_info{4}.gt);
