function [AttribClasses, BinClassResultMat] = SVM_multipredict (ClassifierModels, TestVec, nprts)

nclsf = nchoosek (nprts, 2);
[nv_tst, ~] = size(TestVec);

% Test Results of Binary Classifiers
BinClassResultMat  = zeros(nv_tst, nclsf);

% Test for each classifier
i = 0;
for prt1 = 1 : (nprts - 1);
    
    for prt2 = (prt1 + 1) : nprts;
        i = i + 1;
        
        %disp(['    Testing classifier for p1=', num2str(prt1), ', p2=', num2str(prt2)]); % just for Debug

%	disp(ClassifierModels(i));
%	pause;
        
        % Classifiers Test
%	disp(TestVec);
%	disp(size(TestVec));
%	pause;
        TestAttribBin = svmclassify(ClassifierModels(i), TestVec);

        % SVM Test classification - results
        BinClassResultMat (TestAttribBin ==  1  , i) = prt1;
        BinClassResultMat (TestAttribBin ==  -1 , i) = prt2;
        
        clearvars TestAttribBin
               
    end
    
end




% Attributed Classes
AttribClasses = mode(BinClassResultMat, 2);

end
