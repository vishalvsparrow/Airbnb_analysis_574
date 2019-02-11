rm(list=ls())
dat = read.csv('listings.csv', head=T, stringsAsFactors=F, na.strings='') 
View(dat)

amenities = dat$amenities

'
count = 0 
for (i in 1:length(amenities)){
 if(amenities[i] == "{}")
 {
   count = count+1
 }
}

print(count)
'

id.missing_amenities = which(amenities == "{}")
dat1 = dat[-id.missing_amenities,]

id.missing_cleaning = which(is.na(dat1$cleaning_fee))
dat2 = dat1[-id.missing_cleaning,]

id.missing_deposit = which(is.na(dat2$security_deposit))
dat3 = dat2[-id.missing_deposit,]

dim(dat1)
dim(dat2)
dim(dat3)
View(dat3)

write.csv(dat3,file = "amenities_deposit_cleaning.csv")

#After manually selecting 27 features, I further clean the data. Note that the amenities feature is still unprocessed

vishal_select = read.csv('vishal_select_features.csv', head=T, stringsAsFactors=F, na.strings='NA') 

id.missing_review_score = which(is.na(vishal_select$review_scores_value))

vishal_select = vishal_select[-id.missing_review_score,]
write.csv(vishal_select, file = "vishal_select_clean.csv")


