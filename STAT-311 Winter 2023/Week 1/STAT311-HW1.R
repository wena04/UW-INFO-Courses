# You will be using the "usdata" package's "county" data for this assignment. 
# You will need to run:install.packages("usdata") once to install this library 
# do not include the install.packages command in your submission

## ## ## ## ## DO NOT MODIFY BELOW ## ## ## ## ## 
library(usdata)
county<-as.data.frame(county)
county<-county[!is.na(county$median_edu),]
# The set.seed command will ensure your results are consistent
#  each time you run the "source" command
set.seed(311)
## ## ## ## ## DO NOT MODIFY ABOVE ## ## ## ## ## 

# Treating the "county" dataset as the population of US counties
#  create the dataframe "my.SRS" that represents a simple
#  random sample of n=250 individual counties from all counties in the US.

my.SRS <- county[sample(nrow(county),250),] #make sure to take samples for the rows of county and not column
dim(my.SRS) 

# Treating the "county" dataset as the population of US counties
#  create the dataframe "my.Stratified" that represents a stratified
#  sample of individual counties from all counties in the US, statified 
#  along the level of education (median_edu). Due to the different sizes of strata,
#  you should sample: 
#  1 county from "below_hs", 14 from "hs_diploma", 17 from "some_college"
#  and 4 from "bachelors"
table(county$median_edu)

#checking for the types of median_edu
#unique(county$median_edu)

below <- (county[county$median_edu=="below_hs",])
diploma <- (county[county$median_edu=="hs_diploma",])
college <- (county[county$median_edu=="some_college",])
bach <- (county[county$median_edu=="bachelors",])

rbelow <- below[sample(nrow(below),1),]
rdiploma <- diploma[sample(nrow(diploma),14),]
rcollege <- college[sample(nrow(college),17),]
rbach <- bach[sample(nrow(bach),4),]

dim(rdiploma)
tail(rdiploma)
head(rdiploma)

#checking length before sampling
#dim(below)
#dim(diploma)
#dim(college)
#dim(bach)

#checking length after sample
#dim(rbelow)
#dim(rdiploma)


my.Stratified <- rbind(rbelow,rdiploma,rcollege,rbach)

#The numbers here should match those specified above
table(my.Stratified$median_edu)


# Treating the "county" variable as a population of US counties
#  create the dataframe "my.Clustered" that represents a cluster
#  sample of individual counties from all counties in the US, clustered by state. 
#  You should randomly sample counties from a total of 5 clusters

clusters = sample(unique(county$state),5)
#clusters

clusters2 <- county[0,]
for (cluster in clusters){
  temp<-county[county$state==cluster,]
  clusters2 <- rbind(clusters2,temp)
}
my.Clustered <- clusters2

#This should only give 5 total states
unique(my.Clustered$state)

