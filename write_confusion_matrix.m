function write_confusion_matrix(predict_file, groundtruth_file, table_name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
predict=load(predict_file);
groundtruth=load(groundtruth_file);

confusion=zeros(10,10);

for i=1:size(predict)

    confusion(groundtruth(i,1), predict(i,1))=confusion(groundtruth(i,1), predict(i,1))+1;

end

disp(confusion);
disp(size(confusion));
dlmwrite(table_name,confusion);

end
