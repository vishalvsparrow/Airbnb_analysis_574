rm(list=ls(all.names = TRUE)) #removes the hidden objects too which start with .
gc()
setwd('C:\\Users\\vishal\\Downloads')

raw_data = read.csv('final_price_clean.csv',header=TRUE,na.strings = '')
dim(raw_data)
View(raw_data)
colnames(raw_data)
raw_data = raw
source('imageMatrix.R')
myImagePlot(is.na(raw_data))

require(varhandle)
require(reshape2)
require(ggplot2)
require(magrittr)
ggplot_missing <- function(x){
  
  x %>% 
    is.na %>%
    melt %>%
    ggplot(data = .,
           aes(x = Var2,
               y = Var1)) +
    geom_raster(aes(fill = value)) +
    scale_fill_grey(name = "",
                    labels = c("Present","Missing")) +
    theme_minimal() + 
    theme(axis.text.x  = element_text(angle=45, vjust=0.5)) + 
    labs(x = "AirBnb features",
         y = "Training examples")
}

ggplot_missing(raw_data[,-52])

raw_data$review_accuracy <- as.numeric(raw_data$review_accuracy)


#Set the threshold to 30%

cols_to_delete = c()
threshold = 0.3

for (col.index in 1:ncol(raw_data))
{
  is.false = table(is.na(raw_data[,col.index]))["FALSE"]
  is.true = table(is.na(raw_data[,col.index]))["TRUE"]
  #print (colnames(raw_data)[col.index])
  #print (table(is.na(raw_data[,col.index])))
  print("----------")
  
  if(is.na(is.false) || is.na(is.true))
  {
    next
  }
  
  else
  {
    no.false = table(is.na(raw_data[,col.index]))[["FALSE"]]
    no.true = table(is.na(raw_data[,col.index]))[["TRUE"]]
    
    if(no.true/no.false > threshold)
    {
      print (colnames(raw_data)[col.index])
      cols_to_delete <- append(cols_to_delete,col.index)
      
    }
    
  }
}

#I find that the features Fuel Type, Radio Cassette, and KM have about 30% missing values.
#Therefore, I must eliminate them

new_data = raw_data[,- cols_to_delete]

#I see that there seem to be rows with missing values which are more than 30%

no.rows = nrow(new_data)
no.cols = ncol(new_data)

row.index = rep(NA, no.rows)
row.index_delete = rep(NA, no.rows)

#I will repeat this for-lopp (a tad modified) below. I should start making functions in R
  
for(i in 1:no.rows)
{
  no.missing_rows = 0
  
  row.index[i] = (sum(is.na(new_data[i,])) == 0)
  
  no.missing_rows = sum(is.na(new_data[i,]))
  
  if(no.missing_rows/no.cols < threshold)
  {
    row.index_delete[i]  = TRUE
    
  }
  else
    row.index_delete[i] = FALSE
  
}

table(row.index_delete)

new_data = new_data[row.index_delete,]

dev.off() #In case R throws a graphics error

myImagePlot(is.na(new_data))

#------------- SOME PART OF THE CODE BELOW IS MANUAL (FILE SPECIFIC) EXAMPLE: DUMMY VARIABLES ------#

#Summary for the categorical variables
counts <- table(raw_data$property_type)
counts
barplot(counts)
counts <- table(raw_data$room_type)
counts
barplot(counts)
counts <- table(raw_data$bathrooms)
counts
barplot(counts)
counts <- table(raw_data$bedrooms)
counts
barplot(counts)
counts <- table(raw_data$beds)
counts
barplot(counts)
counts <- table(raw_data$bed_type)
counts
barplot(counts)


#Creating dummy variables for property_type
raw_data$prop_apartment = raw_data$prop_condo = raw_data$prop_house = raw_data$prop.other = 0 

raw_data$prop_apartment[which(raw_data$property_type == 'Apartment')] = 1
raw_data$prop_condo[which(raw_data$property_type  == 'Condominium')] = 1
raw_data$prop_house[which(raw_data$property_type == 'House')] = 1
raw_data$prop.other[which(raw_data$property_type %in% c('Bed & Breakfast', 'Boat', 'Guesthouse', 'Loft', 'Townhouse'))] = 1

View(raw_data)

#Delete the Colors column

# raw_data <- raw_data[,-which(colnames(raw_data)=="property_type")]

#Creating dummy variables for room_type
raw_data$room.entire_apt = raw_data$room.private_shared = 0 

raw_data$room.entire_apt[which(raw_data$room_type == 'Entire home/apt')] = 1

raw_data$room.private_shared[which(raw_data$room_type %in% c('Private room', 'Shared room'))] = 1

View(raw_data)


#Creating dummy variables for bathrooms
raw_data$bath.one = raw_data$bath.two = raw_data$bath.other = 0 

raw_data$bath.one[which(raw_data$bathrooms == 1)] = 1
raw_data$bath.two[which(raw_data$bathrooms == 2)] = 1


raw_data$bath.other[which(raw_data$bathrooms %in% c(0.5, 1.5, 2.5, 3, 3.5, 4))] = 1

View(raw_data)

#Creating dummy variables for bedrooms
raw_data$bedroom.one = raw_data$bedroom.two = raw_data$bedroom.other = 0 

raw_data$bedroom.one[which(raw_data$bedrooms == 1)] = 1
raw_data$bedroom.two[which(raw_data$bedrooms == 2)] = 1


raw_data$bedroom.other[which(raw_data$bedrooms %in% c(0, 3, 4, 5))] = 1

View(raw_data)


#Creating dummy variables for beds
raw_data$bed.one = raw_data$bed.two = raw_data$bed.other = 0 

