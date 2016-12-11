%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This function computes framewise interest points from a
% video of dimension (M X N X T) without pruning operation.
% @params : image_stack, (M X N X T) matrix contains video frames
%           sigma_array, Scales at which interest points are detected.
%           threshold, Threshold on the corner point.
%           
% @output : corner_points, P X 4 matrix, where P is the number of interest
%           point found in the image_stack and each interest point contains
%           4 values :: [X,Y] coordinate of the interest point, frame
%           number, scale at which it is detected.
% @author : Bhaskar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function corner_points = FindInterestPointsWithoutPruning(image_stack, sigma_array, bP, threshold)

  depth = size(image_stack, 3);
  results = cell(depth, 1);

  noSigma = length(sigma_array);

  corner_strength = cell(noSigma, 1);
  for i = 1 : noSigma
    corner_strength{i} = zeros(size(image_stack, 1), size(image_stack, 2));
  end

  fCS = zeros(size(image_stack, 1), size(image_stack, 2), depth);

  % Computing the per frame interest point.
  for imCount = 1 : depth
    
    disp(imCount);
    
    tempResults = cell(noSigma, 1);
    for mCount = 1 : noSigma
      [tempResults{mCount} cS] = harrisCorner(image_stack(:, :, imCount), sigma_array(mCount), threshold);
      corner_strength{mCount} = cS;
    end
    % Blob detection
    [points fCS(:, :, imCount)] = blobDetector(image_stack(:, :, imCount), tempResults, corner_strength, sigma_array, bP);
    t = ones(size(points(:, 1), 1), 1) * imCount;
    % String the final interest points
    results{imCount} = [points(:,1) points(:, 2) t points(:, 3)];
  end

  corner_points = cell2mat(results);

return;