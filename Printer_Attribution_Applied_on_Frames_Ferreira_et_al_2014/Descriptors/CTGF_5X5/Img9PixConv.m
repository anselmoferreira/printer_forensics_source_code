function [H_Conv, I_Conv] = Img9PixConv (I, ConvMatrix)

% Contant values, all constant value names begin as "C_" following by CAPS
C_WHITE = 255; % Constant value for white color
                                    
% Input check to avoid input errors propagation and wrong use.
if ~ismatrix(I);
    error('Input must be a matrix of grayscale pixels - it is not integer');
end
if ~isa(I, 'single');
    error('Input must be a matrix of grayscale pixels - it is not single');
end
if max(I(:)) > C_WHITE;    
    error('Input must be a matrix of grayscale pixels - There is(are) element(s) > 255');
end

% Check convolution matrix
[nrconv, ncconv] = size(ConvMatrix);
if nrconv ~= ncconv;
    error('Convolution Matrix should be less a square matrix');
end
convmaxv = sum(sum(ConvMatrix * 255));

% Convolute Coding Matrix
I_Conv = conv2(I, ConvMatrix, 'same');

% Generate Histogram vector
bins = 0:convmaxv;                        
H_Conv = histc(I_Conv(:), bins);

end

