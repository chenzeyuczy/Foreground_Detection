% This is the initialization script.
% Writen by chenzy.

clear('all');

% Add library and subfolders into path.
addpath(genpath('vlfeat/'));
addpath('superpixel/');
addpath('Manifold_Ranking/');
addpath('Stage1/');
addpath('Stage2/');
addpath(genpath('gop/'));

% Import data.
dataset_path = '~/Documents/Lab/dataset/SegTrack_V1/';
data_info = parse_segtrackv1(dataset_path);

% Choose video.
videoIndex = 3;
images = data_info{videoIndex}.data;
ground_truths = data_info{videoIndex}.gt;
imageNum = length(images);

% Initialize parameters.
opts.slic_regionsize = 20;
opts.slic_regularizer = 0.1;
opts.show_sp_map = 0;

