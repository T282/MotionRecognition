%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This function shows a way to apply temporal constraint in
% the pruned interest point using 1D Gabor filter in the temporal
% direction.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cornerPoint = temporalConstraint(imageStack, cornerPoint, gP, temporalScale)

  % Margin
  c = 20;
  [row col depth] = size(imageStack);

  % Temporal constraint
  imageStackN = imageStack;
  for iCount = 1 : temporalScale
    % Border-padding for garbor filtering
    imageStackN = cat(3, imageStack(:, :, 1), imageStackN, imageStack(:, :, end));
  end

  [gaborResponse, gaborThreshold] = gaborResponse1D(imageStackN, temporalScale, gP);
  
  clear imageStackN;
  clear imageStack;
  
  for frameCount = 1 : depth
    gRFrame = gaborResponse(:, :, frameCount);
    cP = cornerPoint{frameCount};
    cP = cP(((cP(:, 1) > c) & (cP(:, 1) < (row - c)) & (cP(:, 2) > c) & (cP(:, 2) < (col - c))), :);
    if(~isempty(cP))
    
        index = sub2ind([row col], cP(:, 1), cP(:, 2));
    
        gRCP = gRFrame(index);
        indexGR = (gRCP > gaborThreshold);
        cornerPoint{frameCount} = cP(indexGR, :);
    end
  end
  cornerPoint = cell2mat(cornerPoint);
return;