%acha feature vectors de teste
%na verdade calcula-se os feature vectors de tudo de uma vez
%depois vou concatenar eles para criar os feature vectors de treino
disp('Passo 1: vou calcular os feature vectors de cada um dos frames de cada documento']);
test_feature_vector_generator();
disp('Feature vectors de todos os arquivos calculados com sucesso');

%agora vou concatenar os feature vectors para treino dos 10 folds, usando uma tabela de arquivos de treino por fold. 
disp(['Passo 2: vou concatenar feature vectors de documentos de cada treino de cada fold']);
train_feature_vector_generator();
disp('feature vectors de treino calculados');

%com feature vectors individuais de cada arquivo gravados e os concatenados para criar treino, vou classificar. 
%aqui ele classifica usando NOSSA implementação do svm one-versus-one usando o svm stats do matlab.
%no fnal ele gera arquivos .csv, que são matrizes de confusão por fold
disp('Classificando');
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
disp('Matrizes de confusão calculadas');

%calcula a acurácia média usando os arquivos .csv dos 10 folds 
media = calcula_acuracia_media()
