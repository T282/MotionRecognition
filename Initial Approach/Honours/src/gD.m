%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This functions implements Gaussian derivative operation.
% @params : f, matrix on which Gaussian derivative will be applied.
%           scale, scale of the Gaussian
%           ox, oy : Mask dimension 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g = gD(f, scale, ox, oy)
  % Gaussian (Derivative) Convolution
  K = ceil(3 * scale);
  x = -K : K;
  Gs = exp(- x.^2 / (2*scale^2));
  Gs = Gs / sum(Gs);
  Gsx = gDerivative(ox, x, Gs, scale);
  Gsy = gDerivative(oy, x, Gs, scale);
  g = convSepBrd(f, Gsx, Gsy);
return;

function r = gDerivative(order, x, Gs, scale)
  switch order
    case 0
        r = Gs;
    case 1
        r = -x/(scale^2) .* Gs;
    case 2
        r = (x.^2-scale^2)/(scale^4) .* Gs;
    otherwise
        error('Only derivatives up to second order are supported');
  end
return;