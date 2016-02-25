% This is the initialization script.
% Writen by chenzy.

clear('all');

% Add library and subfolders into path.
addpath(genpath('./vlfeat/'));
addpath('./superpixel/');
addpath('./Manifold_Ranking/');
addpath('./Preprocess/');
addpath('./Stage1/');
addpath('./Stage2/');
addpath(genpath('./gop/'));
addpath('./tool/');
addpath('./test/');

% Import data.
import_data;

% % Choose video.
% videoIndex = 4;
% images = data_info{videoIndex}.data;
% ground_truth = data_info{videoIndex}.gt;
% imgNum = length(images);

% Assing values to variables.
opts.slic_regionsize = 20;
opts.slic_regularizer = 0.1;
opts.slic_minregionsize = 100;
opts.show_sp_map = 0;

% Declare variables.
video_num = 5;

proposals = cell(video_num, 1);
boxes = cell(video_num, 1);

precision1 = cell(video_num, 1);
recall1 = cell(video_num, 1);
error_pixel1 = cell(video_num, 1);
precision2 = cell(video_num, 1);
recall2 = cell(video_num, 1);
error_pixel2 = cell(video_num, 1);

init_fg = cell(video_num, 1);
final_fg = cell(video_num, 1);
time1 = zeros(video_num, 1);
avg_time1 = zeros(video_num, 1);
time2 = zeros(video_num, 1);
avg_time2 = zeros(video_num, 1);
