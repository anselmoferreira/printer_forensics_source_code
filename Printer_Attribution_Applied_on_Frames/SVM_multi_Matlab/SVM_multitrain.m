function ClassifierModels = SVM_multitrain (TrainVec, TrainClasses, nprts)

nclsf = nchoosek (nprts, 2);

% Training each bynary classifier
i = 0;
for prt1 = 1 : (nprts - 1);
    
    for prt2 = (prt1 + 1) : nprts;
        i = i + 1;
        
        disp(['    Training classifier for p1=', num2str(prt1), ', p2=', num2str(prt2)]); % just for Debug
        
        % Load data for selection
        TrainBin = TrainClasses;
        TrainData = TrainVec;
        
        % Select Data for bynary classifier
        TrainBin(and((TrainBin ~= prt1), (TrainBin ~= prt2))) = 0;
        TrainBin(TrainBin == prt1) = 1;
        TrainBin(TrainBin == prt2) = -1;
        TrainData(TrainBin == 0, :) = [];
        TrainBin(TrainBin == 0)  = [];
        
        % Classifier Training
	%there are parameter changes for some techniques for helping in the convergence
	%the techniques are:
	%LBP for character
	%GLCM multiscale and Multidirectional for character
	%the values used were tolkkt=0.5 e kktviolationlevel=0.1
	%the default values used here were tolkkt=0.1 and kktviolationlevel=0 for all the other techniques	
	
        optSVM = statset('MaxIter', 1000000);

	%Please use these parameters for techniques which not converge (GLCM_MD_MS_C for example)
        %SVMtrainModel = svmtrain(TrainData, TrainBin, 'kernel_function', 'linear', ...
         %   'options', optSVM, 'tolkkt', 0.5, 'kktviolationlevel', 0.1);

	%These are the normal parameters
        SVMtrainModel = svmtrain(TrainData, TrainBin, 'kernel_function', 'linear', ...
        'options', optSVM, 'tolkkt', 0.01)

	
        
	if (i == 1);
            ClassifierModels = repmat(SVMtrainModel, nclsf, 1);
        else
            ClassifierModels(i) = SVMtrainModel;
        end
        
        % Free memory
        clearvars TrainData TrainBin SVMtrainModel
        
    end
    
end

end

