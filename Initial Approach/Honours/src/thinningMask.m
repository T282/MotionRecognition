%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This function applies a thechniques similar to non-maxima
% suppression of the pruned corner points.
% @params : inhibitCorner, Corner strength values after applying
%           the inhibition.
%           r, c : Pruned corner coordinates.
%           maskS : Thinning mask
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [r, c] = thinningMask(inhibitCorner, r, c, maskS)

  sI = (maskS - 1) / 2;

  startIndexH = 1 + (maskS - 1) / 2;
  startIndexW = 1 + (maskS - 1) / 2;

  newInhibit = zeros(size(inhibitCorner, 1) + (maskS -1), size(inhibitCorner, 2) + (maskS - 1));

  endIndexH = size(newInhibit, 1) - (maskS - 1)/2;
  endIndexW = size(newInhibit, 2) - (maskS - 1)/2;

  newInhibit(startIndexH : endIndexH, startIndexW : endIndexW) = inhibitCorner;
  clear inhibitCorner;

  [iX, iY] = ndgrid(-sI : sI, -sI : sI);

  iX = iX(:);
  iY = iY(:);

  maskIndX = repmat(iX', size(r, 1), 1);
  maskIndY = repmat(iY', size(c, 1), 1);

  imIndX = repmat((r+sI), 1, length(iX));
  imIndY = repmat((c+sI), 1, length(iY));

  imIndX = imIndX + maskIndX;
  imIndY = imIndY + maskIndY;

  clear maskIndX;
  clear maskIndY;

  temp = imIndX';
  imIndX = temp(:);

  temp = imIndY';
  imIndY = temp(:);

  clear temp;

  maxValMat = newInhibit(sub2ind(size(newInhibit), imIndX, imIndY));
  maxValMat = reshape(maxValMat, maskS*maskS, [])';

  [v p] = max(maxValMat, [], 2);
  clear v;
  r = r((p == ((size(maxValMat, 2) - 1) / 2) + 1));
  c = c((p == ((size(maxValMat, 2) - 1) / 2) + 1));

return;