function [graph,clustersforactum] = graph_making(video_no)
    load('files.mat');
    load('clustered.mat');
    actums_of_this_video = all_actums(vidnos == video_no,:);
    clustersforactum = zeros(size(actums_of_this_video,1),1);
    for i=1:size(actums_of_this_video,1)
       point = actums_of_this_video(i,:);
       distances = sqrt(sum(bsxfun(@minus, C, double(point)).^2,2));
       [~,clustersforactum(i)] = max(distances==min(distances));
    end
    graph = zeros(number_of_clusters,number_of_clusters);
    for i=1:size(clustersforactum,1) - 1
        graph(clustersforactum(i), clustersforactum(i + 1)) = 1;
    end

end
