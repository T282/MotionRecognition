%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This function displays the content of the image_stack.
% @params : image_stack, (M X N X T) matrix, which is comming from a video
%           of frame size (M X N) with T frames.
% @author: Bhaskar Chakraborty.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function show_imstack(image_stack)
n = figure();
for i = 1 : size(image_stack, 3)
    im = image_stack(:, :, i);
    figure(n);
    imshow(im);
    drawnow
end
close(n);
