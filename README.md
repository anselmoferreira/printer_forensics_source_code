printer_forensics_source_code
=============================

1. About the source code
=========================

This is the source code of the paper 'Laser Printer Attribution: Exploring New Features and Beyond', published by us in Forensics Science International.

This source code investigates banding signatures by exploring multidirectional and multiscale textures of printing 
material in digitalized versions of printed documents. These signatures are used to identify the laser printer 
source of a given document. We use SVM linear kernel classifiers to learn these signatures on a set of 
different printer models and brands. We show accuracies above 98%. 

If you want to know more about these technique you can find our paper at: http://dx.doi.org/10.1016/j.forsciint.2014.11.030

What do we proposed to laser printer attribution in this paper?

1- A multidirectional GLCM extension technique
2- A multidirectional/multiscale GLCM extension is proposed
3- A novel convolutional gradient texture filter
4- Realistic dataset, comprising 1,000+ Wikipedia documents is proposed for evaluation
5- Comparison to other techniques and other generalpurpose descriptors is performed

If you use this code in your research, please don't forget to cite us in your paper:

A. C. B. Ferreira, L. C. Navarro, G. Pinheiro, J. A. dos Santos, and A. R. Rocha. Laser Printer Attribution: 
exploring new features and beyond. Forensic Science International, 2015.

The dataset can be found at: http://www.recod.ic.unicamp.br/~anselmo/printer_forensics_dataset/

We are planning to upload ALL the source code used in GitHub. 

We will also translate the code and comments to english. Sorry, first time making source code available :-(

2. Classifier used
==================

Here we used our own implementation of the one-against-one linear kernel SVM classifiers using the 
matlab stats package. You can use Libsvm if you want, but this SVM is more accurate because there are some parameters
that are easier to set than in Libsvm (kktviolation in the training phase for example). 

Here, we don't use grid search on parameter C (we fixed it to 1). You can find even better results if you do a grid
search in this parameter. Remember that the matlab implementation of the svm is based on Libsvm, so there is not a 
problem using our matlab. The version of the Matlab used is Matlab 2012.  

3. How the source code works
============================

The source code is divided on folders. There are three folders. One of them is applied to Frames of documents, 
the other on Characters and other on Documents. We are planning to put all the folders and source code until 2015.
The first folder uploaded is the one applied on Frames (on which we found better results).

To run the code, just run main.m. There will be a menu showed to you where you will choose one of the five methods 
proposed in this paper. We are not making available the inter-approach feature fusion approaches (CTGF_MD_MS and CTGF_3X3_GLCM_MD_MS) 
because they are straighforward: just run each method separately and after that concatenate the feature vectors.

After choosing the method used, the source code will do the following operations:

1- Extract the feature vectors of ALL documents. Documents will have one feature vector 
(when applied on documents) or more (when applied on letters and frames). Please change the folder 
where the dataset is located on test_feature_vector_generator.m

2- Concatenate the feature vectors to train the classifier based on a 5x2 cross validation 
table (see info/5x2_Data.CSV).

3- Classify the data by using 5x2 cross validation. The classification is based on 
the voting of classifications of feature vectors (one or more, depending on where the technique is applied).

4- Write confusion tables and show the mean accuracy of the 5x2 cross validation.

All these steps are done automatically by the source code. So, please be patient and wait it to finish :-)

4. Contact
==========

If you find some problems or have suggestions, please don't hesitate to contact me

anselmoferreira@ic.unicamp.br


