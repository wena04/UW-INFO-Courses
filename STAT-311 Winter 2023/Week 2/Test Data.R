library(usdata)
county<-as.data.frame(county)
county<-county[!is.na(county$median_edu),]
county$homeownership
?county
hist(county$homeownership,freq = FALSE,breaks=20,
     xlab = "Home Ownership Rate of different counties from 2006-2010 (% percentage)",
     main = "Distribution of Home Ownership Rates")
length(county$homeownership)
sum(county$homeownership)/length(county$homeownership)

set.seed(311)
# Include your code from HW1 to create the my.Clustered dataset. Keep the added last line at the end.

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

# Do not touch the code below.
my.Clustered$state<-droplevels(my.Clustered$state)
boxplot(my.Clustered$poverty~my.Clustered$state,xlab = "State",
        ylab = "Percentage of Population in Poverty (%)",
        main= "Comparing the Percentage of Poverty by State")
