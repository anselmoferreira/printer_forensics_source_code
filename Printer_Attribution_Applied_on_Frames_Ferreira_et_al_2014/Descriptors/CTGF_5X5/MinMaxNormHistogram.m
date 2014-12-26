function HN = MinMaxNormHistogram (Hist, dl, dh)
                              
% Input check to avoid input errors propagation and wrong use.
if ~isvector(Hist);
    error('Input must be a vector');
end

nc = numel(Hist);

if dl >= (nc / 2) || dh >= (nc / 2)   
    error('dl and dh - discarded itens to calculate normalization factor should be less than half size of vector');
end

% Generate Texture Codes Histogram vector
H = double(Hist(:));
minht = min(H(1+dl : end-dh));
maxht = max(H(1+dl : end-dh));
if minht == maxht;
    sclht = 1;
else
    sclht = 1 / (maxht - minht);
end
HN = (H - minht) * sclht;

end
