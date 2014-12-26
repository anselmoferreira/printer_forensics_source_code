function train_feature_vector_generator(technique)

%aqui é para mostrar um exemplo de descritor, o CTGF que apresentamos no nosso paper.
switch technique
    case 'CTGF3X3'
        addpath('Descriptors/CTGF_3X3');
    case 'CTGF5X5'
	addpath('Descriptors/CTGF_5X5');
    case 'CTGF7X7'
        addpath('Descriptors/CTGF_7X7');
    case 'GLCM_MD'
        addpath('Descriptors/GLCM_MD');
    case 'GLCM_MD_MS'
        addpath('Descriptors/GLCM_MD_MS');
end

%importa o dataset
%depois de importados, existem 2 estruturas de dados
%data são dados numéricos
%textdata são dados de texto

dataset=importdata('info/5x2_data.csv');

%vou procurar no dataset quem são os documentos de treino
%Percorre as 10 colunas na tabela data, da terceira à décima segunda
%essas colunas contêm quem é quem para cada um dos 10 folds

%para cada fold 
for i=3:12
        %procuro quem é treino
        %pego coordenadas da linha de quem é treino
        [x,~]=find(dataset.data(:,i)==1);
        %pego os dados desses documentos
        document=dataset.textdata(x+1,1);
        
        %pego os dados do primeiro documento para criar o nome do documento de feature
	%que vou ler e depois usar para concatenar
        name=char(document(1,1));
        index=strfind(name,'.');
        new_name=name(1,1:index-1);
        %com os dados do documento, vamos ler o primeiro documento de
        %treino
        vector=dlmread(['feature_vectors/test_feature_vectors/' new_name '.txt']);
        
        %agora vamos ler o resto e concatenar
         for j=2:size(document,1)       
                name2=char(document(j,1));
                index2=strfind(name2,'.');
                new_name2=[name2(1,1:index2-1) '.txt'];

		disp(new_name2);

		if exist(['feature_vectors/test_feature_vectors/' new_name2 ],'file') 
                	vector2=dlmread(['feature_vectors/test_feature_vectors/' new_name2 ]);
                	vector=vertcat(vector,vector2);           
        	end

		if exist(['feature_vectors/test_feature_vectors/' new_name2 ],'file')==0
			disp(['File ' new_name2 ' has no frames']);
		end
         end
         
         dlmwrite(['feature_vectors/train_feature_vectors/fold' int2str(i-2) '.txt'], vector);    
end
end
