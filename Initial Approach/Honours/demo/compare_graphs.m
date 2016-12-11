function [] = compare_graphs(video_no1,video_no2)
    [graph1,c1] = graph_making(video_no1);
    [graph2,c2] = graph_making(video_no2);
%     plot1 = [c1(1:end-1),c1(2:end)]
%     size(plot1)
%     plot(plot1(1,:),plot1(2,:),'ro')
    G1 = digraph(graph1);
    G2 = digraph(graph2);
    subplot(1,2), plot(G1);;
    subplot(1,1),plot(G2);
end