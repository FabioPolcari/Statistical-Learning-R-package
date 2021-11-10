#' Computing unsupervised learning
#'
#' "Clustering" function clusters the dataset using different approaches:
#' k-medoids, k-means and hierarchical clustering.
#' The maximum number of cluster to assess can be selected. The function computes
#' clusters with those algorithms and evaluates the performance of each of them
#' (and for every number of clusters from 2 to the one the user specify)
#' with two metrics: ASW (average silhouette width), and CHC (Calinski-Harabasz
#' criterion).
#'
#' @author Fabio Polcari & Matteo Ruggiero
#' @param x data.frame. Dataset on which clustering wish to be performed. It have to be
#' composed only by numeric variables (it does not support factorial or characters).
#' @param Kmax numeric. Maximum number of clusters to compute. It must be an integer
#' bigger or equal to 2 and smaller than the number of observation in the dataset.
#' @param pam.metric charachter. Character indicating which kind of metric to be
#' used in computing k-medoid clustering (partitions around medoid). It must be one
#' among "manhattan", "euclidean", "maximum", "camberra", "binary", "minkowski".
#' @param hier.metric character. Character indicating which kind of metric one want
#' to use to compute hierarchical clustering. It must be one among "euclidean",
#' "maximum", "manhattan","camberra", "binary", "minkowski", "pearson", "spearman",
#' "kendall".
#' @param hier.linkage charachter. Character indicating the dissimilarity measure
#' between groups in hierarchical clustering. It must be one among "single", "complete",
#' "average".
#' @return A list with two results matrices. One reporting CHC values for each algorithm
#' and  for each number of partitions, and one reporting ASW values for each algoritmh and for
#' each number of partitions.
#' @import caret
#' @import rsample
#' @import corrplot
#' @import factoextra
#' @import cluster
#' @import fpc
#' @import assertthat
#' @import tidyverse
#' @export

clustering <- function(x, Kmax, pam.metric = "manhattan", hier.metric = "pearson", hier.linkage = "average"){

  #error handling for x(dataset)
  assert_that(is.data.frame(x), msg = "x must be a data frame")

  #error_handling for non-numeric variables
  for (i in 1:ncol(x)){
    assert_that(any(is.numeric(x[,i]),is.integer(x[,i]), is.double(x[,i])),
                msg = "variables must be numeric or integer")
  }

  #error-handling for pam.metric
  assert_that(any(pam.metric=="manhattan", pam.metric =="euclidean",
                  pam.metric=="maximum" ,  pam.metric=="camberra",
                  pam.metric=="binary",  pam.metric=="minkowski"), msg = 'Invalid metric for k-medoid')
  #error-handling for hier.metric
  assert_that(any(hier.metric=="euclidean",  hier.metric=="maximum",
                  hier.metric=="manhattan", hier.metric=="camberra",
                  hier.metric=="binary", hier.metric=="minkowski",
                  hier.metric=="pearson", hier.metric=="spearman",
                  hier.metric=="kendall", msg = "Invalid metric for hierarchical clustering"))

  #error-handling for hier.linkage
  assert_that(any(hier.linkage=="single", hier.linkage=="average",
                  hier.linkage=="complete"), msg = "Invalid linkage")

  #error-handling for kmax
  assert_that(Kmax == round(Kmax), msg = "Kmax must be integer")
  assert_that(Kmax < nrow(x), msg = "Kmax must be lower or equal than the number of observation")
  assert_that(Kmax > 1, msg = "Kmax must be at least equal to 2")

  #empty matrices creation
  ASW <- matrix(0, nrow = 3, ncol = Kmax-1)
  CHC <- matrix(0, nrow = 3, ncol = Kmax-1)

  #dissimilarity matrices needed for the computation of each algorithm
  Dhc     <- get_dist(x, stand = FALSE , method = hier.metric)
  Dkmea      <- dist(x, method = "euclidean")     #euclidean dissimilarity matrix
  Dkmed <- dist(x, method = pam.metric)

  for(k in 2:Kmax){

    # cluster computation for each algorithm
    kmed   <- pam(x = Dkmed,  k = k)
    kmea   <- kmeans(x, centers = k, nstart = 3)

    HC    <- hclust(Dhc, method = hier.linkage)    #input
    # plot(HC$height, t='l', lwd = 3)   # plot del dendogramma
    cl <- cutree(HC, k = k)   # cluster obtained

    # ASW for each clustering algorithm
    s.kmed   <- silhouette(x = kmed$clustering , dist = Dkmed)
    s.kmea  <- silhouette(x = kmea$cluster , dist = Dkmea)
    s.cl <- silhouette(x = cl, dist = Dhc)

    #CHC computation for each algorithm
    ci.kmed <- cluster.stats(d = Dkmed, clustering = kmed$clustering)
    ci.kmea <- cluster.stats(d = Dkmea, clustering = kmea$cluster)
    ci.cl   <- cluster.stats(d = Dhc, clustering = cl)

    # ASW result matrix
    ASW[1, k-1] <- mean(s.kmed[,3])
    ASW[2, k-1] <- mean(s.kmea[,3])
    ASW[3, k-1] <- mean(s.cl[,3])
    colnames(ASW) <- as.character(seq(2,Kmax), by=1)
    rownames(ASW) <- c("K-medoid", "K-means", "Hierarchical")

    #CHC result matrix
    CHC[1, k-1] <- ci.kmed$ch
    CHC[2, k-1] <- ci.kmea$ch
    CHC[3, k-1] <- ci.cl$ch
    colnames(CHC) <- as.character(seq(2,Kmax), by=1)
    rownames(CHC) <- c("K-medoid", "K-means", "Hierarchical")
  }
  return(list(ASW = ASW, CHC = CHC))
}
