# This is just importing, cleaning, and reordering data
data(Titanic)
tdf <- as.data.frame(Titanic)
titanic.data <- tdf[rep(1:nrow(tdf), tdf$Freq), -5]
titanic.data$AgeOrSex=as.character(titanic.data$Sex)
titanic.data$AgeOrSex[titanic.data$Age=="Child"]="Child"
titanic.data$AgeOrSex=as.factor(titanic.data$AgeOrSex)

# We want to see if there is merit to "Women and Children First!" 
titanic.table=table(titanic.data$AgeOrSex, titanic.data$Survived)

# Specifically, is there a relationship between 
#  survival and status as a Woman or Child. 
# H0: There is no relationship between being a child or 
#  sex (for adults) and probability of survival. 
#  These variables are independent.
# Ha: There is a relationship between being a child or
#  sex (for adults) and probability of survival.
#  These variables are not independent. 

rows=rowSums(titanic.table)
cols=colSums(titanic.table)
total=sum(titanic.table)

# Doing this by hand, is tedious...
e11=rows[1]*cols[1]/total
(e11-titanic.table[1,1])^2/e11
e12=rows[1]*cols[2]/total
(e12-titanic.table[1,2])^2/e12

# We can do it a little faster using matrix notation
expected=rows %*% t(cols)/total
chi2=sum((titanic.table-expected)^2/expected)


test.result=chisq.test(titanic.table)

names(test.result)

# We reject the null hypothesis and conclude that survival
#  is not independent of sex/age.
