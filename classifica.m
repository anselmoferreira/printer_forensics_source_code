function classifica(fold)

%adiciona no path a nossa implementação do svm one-versus-one
addpath('SVM_multi_Matlab');

%abro a tabela para saber quem vai ser o test do fold informado
dataset=importdata('info/5x2_data.csv');

%como dito antes, a função do arquivo na tabela de folds começam da terceira coluna (para fold 1) e décima segunda coluna (para fold 10)
%documentos com código 1 é treino.
%documentos com código 2 é validação.
%documentos com código 3 é teste.
%testes são aqueles que tem o código 3, código 2 é validação, portanto não é usado.
[x,~]=find(dataset.data(:,fold+2)==3);

%x+1 é porque nossa tabela tem os campos de cabeçalho. Não queremos eles, certo?
document=dataset.textdata(x+1,1);

%nome do arquivo de treino
arquivo_treino=['feature_vectors/train_feature_vectors/fold' int2str(fold) '.txt'];

disp('--- Training ---');
%lê o arquivo e treino.
TrainV = csvread(arquivo_treino);
%treina o svm multiclasse one-versus-one.   
Models = SVM_multitrain (TrainV(:, 2:end), TrainV(:, 1), 10);
%número de documentos sem frames válidos.
num_noexist=0;

%legal, vamos ler, testar e calcular estatísticas 
for i=1:size(document,1)
    
	
        	%aqui é apenas para pegar o arquivo de feature vectors nome.txt ao invés de nome.tif como está na tabela csv
        	name=char(document(i,1));
        	index=strfind(name,'.');
        	new_name=[name(1,1:index-1) '.txt'];
		
        	%verifica se arquivo de teste existe, ou seja, se o documento de teste possui frames válidos
        	if exist(['feature_vectors/test_feature_vectors/' new_name ],'file')
 	
			%testa e grava o arquivo predict somente desse arquivo de teste
			%nome do arquivo de teste        
        		arquivo_teste=['feature_vectors/test_feature_vectors/' new_name];
			%testa e grava a classificação da variável PrtsAttrib em um arquivo .predict
			PrtsAttrib = Test_SVM_multi(Models, arquivo_teste);  
			dlmwrite([new_name '.predict'], PrtsAttrib);        	

        		%acumula o ground truth desse teste em um arquivo de groundtruths de testes para o fold
			%lê o arquivo de teste 
        		vetor=dlmread(['feature_vectors/test_feature_vectors/' new_name]);
			%o primeiro
        		classe=vetor(:,1);
                        dlmwrite(['fold' int2str(fold) '.groundtruth'], mode(classe), '-append');        
        
        		%faz a votação por caractere (ou frame) no arquivo de teste e escreve em arquivo a decisão final
        		vota([new_name '.predict'], ['fold' int2str(fold) '.predictfinal']);
		end

		if exist(['feature_vectors/test_feature_vectors/' new_name ],'file')==0
			disp(['Não existe feature_vectors/test_feature_vectors/' new_name ]);
			num_noexist=num_noexist+1;
		end 
end
disp(['Não existem ' int2str(num_noexist) ' arquivos para esse fold']);
disp(['Escrevendo a matriz de confusão para o fold ' int2str(fold)]);
write_confusion_matrix(['fold' int2str(fold) '.predictfinal'], ['fold' int2str(fold) '.groundtruth'], ['fold' int2str(fold) '.csv']);
disp('terminado');
system('rm -rf *.predict');
end
