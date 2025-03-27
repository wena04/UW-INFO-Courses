births.per.month<-c(2995,2708,2993,2785,2994,3032,3114,3221,3052,3085,2971,2932)
n=sum(births.per.month)

prop.per.month<-c(31,28,31,30,31,30,31,31,30,31,30,31)/365

# H0: The births per month are the same (given # of days per month)
# Ha: The birth rate per month is not the same (given # of days per month)

expected.count=prop.per.month*n
chi2=sum((births.per.month-expected.count)^2/expected.count)

# Let's try and simulate this behavior if the null was true:
month.tags<-c()
for(i in 1:length(prop.per.month))
  month.tags<-c(month.tags, rep(i,prop.per.month[i]*365))

chisq.values<-rep(0,10000)
for(i in 1:10000){
  chisq.values[i]=sum((table(sample(month.tags, n, rep=TRUE))-expected.count)^2/expected.count)
}
hist(chisq.values, freq=FALSE, xlab='Chisq Test Statistic', 
     main='Simulated Chisq Test Results under H0', breaks=25)
lines(0:40, dchisq(0:40, df=11), lwd=3)

abline(v=chi2, lwd=3)

mean(chisq.values>=chi2) #Simulated p-value
pchisq(chi2, df=11, lower.tail=FALSE) #Exact p-value

# Based on this p-value, we reject the null hypothesis
# Births are not uniform over months (based on length of month)

chisq.test(births.per.month, p=prop.per.month)



# Based on the births recorded by the CDC for 2023:
# January	  299,458
# February	270,788
# March	    299,265
# April	    278,485
# May	      299,384
# June	    303,165
# July	    311,383
# August	  322,089
# September	305,203
# October	  308,544
# November	297,098
# December	293,151