function test_feature_vector_generator(technique)

%aqui é para mostrar um exemplo de descritor, o CTGF que apresentamos no nosso paper.
switch technique
    case 'CTGF3X3'
        addpath('Descriptors/CTGF_3X3');
	keepvec=load('keepvec.dat');
    case 'CTGF5X5'
	addpath('Descriptors/CTGF_5X5');
	keepvec=load('keepvec.dat');
    case 'CTGF7X7'
        addpath('Descriptors/CTGF_7X7');
	keepvec=load('keepvec.dat');
    case 'GLCM_MD'
        addpath('Descriptors/GLCM_MD');
	 offsets = {[0 1], [-1 1], [-1 0], [-1 -1], ...
                       [0 -1], [1 -1], [1 0], [1 1]};
    case 'GLCM_MD_MS'
        addpath('Descriptors/GLCM_MD_MS');
	 offsets = {[0 1], [-1 1], [-1 0], [-1 -1], ...
                       [0 -1], [1 -1], [1 0], [1 1]};
end

%Lê a tabela de frames 
dataset=importdata('info/frames_info_full.csv');

%nessa tabela, usam-se identificadores (números inteiros) para impressoras fonte, língua do documento, se tem figura ou não e o identificador do documento.
%Esses vetores aqui vou usar para encontrar o documento em breve, usando os identificadores da tabela.
printers=['B4070'; 'C1150'; 'C3240'; 'C4370'; 'H1518'; 'H225A'; 'H225B'; 'LE260'; 'OC330' ; 'SC315'];
language=['I';'P'];
with_figure=['C';'S'];
number=['01'; '02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22'; '23'; '24'; '25'; '26'; '27'; '28'; '29'; '30'];
printers = cellstr(printers);
language=cellstr(language);
with_figure=cellstr(with_figure);
number=cellstr(number);

%Vou percorrer linha por linha dessa tabela de frames. Cada linha tem os dados do frame do documento corrente.
%Dados de frames do mesmo documento sempre são colocados em sequência (um abaixo do outro). Depois do último dado de frame de um documento
%começam os dados dos frames do outro documento.
 
for i=1:size(dataset,1) 
    
	%pego o endereço de onde está o documento do documento, colunas 1 a 4 da tabela ajudam nessa informação      
	image_file=strcat('/datasets/anselmo/printer_full_dataset/', printers(dataset(i,1)), language(dataset(i,2)+1), '/',printers(dataset(i,1)),language(dataset(i,2)+1),with_figure(dataset(i,3)+1),number(dataset(i,4)),'.tif');

	%crio uma string com o nome do arquivo de texto que vai gravar os feature vectors
	%a extensão é .txt
	%a figura imagem.tif terá seu feature vector gravado em imagem.txt
	document_name= strcat('feature_vectors/test_feature_vectors/',printers(dataset(i,1)),language(dataset(i,2)+1),with_figure(dataset(i,3)+1),number(dataset(i,4)),'.txt');

	%leio a imagem inteira, para começar a extrair os frames.
	tif_image=imread(char(image_file));

	%vou extrair o i-ésimo frame.
	%na tabela, coordenadas de 2 pontos do frame são informados da coluna 5 até a coluna 8 
	x_frame_initial=dataset(i,5);
	x_frame_final=dataset(i,6);
	y_frame_initial=dataset(i,7);
	y_frame_final=dataset(i,8);

	%com essas coordenadas, vou extrair somente o i-ésimo frame da imagem.
	frame=tif_image(x_frame_initial:x_frame_final,y_frame_initial:y_frame_final);

	%extraio as features do frame
        %if CTGF variations are chosen

        if (strcmp(technique,'CTGF3X3')==0) 
		addpath('Descriptors/CTGF_3X3');
		keepvec=load('keepvec.dat');
		feature_vector=GTFG_GetFeatVec(single(frame), 1, 32);
		feature_vector=feature_vector(:,find(keepvec==1));
	end

	if (strcmp(technique,'CTGF5X5')==0) 
		
		addpath('Descriptors/CTGF_5X5');
		keepvec=load('keepvec.dat');        
		feature_vector=GTFG_GetFeatVec(single(frame), 1, 32);
		feature_vector=feature_vector(:,find(keepvec==1));
	end

	if (strcmp(technique,'CTGF7X7')==0) 
        
		addpath('Descriptors/CTGF_7X7');
		keepvec=load('keepvec.dat');
		feature_vector=GTFG_GetFeatVec(single(frame), 1, 32);
		feature_vector=feature_vector(:,find(keepvec==1));
	end


	if (strcmp(technique,'GLCM_MD')==0)

		 addpath('Descriptors/GLCM_MD');
	 offsets = {[0 1], [-1 1], [-1 0], [-1 -1], ...
                       [0 -1], [1 -1], [1 0], [1 1]};
		parfor k = 1:length(offsets)
                	features{k}  = extract_features_glcm(frame, offsets{k});
		end
		
		feature_vector = cell2mat(features);
	end

	if (strcmp(technique,'GLCM_MD_MS')==0)

		 addpath('Descriptors/GLCM_MD_MS');
	 offsets = {[0 1], [-1 1], [-1 0], [-1 -1], ...
                       [0 -1], [1 -1], [1 0], [1 1]};

		features = cell(1, 32); % 4 scales * 8 directions/scale
            	scaledown = impyramid(frame, 'reduce');
            	pyramid = {impyramid(frame, 'expand'); frame; 
            	scaledown; impyramid(scaledown, 'reduce')};
            	clear scaledown frame;
            
            	for l = 1:length(pyramid)
                
                	% Calculate the feature vector for each orientation
                	for k = 1:length(offsets) % PARFOR!
                    		features{8*(l-1) + k}  = extract_features_glcm(pyramid{l}, offsets{k});
                 	end
           	end
            
            	% Each line is an observation, each column, a feature
            	feature_vector = cell2mat(features);
	end

	

        %grava as features em um arquivo de texto.
	%a classe da impressora fonte do i-ésimo documento está na primeira coluna 
	dlmwrite(char(document_name), horzcat(dataset(i,1),feature_vector), '-append');

end