raw_data$bed.one[which(raw_data$beds == 1)] = 1
raw_data$bed.two[which(raw_data$beds == 2)] = 1


raw_data$bed.other[which(raw_data$beds %in% c(0, 3, 4, 5, 6, 7, 8, 9))] = 1

View(raw_data)

#Creating dummy variables for bed_type
raw_data$bedtype.real = raw_data$bedtype.other = 0 

raw_data$bedtype.real[which(raw_data$bed_type == "Real Bed")] = 1
raw_data$bedtype.other[which(raw_data$bed_type %in% c("Airbed", "Futon", "Pull-out Sofa"))] = 1

View(raw_data)

#Check the number of missing values in each column

na_count <-sapply(new_data, function(y) sum(length(which(is.na(y))))>0)
na_count <- new_data[na_count]

#View(na_count)

#In order to check if the variables are categorical, we will count the number of unique values contained
#If this value is greater than 11, we will assume the variable to be continious, else categorical
threshold.continious = 9
continious.col_index <- c()

for(i in 1:length(na_count))
{
  if(length(unique((na_count[[i]])))> threshold.continious)
  {
    continious.col_index <- append(continious.col_index,i)
    temp_1 = NULL
    temp_1 = na_count[[i]]
    temp_1[is.na(temp_1)] = round(mean(temp_1, na.rm = TRUE),2) 
    na_count[[i]] = temp_1
  }
}

#View(na_count)

#Merging the two data frames to make a non-missing new_data dataframe

for(i in 1:length(new_data))
{
  for(j in 1:length(na_count))
  {
    if((colnames(new_data[i]) == colnames(na_count[j])))
      {
         new_data[i] = na_count[j]
      }
  }
  
}

########################### REPEATED CODE -- DO NOT SKIP #############################
#Finally, deleting any row with a missing value 
row.index = row.index_delete = rep(NA, nrow(new_data))

#View(new_data)

for(i in 1:nrow(new_data))
{
  no.missing_rows = 0
  
  row.index[i] = (sum(is.na(new_data[i,])) == 0)
  
  no.missing_rows = sum(is.na(new_data[i,]))
  
  #if(no.missing_rows/no.cols < threshold)
  #{
    #row.index_delete[i]  = TRUE
    
  #}
  #else
   # row.index_delete[i] = FALSE
  
  if(no.missing_rows > 0)
    row.index_delete[i]  = TRUE
  else
    row.index_delete[i] = FALSE
    
}

new_data = new_data[!(row.index_delete),]
#Just for sake
na_count = na_count[!(row.index_delete),]
############################# END OF REPEATED CODE#####################

#View(new_data)

#Now, we will remove all the continious variables from the na_count data
#This way, we are left with only categorical variables in na_count
na_count <- na_count[,-continious.col_index]
continious.col_index = NULL #Safety Check
View(na_count)
#Now that I think about it, na_count has no use (but it may have in future). Silly me


######################OUTLIER CODE####################
#I will now plot histograms for a few continious variables

par(mfrow=c(1, 2))
hist(raw_data$Price)
boxplot(raw_data$Price)

hist(new_data$CC)
boxplot(new_data$CC)

#Function for detecting outliers
detect_outliers <- function(my_data){

  q1 = quantile(my_data,0.25,na.rm=TRUE)[["25%"]]
  q3 = quantile(my_data,0.75,na.rm=TRUE)[["75%"]]
  
  IQR = q3-q1
  upper.limit = q3+(1.5*IQR)
  lower.limit = q1-(1.5*IQR)
  
  temp_data = rep(NA, length(my_data))
  
  for(j in 1:length(my_data))
  {
    if(my_data[j] < lower.limit || my_data[j] > upper.limit)
    {
      temp_data[j] = FALSE
    }
    else
      temp_data[j] = TRUE
  }
  return(temp_data)
}

#Remove outliers for Weight and CC
price_clean <- raw_data_1[detect_outliers(raw_data_1$Price),]
#new_data <- new_data[detect_outliers(raw_data$Price),]

boxplot(price_clean$Price)
boxplot(new_data$CC)

#Hence, the new Weight feature is free of outliers
#######################END OF OUTLIER CODE#############################

#From na_count, I see that there are only Doors and Gears which need dummy variables
#Creating dummy variables for Gears & Doors 

#For Gears
new_data$Gears.fifth = new_data$Gears.others = 0

new_data$Gears.fifth[which(new_data$Gears == 5)] = 1

new_data$Gears.others[which(new_data$Gears %in% c(1,2,3,4,6))] = 1

#For Doors
new_data$Doors.five = new_data$Doors.three = new_data$Doors.others = 0

new_data$Doors.five[which(new_data$Doors == 5)] = 1

new_data$Doors.three[which(new_data$Doors == 3)] = 1

new_data$Doors.others[which(new_data$Doors %in% c(1,2,4))] = 1

#Delete the Gears and Doors columns
new_data <- new_data[,-which(colnames(new_data)=="Gears")]
new_data <- new_data[,-which(colnames(new_data)=="Doors")]

#Renaming the rows so that they are nicely in order
rownames(new_data) <- NULL

#myImagePlot not working --- ISSUE on 3/4/2017
source('imageMatrix.R')
myImagePlot(is.na(new_data))

# QQPlot for price






















#-----------ISSUE PARTLY RESOLVED-----------
#The heatmap will show you that there are still some missing values. 
#This is because I have only removed the rows with 30% or more missing values
#and not treated the missing values yet. This is one of the questions I have to ask

#UPDATE March 3rd 2017
#It seems like it is finally the time to treat the missing examples.
#Done it in the code above #Update March 4th 2017
#However, cannot get heatmap to work
#-----------ISSUE END------------

write.csv(x,file = "x.csv",row.names = FALSE)

