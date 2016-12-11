%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [points fCS] = blobDetector(image, cP, cS, sigmaArray, bT)

  [r c d] = size(image);
  if(d ~= 1)
    image = rgb2gray(image);
  else
    image = double(image);
  end
  if (max(max(image)) > 1)
    image = image / 255.0;
  end
  
  blobStrength = zeros(r, c, length(sigmaArray));
  cornerStrength = zeros(r, c, length(sigmaArray));

  for iCount = 1 : size(sigmaArray, 1)
    if(~isempty(cP{iCount}))
      smoothXX = gD(image, sigmaArray(iCount, 1) * 6, 2, 0);
      smoothYY = gD(image, sigmaArray(iCount, 1) * 6, 0, 2);
   
      bS = sigmaArray(iCount)^2 * (smoothXX + smoothYY);
      
      index = sub2ind([r c], cP{iCount}(:, 1), cP{iCount}(:, 2));
      
      map = zeros(r, c);
      map(index) = 1;
      bS = bS .* map;
      
      [v p] = sort(bS(:), 'descend');
      
      bS(p(round(numel(v) * bT) + 1 : end)) = 0;
      blobStrength(:, :, iCount) = bS;
      
      cS{iCount}(p(round(numel(v) * bT) + 1 : end)) = 0;
      cornerStrength(:, :, iCount) = cS{iCount};
    end
  end

  [blobStrength s] = max(blobStrength, [], 3);

  % Find the point with non-zero responses and assign it with the sigma values
  % corresponding to the highest response. 
  scale = sigmaArray(s(blobStrength > 0)) * 6;
  [x y] = find(blobStrength > 0);
  points = [x y scale];

  fCS = zeros(r, c);
  p = s(blobStrength > 0);

  fCS(sub2ind([r c], x, y)) = cornerStrength(sub2ind(size(cornerStrength), x, y, p));
return;