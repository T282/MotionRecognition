%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This function displays the content of the image_stack
%                along with the corner points in each frame.
% @params : image_stack, (M X N X T) matrix, which is comming from a video
%           of frame size (M X N) with T frames.
%           corner_points, (No_corner_point X 4) matrix. 4 columns
%           represent X, Y coordinate of the Corner point, Frame number, Scale 
% @author: Bhaskar Chakraborty.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function show_corner_points(image_stack, corner_points)
n = figure();
for i = 1 : size(image_stack, 3)
    im = image_stack(:, :, i);
    points = corner_points(corner_points(:, 3) == i, 1 : end);
    figure(n);
    imshow(im);
    hold on;
    plot(points(:, 2), points(:, 1), 'r*');
    drawnow
end
close(n);