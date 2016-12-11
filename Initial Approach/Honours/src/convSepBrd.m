%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : Convolve along colums + along rows with repetition of the
%                border.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g = convSepBrd(f, w1, w2)
  
  N = size(f,1);
  M = size(f,2);
  K = (size(w1(:),1)-1)/2;
  L = (size(w2(:),1)-1)/2;
  iind = min(max((1:(N+2*K))-K,1),N);
  jind = min(max((1:(M+2*L))-L,1),M);
  fwb = f(iind,jind);
  g=conv2(w1,w2,fwb,'valid');
  
return;