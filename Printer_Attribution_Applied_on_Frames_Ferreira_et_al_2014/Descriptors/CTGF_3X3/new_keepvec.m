function [KeepFrmVec]=new_keepvec(FrmTrainVec)
	FrmTrainMid = max(FrmTrainVec) - min(FrmTrainVec);
	%elimina valores zero na subtração entre máximo e mínimo
	NonZeroMid = FrmTrainMid > 0;
	%calcula a média                                          
	kmin = mean(FrmTrainMid(NonZeroMid));                        
	% Seleciona as componentes onde a distancia (max – min) são maiores ou iguais a media.
	KeepFrmVec = FrmTrainMid >= kmin;                                 
	%n_vec = sum(KeepFrmVec);
end
