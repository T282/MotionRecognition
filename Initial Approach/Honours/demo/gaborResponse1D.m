%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This functions implements 1D Gabor filter.
% @params : imageStack, (M X N X T) matrix on which Gabor filter will be
%           applied.
%           temporalScale, Gabor filter frequency window on temporal scale.
%           gP, Parameter to compute Gabor threshold.
% @output : gR, Gabor filter response.
%           gaborThreshold, Threshold value on the Gabor filter response.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gR, gaborThreshold] = gaborResponse1D(imageStack, temporalScale, gP)

  [row col depth] = size(imageStack);
  % Gabor filter using Dollar's toolbox

  [fe fo] = filterGabor1d(2*temporalScale, temporalScale, (temporalScale + 1)/(2*(2*temporalScale + 1)));

  gR = zeros(row, col, depth);


  depthInd = 1;
  for rowCount = 1 : row
    for colCount = 1 : col
        temp = double(imageStack(rowCount, colCount, :));
        temp = reshape(temp, 1, []);
        tempE = convnFast(temp, fe, 'same');
              
        tempO = convnFast(temp, fo, 'same');
       
        tempA = (tempE.*tempE + tempO .* tempO);
           
        tempA = reshape(tempA, [1 1 length(tempA)]);
        gR(rowCount, colCount, :) = tempA;
        depthInd = depthInd + 1;
    end
  end

  gR = gR(: ,:, temporalScale + 1 : end-temporalScale);

  tmp = sort(gR(:));
  gaborThreshold = tmp(max(floor(numel(gR)*gP), 1));
return;