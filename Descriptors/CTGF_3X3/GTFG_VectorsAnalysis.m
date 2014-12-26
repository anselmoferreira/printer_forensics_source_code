function [KeepVec, n_vec] = GTFG_VectorsAnalysis(ImgTrainMat, kmin)

KeepVec = max(ImgTrainMat) >= kmin;
n_vec = sum(KeepVec);

end
