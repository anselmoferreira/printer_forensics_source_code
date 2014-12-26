function [PrtsAttrib, BinClassMatrix] = Test_SVM_multi(Models,test_file)  

	disp(['Testing file: ' test_file]);
	TestV = csvread(test_file);

	%PrtsAttrib é a classe predita
	%BinClassMatrix é o resultado de cada um dos 45 classificadores por frame

	%disp(size(TestV(:, 2:end)));
	%pause;	
	[PrtsAttrib, BinClassMatrix] = SVM_multipredict (Models, TestV(:, 2:end), 10);

end
