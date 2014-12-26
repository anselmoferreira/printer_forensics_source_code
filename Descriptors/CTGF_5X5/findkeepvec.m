function keepvec= findkeepvec()

printers=['B4070'; 'C1150'; 'C3240'; 'C4370'; 'H1518'; 'H225A'; 'H225B'; 'LE260'; 'OC330' ; 'SC315'];
language=['I';'P'];
with_figure=['C';'S'];
number=['01'; '02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22'; '23'; '24'; '25'; '26'; '27'; '28'; '29'; '30'];

fv2=zeros(1,6376);
printers = cellstr(printers);
language=cellstr(language);
with_figure=cellstr(with_figure);
number=cellstr(number);

%importa o dataset
%depois de importados, existem 2 estruturas de dados
%data são dados numéricos
%textdata são dados de texto

dataset=importdata('../DatasetsExperimentsPlan.csv');

%vou procurar no dataset quem são os documentos para tunning de parâmetros
%Percorro a primeira coluna do experimento 0 e vejo quem é 1
%pego coordenadas da linha de quem é treino no experimento 0
[x,~]=find(dataset.data(:,3)==1);

%pego o nome de todos os documentos
document=dataset.textdata(x+1,1);
%pego o nome da impressora de todos os documentos
printer=dataset.textdata(x+1,2);

%para cada documento, pego seu nome, sua impressora, pesquiso esse nome na tabela de frames
frames_printer=importdata('../FrmDescriptors_F5f6.csv');

for i=1:size(document,1)    
	disp(['Documento ' int2str(i) ' de 711']);
	for j=1:size(frames_printer,1) 
	 	%agora que eu já abri o arquivo de frames, vou pesquisar o documento aberto. 
         	%tenho agora que abrir arquivo por arquivo e ver se ele é o mesmo do documento corrente
	  	document_name= strcat(printers(frames_printer(j,1)),language(frames_printer(j,2)+1),with_figure(frames_printer(j,3)+1),number(frames_printer(j,4)));
	 	indice=strfind(char(document(i,1)),'.');
         	document_name2=char(document(i,1));
         	document_name2=document_name2(1:indice-1);
		
         	%se for, pego os frames dele e calculo o feature vector
	 	if strcmp(document_name,document_name2)==1
			nome=strcat('/datasets/anselmo/printer_full_dataset/',printers(frames_printer(j,1)),language(frames_printer(j,2)+1),'/',document_name,'.tif');
            		tif_image=single(imread(char(nome)));
            		x_frame_initial=frames_printer(j,5);
			x_frame_final=frames_printer(j,6);
			y_frame_initial=frames_printer(j,7);
			y_frame_final=frames_printer(j,8);
		 	frame=tif_image(x_frame_initial:x_frame_final,y_frame_initial:y_frame_final);
            	 	fv=GTFG_GetFeatVec(frame, 1, 32);
			fv2=vertcat(fv2,fv);
         	end	
	end
end

%dlmwrite('sem_reducao.dat',fv2(2:end,:)); 
keepvec=new_keepvec(fv2(2:end,:));
dlmwrite('keepvec.dat',keepvec);
end
