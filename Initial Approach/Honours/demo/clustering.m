function clustering()
    files = dir('videos_train');
    dirFlags = [files.isdir];
    subFolders = files(dirFlags);
    all_actums = [];
    actum_class = [];
    all_actums = double(all_actums);
    actum_class = double(actum_class);
    vidno = 1;
    vidnos = [];
    for k = 3 : 7
        name = strcat('videos_train/',subFolders(k).name, '/*.avi');
        list = dir(name);
        num = 0;
        m = 20;
        while num<50
            nn = strcat('videos_train/',subFolders(k).name, '/', list(m).name);
            st = strsplit(nn,'#');
            if size(st)==1
                [k,m,num]
                set_of_actums = demo_interest_point_wo_pruning(0,nn,subFolders(k).name);
                all_actums = cat(1,all_actums,set_of_actums);
                vidnos = cat(2,vidnos,vidno*ones(1,size(set_of_actums,1)));
                vidno = vidno+1;
                actum_class = cat(2,actum_class,(k-2)*ones(1,size(set_of_actums,1)));
                [k,m,num]
                num = num+1;
            end
            m = m+1;
        end
    end
    save('files.mat');
%     load('files.mat');
    clustering_helper(all_actums,actum_class,vidnos);
end

function correctly_clustered = clustering_helper(videos,class_of_video,vidnos)
    class_of_video = class_of_video(1,:);
    number_of_clusters = 500;  %number of cluster that we want to divide the videos
    videos = double(videos);
    [cluster_number,C] = kmeans(videos,number_of_clusters);
    save('clustered.mat');
    number_of_class = 51;
    percentage_ith_class_jth_cluster = double(zeros(number_of_clusters,number_of_class));
    number_of_elements_ith_cluster = hist(cluster_number,number_of_clusters);
    for i=1:length(videos)
        percentage_ith_class_jth_cluster(cluster_number(i),class_of_video(i))...
            = percentage_ith_class_jth_cluster(cluster_number(i),class_of_video(i))+1;
    end
    no_of_videos = 51*5;
    vid_histo = zeros(no_of_videos,number_of_clusters+1);
    i = 1;
    while i<length(videos)
        D = pdist2(videos(i,:),C,'euclidean');
        [mi, inde] = min(D);
        vid_histo(vidnos(i),inde) = vid_histo(vidnos(i),inde)+1;
        i = i+1;
    end
    for i=1:number_of_clusters
        if number_of_elements_ith_cluster~=0
            for j=1:number_of_class
                percentage_ith_class_jth_cluster(cluster_number(i),class_of_video(j))...
                = percentage_ith_class_jth_cluster(cluster_number(i),class_of_video(j))...
                /number_of_elements_ith_cluster(i);
            end
        end
    end
%% for creating file    
%     fileID = fopen('exp.txt','w');
%     names = [number_of_clusters,20];
%     for i=1:number_of_clusters
%         [val, indi] = sort(percentage_ith_class_jth_cluster(i,:));
%         percentage_ith_class_jth_cluster(indi(:));
%         top_three(i,:) = indi(49:51);
%         ind = 51;
%         fprintf(fileID,'%d\t',i);
%         while val(ind)>0
%             fprintf(fileID,'%s\t',subFolders(indi(ind)+2).name);
%             ind=ind-1;
%         end
%         fprintf(fileID,'\n');
%         i
%     end
%     fclose(fileID);
end