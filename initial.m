clear('all');

addpath(genpath('vlfeat'));
% Add CV library into path.
addpath('superpixel');

dataset_path = '~/Documents/Lab/dataset/SegTrack_V1/';
data_info = parse_segtrackv1(dataset_path);

opts.slic_regionsize = 20;
opts.slic_regularizer = 0.1;
opts.show_sp_map = 1;

