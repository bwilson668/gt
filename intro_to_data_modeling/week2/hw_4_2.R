# QUESTION
#
# Use the R function kmeans to cluster the points as well as possible. 
# Report the best combination of predictors, your suggested value of k, 
# and how well your best clustering predicts flower type.

# Import Libraries
library(tidyverse)

# Set Seed for Reproducability
set.seed(1234)

# Read the data in
iris <- read.table("_data/iris.txt", header = TRUE, sep = "", dec = ".")

# Data Prep
# Scaled around center due to suggestion in week 1. 
#   Scaling from 0-1 is good for classification. 
#   Scaling around center is good for clustering.
iris_scaled <- mutate(
    iris,
    Sepal.Length = scale(Sepal.Length)[,1],
    Sepal.Width = scale(Sepal.Width)[,1],
    Petal.Length = scale(Petal.Length)[,1],
    Petal.Width = scale(Petal.Width)[,1]
  ) %>% 
  select( -Species )

# Determine which predictors should be used
my_cols <- c("#FF0000", "#00FF00", "#0000FF") # RGB
pairs(
    iris_scaled, cex = 0.5,
    col = my_cols[iris$Species],
    lower.panel=NULL
  )

###
#
# REPORT
#
# The Green and Blue species are the hardest to distinguish.
# Each of the 4 features look to contribute to the ability of separating the species.
# For my analysis, I'll leave all 4 features in for the clustering.
#
###

k_range <- 1:10

# Loop over all possible Ks 
iris_clusters <- sapply(
    k_range, 
    function(k){ kmeans(iris_scaled, k) }
  )

# Elbow Curve Plot
plot(
    k_range, iris_clusters[5,],
    type="b", main="Elbow Curve Plot",
    xlab="Number of clusters K",
    ylab="Total within-clusters sum of squares"
  )

###
#
# Report
# 
# Judging by the Elbow Curve, my suggested value of K would be 4 clusters.
# 
# Although, we know the dataset has 3 species. 
# If these species were previously unknown, then we might name 4 different species.
# However, since we know there are 3, the clustering would not make for the best classifier, 
#   especially between the blue and green species.
#
###