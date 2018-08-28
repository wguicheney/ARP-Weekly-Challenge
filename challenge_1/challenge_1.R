# Challenge 1 - Joining Postcodes
# Author: Philip Mannering
# Date: 27/08/2018

# A company in Australia has source data which is made up of a series of postal
# codes (eg. 2000, 2001, 2002 etc.) amongst some other data fields. They have a
# separate reference table which contains postcode ranges (eg. 2000 to 2002)
# which they would like to use to match/filter their main data.

# Each Customer Record needs to be joined to the Lookup table based on a Postal
# Area Ranged region. Then finally summarize the customer data by Region, Sales
# Rep, and Responder, then a count of customers.

# Time it
ptm <- proc.time()


library(data.table)

# Set the working directory
setwd('~/../Google Drive/Alteryx/Challenges/Challenges 001-010/challenge_1/')

# Load the data
load('ref.rdata')
load('postcodes.rdata')

# Extract the postcode areas from the Range and convert to numbers
r1 <- as.integer(substr(ref$Range, 1, 4))
r2 <- as.integer(substr(ref$Range, 6, 9))

# Create an empty list
ref.list = list()

# Each list entry contains the whole range of postcode values
for (i in 1:nrow(ref)){
  ref.list[[i]] <- cbind(RowCount = r1[i]:r2[i], ref[i,], 
                         row.names = NULL)
  }

# Concatenate the list of data frames into one single data frame
# 1. Using rbindlist from the data.table backage.
# 2. Or using rbind.fill from the plyr package.
ref <- rbindlist(ref.list)

# Join the data frames  
# NB: put the data.table first for the merged object to be a data.table.
dt <- merge(ref, postcodes,
                by.x = 'RowCount',
                by.y = 'Postal.Area')

# Check number of unique values across whole data table
sapply(dt, function(x) length(unique(x)))

# Summarize
ans <- dt[,.(Count= length(unique(Customer.ID))), 
          by = .(Region, Sales.Rep, Responder)]

# Time it
print(proc.time()-ptm)