function [media] = calcula_acuracia_media()

diretorio=dir('*.csv');
acuracias=zeros(1,10);

for i=1:size(diretorio,1)
	matriz=load(diretorio(i).name);
	soma=0;
	total_matriz=sum(matriz(:));
	total_diagonal=0;
	
	for j=1:size(matriz,1)
		
		total_diagonal=total_diagonal+matriz(j,j);
	end
	acuracias(1,i)=total_diagonal/total_matriz;
end
	media=100*mean(acuracias);
end
