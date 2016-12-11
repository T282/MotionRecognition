%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This function computes Harris interest point from an image
% frame. It applies a pruning technique to keep the interest points
% more on the foreground objects.
% @params : im : image frame
%           sigma_val : Spatial scale
%           alpha_val : Pruning coefficient
%           block_dim : Pruning mask size 
%
% @output: corner_points : Coordinate of the corner point
%          cS : Corner strength
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [corner_points, cS] = harrisCornerWithPruning(im, sigma_val, alpha_val, block_dim)

  if (size(im, 3) > 1)
    im = double(rgb2gray(im));
  else
    im = double(im);
  end
  % Converting all the image pixel value between [0, 1]
  if (max(max(im)) > 1)
    im = im / 255.0;
  end
  % Derivative masks
  dx = [-1 0 1; -1 0 1; -1 0 1];
  dy = dx';

  % Image derivatives
  Ix = conv2(im, dx, 'same');
  Iy = conv2(im, dy, 'same');

  theta = atan2(Iy, Ix);

  g = fspecial('gaussian',max(1,fix(6.0 * sigma_val)), sigma_val);

  % Smoothed squared image derivatives
  Ix2 = conv2(Ix.^2, g, 'same');
  Iy2 = conv2(Iy.^2, g, 'same');
  Ixy = conv2(Ix.*Iy, g, 'same');

  % Eign value computation using matrix operation
  traceMat = (Ix2 + Iy2);
  detMat = ((Ix2 .* Iy2) - (Ixy.* Ixy));

  eignVal1 = 0.5 * (traceMat + sqrt((traceMat .* traceMat) - 4*(detMat)));
  eignVal2 = 0.5 * (traceMat - sqrt((traceMat .* traceMat) - 4*(detMat)));

  mainEignVal = eignVal1.^2 + eignVal2.^2;
  cim = mainEignVal;

  [r, c] = inhibitCornerFast(cim, theta, block_dim, alpha_val);

  if(~isempty(r))
    corner_points = [r c];
    
    % Removing unwanted interest points in the border of the frames. The 
    % border margin is definded by the variable CONSTANT.
    
    CONSTANT = 5;
    corner_points = corner_points(((r > CONSTANT) & (r < (size(im, 1) - CONSTANT)) ...
                      & (c > CONSTANT) & (c < (size(im, 2) - CONSTANT))), :);
    
    cS = zeros(size(im, 1), size(im, 2));
    cS(sub2ind(size(im), corner_points(:, 1), corner_points(:, 2))) = cim(sub2ind(size(im), corner_points(:, 1), corner_points(:, 2)));
  else
    corner_points = [];
    cS = [];
  end
  
return;