% This is the initialization script.
% Writen by chenzy.

clear('all');

% Add library and subfolders into path.
addpath(genpath('vlfeat/'));
addpath('superpixel/');
addpath('Manifold_Ranking/');
addpath('Preprocess/');
addpath('Stage1/');
addpath('Stage2/');
addpath(genpath('gop/'));
addpath('tool/');
addpath('test/');

% Import data.
import_data;

% % Choose video.
% videoIndex = 4;
% images = data_info{videoIndex}.data;
% ground_truth = data_info{videoIndex}.gt;
% imgNum = length(images);

% Declare variables.
video_num = 5;
precision = cell(video_num, 1);
recall = cell(video_num, 1);
error_rate = cell(video_num, 1);
foreground = cell(video_num, 1);
time1 = zeros(video_num, 1);
avg_time1 = zeros(video_num, 1);
time2 = zeros(video_num, 1);
avg_time2 = zeros(video_num, 1);
