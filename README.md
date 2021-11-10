# Description

This R package allow to assess the performances of different machine learning algorithms on the same dataset provide in input by the user.

The package is composed by two functions which compute supervised and unsupervised learning on the same dataset with different methods, 
and show the performances of each of them in a summary table.

The two functions are: 

1.  `class_regr()` : If the dependent variabile is a binary factor, it will execute classification. In this case the output will be a table showing accuracy, 
                   misclassification rate and F-score of the classification in-sample obtained with lda, qda, logistic regression and k-NN (key-nearest neighbour).
                   If the dependent variabile is numeric, it will execute regression. In this case the result will be a table showing R2 and RMSE (Root Mean Square Error) 
                   of the penalized regression obtained with different levels of alpha (specified by the user as a parameter). 
                   The performance metrics are obtained with a cross-validation, whose number of folds are specified by the user. 
                  
2.  `clustering()` : it will execute k-medoid, k-means and hierarchical clustering on the dataset provided by the user, who can also decide the number of partitions,
                   the distance metric used in k-medoid and in the hierarchical clustering, as well as the type of linkage used in the latter. The output is a table showing 
                   the ASW (average silhouette width) and CHC (Calinski-Harabasz criterion) calculated on each resulting partition. 

# Download instructions

The code needed for the package installation include the R scripts **package_creation.R**, **class_regr.R** and **clustering.R**.

The first one contains the code for the creation of the whole package, while the last two are the scripts containing the functions.

1. The first step is to open package creation.R, install the needed libraries specified in the comments and upload them into the working space.
2. Then write a valid address in the path_to_package. This will be the path used by the system for creating the package.
3. Then execute create_package command. The system will create a folder called “StatLearning” at the path previously specified.
4. Open this folder and find an other one called R. Open it.
5. Then put clustering.R and class_regr.R into this folder.
6. Then execute the three following commands.
7. `devtools::document` create a the documentation of the functions.
8. `devtools::check` check if everything is corrected.
9. `devtools::install` actually install the package on the computer.

*roxygenise* command will be needed to save changes to the functions.

10. The last step is to upload the package in the working space with `library(StatLearning)`.
