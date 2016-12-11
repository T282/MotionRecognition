%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This scripts implements the demo of the interest point
% with pruning. Please edit the names of the test video if needed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_of_actums = demo_interest_point_wo_pruning(isDisplay, name_of_video, class)
flag = 1;
if flag == 1
    obj = VideoReader(name_of_video);
    video = obj.read();
    video_size = size(video);
    video_bg = zeros(video_size(1),video_size(2),video_size(4),'uint8');
    for i=1:video_size(4)
        im = rgb2gray(video(:,:,:,i));
        video_bg(:,:,i) = im;
    end
    
    corner_points = demo_interest_point_wo_pruning_helper(video_bg, 1, 0);
    framesize = [video_size(1), video_size(2)];
    grid_size = 3;
    video_features = zeros(grid_size,grid_size,video_size(4),'uint8');
    for i = 1 : size(video_bg, 3)
        im = video_bg(:, :, i);
        points = corner_points(corner_points(:, 3) == i, 1 : end);
        for j = 1 : size(points)
            c = region_detector(grid_size,framesize,points(j,:));
            video_features(c(1),c(2),i) = video_features(c(1),c(2),i) + 1;
        end
    end
    save('video_features.mat');
else
    load('video_features.mat');
end
offset = 2;
m = [1 + offset:offset:video_size(4) - offset];
number_of_actionlets = sum(m > 0);
features = zeros(3,3,2*offset + 1, number_of_actionlets);
j = 1;
set_of_actums = [];
for i=1 + offset:offset:video_size(4) - offset
    features(:,:,:,j) = video_features(:,:,i-offset:i+offset);
    feature = [];
    for k=i-offset:i+offset
        feature = [feature'; reshape(video_features(:,:,k),1,9)']';
    end
    set_of_actums = [set_of_actums; feature];
    
    %     fileID = fopen('features.txt','a','n','UTF-8' );
    %     fprintf(fileID,'%s, ',name_of_video);
    %     for m=1:size(feature,2)
    %         fprintf(fileID,'%f, ','hi',feature(m),'hi');
    %     end
    %     fprintf(fileID,'%s\n',class);
    %     j = j + 1;
end

end

function [coordinate] = region_detector(grid_size,framesize, point)
point;
framesize;
limits_x = zeros(1,grid_size + 1) + framesize(1);
limits_y = zeros(1,grid_size + 1) + framesize(2);
for i=0:grid_size
    limits_x(i + 1) = limits_x(i+1)*i/grid_size;
    limits_y(i + 1) = limits_y(i+1)*i/grid_size;
end
limits_x;
limits_y;
y_coord = 0;
x_coord = 0;
for i=1:grid_size
    if point(2) > limits_y(i) && point(2) <= limits_y(i+1)
        y_coord = i;
    end
    if point(1) > limits_x(i) && point(1) <= limits_x(i+1)
        x_coord = i;
    end
end
coordinate = [y_coord,x_coord];

end

function [corner_points] = demo_interest_point_wo_pruning_helper(image_stack,isPrun, isDisplay)

% Adding search paths
addpath('../src/');
% Adding test video name
%   test_vid_name = 'test_video.mat';

% Initialzing sigma array
sigma_array = [0.4;0.9;1.4]; % Possible ranges :[0.2; 0.5;0.9;1.3;1.8;2.3]
bP = 0.30; %Possible values: [0.27-0.45]

% Loading the test video
%   image_stack = load(test_vid_name);
%   image_stack = image_stack.image_stack;
%     size(image_stack)

if (isPrun)
    
    alpha_val = 1.5; % Possible values: [1.1 - 1.9]
    %gP = 0.985; %Possible values: [0.94-0.98]
    
    block_dim = 3; % Any odd number, but 3 is good choice.
    
    tic;
    corner_points = FindInterestPointsWithPruning(image_stack, sigma_array, alpha_val, block_dim, bP);
    size(corner_points);
    toc;
    
    if (isDisplay)
        show_corner_points(image_stack, corner_points);
    end
    
else
    threshold = 0;
    tic;
    corner_points = FindInterestPointsWithoutPruning(image_stack, sigma_array, bP, threshold);
    size(corner_points);
    toc;
    
    if (isDisplay)
        show_corner_points(image_stack, corner_points);
    end
end

end