%acha feature vectors de teste
%na verdade calcula-se os feature vectors de tudo de uma vez
%depois vou concatenar eles para criar os feature vectors de treino

system('rm -rf *.csv');
system('rm -rf *.groundtruth');
system('rm -rf *.predictfinal');
system('rm -rf feature_vectors/test_feature_vectors/*.txt');
system('rm -rf feature_vectors/train_feature_vectors/*.txt');
clc;

result2 = input(sprintf('Choose the technique you want to use in the experiments... \n\n 1- Convolution Texture Gradient Filter with 3x3 window \n 2- Convolution Texture Gradient Filter with 5x5 window \n 3- Convolution Texture Gradient Filter with 7x7 window \n 4- GLCM Multidirectional \n 5- GLCM Multidirectional and Multiscale\n\nYour choose: '));


switch result2
    case 1
        technique='CTGF3X3';
    case 2
        technique='CTGF5X5';
    case 3
        technique='CTGF7X7';
    case 4
	technique='GLCM_MD';
    case 5
	technique='GLCM_MD_MS';
    otherwise
        error('This technique is not available');
end

disp(sprintf(['\nTechnique chosen by user: ' technique]));


disp(sprintf('\n\nStep 1: calculating feature vectors of each frame of each document'));
test_feature_vector_generator(technique);
disp('Feature vectors succesfully calculated');
%agora vou concatenar os feature vectors para treino dos 10 folds, usando uma tabela de arquivos de treino por fold. 
disp(['Step 2: concatenating feature vectors to create training feature vectors for each fold']);
train_feature_vector_generator(technique);
disp('train feature vectors succesfully concatenated');

%com feature vectors individuais de cada arquivo gravados e os concatenados para criar treino, vou classificar. 
%aqui ele classifica usando NOSSA implementação do svm one-versus-one usando o svm stats do matlab.
%no fnal ele gera arquivos .csv, que são matrizes de confusão por fold
disp('Step 3: Classifying data using the 5x2 cross validation approach');
classifica(1);
classifica(2);
classifica(3);
classifica(4);
classifica(5);
classifica(6);
classifica(7);
classifica(8);
classifica(9);
classifica(10);
disp('Confusion Matrices succesfully calculated');

%calcula a acurácia média usando os arquivos .csv dos 10 folds 
media = calcula_acuracia_media();
disp(['The mean accuracy for approach ' technique ' is ' num2str(media)]);

