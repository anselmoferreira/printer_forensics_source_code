printer_forensics_source_code
==============================================================================================================================
This is the source codes of the technique presented in the paper 'laser printer attribution: exploring new features and beyond'
==============================================================================================================================

Here, the approach is performed on frames.

The codes in the root directory do the following:

-main.m=main routine, you should execute this and all the rest is done automatically. main.m calls the following functions:

	-test_feature_vector_generator.m=extracts the features of all the frames of all the documents. Every document will have the same number of feature vectors as its number of frames. The test feature vectors will be stored at feature_vectors/test_feature_vectors. The frame data (coordinates) of each document is present in info/frames_info_full.csv or info/frames_info_reduced.csv 

	-train_feature_vector_generator.m=concatenates vertically the feature vectors of documents to create the data used for the training of the classifier. It uses the information of the 5x2 cross validation data present in info/5x2_data.csv

	-classifica.m= trains the data of the i-th fold and test the data of the i-th fold according to the data in info/5x2_data.csv 

	-vota.m= does the voting of each classified frame to decide the class of the document.

	-write_confusion_matrix.m=writes the confusion matrix of the i-th fold.

	-calcula_acuracia_media.m=calculates the mean accuracy according to the 10 confusion matrices calculated

 
