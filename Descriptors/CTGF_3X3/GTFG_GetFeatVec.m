function FiltConvH = GTFG_GetFeatVec(Img, glow, ghigh)
% GTFG_GetFeatVec, generate Convolution histogram[glow:ghigh] of Img
% Img should be an Grayscale Image (single, 0 to 255 pixels, 0 = black
% glow, ghigh = gradient filter parameters glow <= valid pixels <= ghigh

C_WHITE = 255;                              % Constant value for white color

% Consistency checks to guarantee function results
if ~ismatrix(Img);
    error('Input must be a matrix of grayscale pixels - it is not matrix');
end
if ~isa(Img, 'single');
    error('Input must be a matrix of grayscale pixels - it is not single');
end
if (max(Img(:)) > 255) || (max(Img(:)) < 0)
    error('Input must be a matrix of grayscale pixels - There is(are) element(s) > 255');
end

if (glow > C_WHITE) || (ghigh > C_WHITE);
    error('Input thresholds should be less than white color value');
end
if (glow > C_WHITE) || (ghigh > C_WHITE);
    error('Input thresholds should be less than white color value');
end

% Check convolution matrix
% Create Convolution Matrix
ConvMat = ones(3, 3);
convmaxv = sum(sum(ConvMat * 255));

% Negative Image for white equals 0
N = C_WHITE - Img;

% Compute Gradient
[~, GradImg] = Img9PixGrad(N);
GradImg( 1 , : )   = 0;
GradImg( end , : ) = 0;
GradImg( : , 1 )   = 0;
GradImg( : , end ) = 0;

% Eliminate Pixels that are out of scope
% Low Gradient (plain areas) and High Gradient (borders)
GRAD_LOW  = GradImg < glow;
GRAD_HIGH = GradImg > ghigh;
N_WHITE   = N == 255;

% Compute Image Convolution
[~, ConvImg] = Img9PixConv(N, ConvMat);

% Eliminate Pixels that are out of scope
% Low Gradient (plain areas) and High Gradient (borders)
FiltConv = ConvImg;
FiltConv(GRAD_LOW)  = 0;     % Eliminate codes from pixels that are <= GRAD_LOW
FiltConv(GRAD_HIGH) = 0;     % Eliminate codes from pixels that are >= GRAD_HIGH
FiltConv(N_WHITE)   = 0;     % Eliminate codes from pixels those central is White

% Compute Filtered Convolution histogram
I_Code = FiltConv(FiltConv(:) > 0);
codes = 0:convmaxv;                 
FConvH = histc(I_Code, codes);
FiltConvH = transpose(MinMaxNormHistogram (FConvH, 1, 1));

end


