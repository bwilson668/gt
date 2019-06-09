# QUESTION
#
# Test to see whether there are any outliers in the last column 
#   (number of crimes per 100,000 people)

# Import Libraries
library(tidyverse)
library(outliers)

# Read the data in
crime <- read.table("_data/uscrime.txt", header = TRUE, sep = "", dec = ".")

# Understand the data
glimpse(crime)
# crime$Crime will be the column we are analyzing for outliers

# Understand the function
?grubbs.test

###
#
# REPORT
#
# The Grubbs test can check both extremes/tails of a distribution.
# In this case, outliers in the level of crime, I'd think we only want to look at 
#   the high-level of crime. Asking, "Are there any unusually high points for crime?"
# This would mean we would want a one-tailed test, on the highest end.
#
###

# Start testing for outliers
grubbs.test(
    crime$Crime,        # Target variable for outliers
    type = 10,          # Look for 1 outlier - we can run again if an outlier is found
    opposite = FALSE,   # Look at the MAX or high-end tail, not the low-end
    two.sided = FALSE   # We only want to look at one tail. If crime is unusally low, that's a good thing we want to model.
  )

###
#
# REPORT
#
# So after testing for the outlier on the high end, I would accept the NULL hypothesis.
# The highest value '1993' is not an outlier.
# The p-value does not break out 5% significance threshold. It's close though.
#
###