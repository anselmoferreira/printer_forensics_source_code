printer_forensics_source_code
=============================

1. About the source code

=========================


This is the source code of the paper 'Laser Printer Attribution: Exploring New Features and Beyond', published by us in Forensics Science International.

If you use this source code, please don't forget to cite our paper.

Here is the bibtex entry for the article:

@article{anselmoetal:2015,
title = "Laser printer attribution: Exploring new features and beyond ",
journal = "Forensic Science International ",
volume = "247",
number = "0",
pages = "105 - 125",
year = "2015",
author = "Anselmo Ferreira and Luiz C. Navarro and Giuliano Pinheiro and Jefersson A. dos Santos and Anderson Rocha",
}

This source code investigates laser printer banding signatures by exploring multidirectional and multiscale textures of printing material in digitalized versions of printed documents. These signatures are used to identify the laser printer 
source of a given document. We use SVM linear kernel classifiers to learn these signatures on a set of 
different printer models and brands. We show accuracies above 97%. 

If you want to know more about the proposed techniques you can find our paper at: http://dx.doi.org/10.1016/j.forsciint.2014.11.030

What we proposed to laser printer attribution in this paper?

1- A multidirectional GLCM extension technique

2- A multidirectional/multiscale GLCM extension technique

3- A novel convolutional gradient texture filter

4- Realistic dataset, comprising 1,000+ Wikipedia documents is proposed for evaluation

5- Comparison to other techniques and other general purpose texture descriptors

The dataset can be found at: http://www.recod.ic.unicamp.br/~anselmo/printer_forensics_dataset/

We are planning to upload ALL the source code used in this research in GitHub. 

We will also translate the code and comments to English. Sorry, first time making source code available :-(

2. Classifier used

==================

Here we used our own implementation of the one-against-one linear kernel SVM classifiers using the 
matlab stats package. You can use Libsvm if you want, but this SVM is more accurate because there are some parameters that are easier to set than in Libsvm (kktviolation in the training phase for example).  Remember that the matlab implementation of the svm is based on Libsvm, so there is not a problem using this SVM.  

Here, we don't use grid search on parameter C (we fixed it to 1). You can find even better results if you do a grid search in this parameter. Most of the classifications are based on voting of classifications because the documents can have one or more feature vectors.

3. How the source code works

============================

The source code is divided on folders. The first folder uploaded is the one applied on Frames (on which we found better results). The version of the Matlab used in this code is Matlab 2012. 

To run the code, just run main.m. There will be a menu showed to you where you will choose one of the five methods
proposed in the paper. We are not making available the inter-approach feature fusion approaches (CTGF_MDMS and CTGF_GLCM_MDMS) because they are straighforward: just run each method separately and after that concatenate the feature vectors. Also, applying the proposed approaches on letters and documents is also simple: just change the input of the algorithm.

After choosing the method used, the source code will do the following operations:

1- Extract the feature vectors of ALL documents. Documents will have one feature vector 
(if the technique is applied on documents) or more (if the technique is applied on letters and frames). Please change the folder where the dataset is located on test_feature_vector_generator.

2- Concatenate vertically the feature vectors of training documents to train the classifier based on a 5x2 cross validation 
table (see info/5x2_data.csv).

3- Classify the test feature vectors from testing documents by using 5x2 cross validation. The classification is based on 
the voting of classifications of feature vectors (one or more, depending on where the technique is applied on the document).

4- Write confusion tables and show the mean accuracy of the 5x2 cross validation.

All these steps are done automatically by the source code. So, please be patient and wait it to finish :-)

4. About the Authors

====================

Anselmo Ferreira: Phd in Computer Science at State University of Campinas, Brazil

Luiz C. Navarro: Master Student in Computer Science at State University of Campinas, Brazil

Giuliano Pinheiro: Undergraduate Student in Computer Science at State University of Campinas, Brazil

Jefersson A. Dos Santos: Computer Science Professor at Universidade Federal de Minas Gerais, Brazil

Anderson Rocha: Computer Science Professor at State University of Campinas, Brazil


5. Contact

==========

If you find some problems or have suggestions, please don't hesitate to contact me

anselmoferreira@gmail.com


