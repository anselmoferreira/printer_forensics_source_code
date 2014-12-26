function vota(arquivo_resultado_por_documento, arquivo_resultado_fold)

dataset=load(arquivo_resultado_por_documento);

%vejo quem o classificador mais previu, esse vai ser a classificação do
%documento, já que no GLCM a classificação se dá por votação de caracteres
most_frequent=mode(dataset);

dlmwrite(arquivo_resultado_fold, most_frequent, '-append');


end
