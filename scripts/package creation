# PACKAGE CREATION ---  StatLearning ---

#libraries needed

#install.packages("devtools")
#install.packages("pkgbuild")
#install.packages("roxygen2")

library(devtools)
library(pkgbuild)
library(roxygen2)

#path_to_package creation
path_to_packages <- "..."     #select a path and paste its address between the quotation marks.
                              #This is the folder in which the package metadata will be saved. 
                              #Make sure the path ends with "/"

# We create the package skeleton in the given path
create_package(path = paste0(path_to_packages, 
                             "StatLearning"))

# Now there is a new folder in the selected path named "StatLearing".
#    -   Open it and find the folder called "R".
#    -   Put the two R script "clustering" and "class_regr" into the "R" folder.
#    -   Then execute the following command:
devtools::document(pkg = paste0(path_to_packages, 
                                "StatLearning"))

#package validation
devtools::check(paste0(path_to_packages, 
                       "StatLearning"))

#installation 
devtools::install(pkg = paste0(path_to_packages, 
                               "StatLearning"), 
                  reload = TRUE)


#in case of changes to the functions
roxygenise(package.dir = paste0(path_to_packages, 
                                "StatLearning"))

