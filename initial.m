% This is the initialization script.
% Writen by chenzy.

% Add library and subfolders into path.
addpath(genpath('vlfeat/'));
addpath('superpixel/');
addpath('Manifold_Ranking/');
addpath('Preprocess/');
addpath('Stage1/');
addpath('Stage2/');
addpath(genpath('gop/'));
addpath('test/');

% Import data.
import_data;

% Choose video.
videoIndex = 4;
images = data_info{videoIndex}.data;
ground_truth = data_info{videoIndex}.gt;
imgNum = length(images);

% Initialize parameters.
opts.slic_regionsize = 20;
opts.slic_regularizer = 0.1;
opts.show_sp_map = 0;

