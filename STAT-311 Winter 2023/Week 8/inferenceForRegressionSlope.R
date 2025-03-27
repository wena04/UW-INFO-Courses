data(state)
# We load the state life expectancy and days freezing data
#  both with and without Hawaii
lifeExpNoHI=state.x77[c(1:10,12:50),4]
coldDaysNoHI=state.x77[c(1:10,12:50),7]
lifeExpYesHI=state.x77[c(1:50),4]
coldDaysYesHI=state.x77[c(1:50),7]

plot(coldDaysNoHI,lifeExpNoHI,xlab='Average # Days with Min Temp < Freezing',
     ylab='Life Expectancy',main='Preserving Life (like a refrigerator)')

plot(coldDaysYesHI,lifeExpYesHI,xlab='Average # Days with Min Temp < Freezing',
     ylab='Life Expectancy',main='Preserving Life (like a refrigerator)')

# We fit linear models to the data with and without HI
modelNoHI=lm(lifeExpNoHI~coldDaysNoHI)
modelYesHI=lm(lifeExpYesHI~coldDaysYesHI)

# We can get to the slope and SE of the slope using the summary command
b1hat.noHI=summary(modelNoHI)$coefficients[2,1]
SEb1hat.noHI=summary(modelNoHI)$coefficients[2,2]

# Let's address the hypothesis H0: b1=0;
# The slope of the regression equation describing life expectancy from
#  average # days freezing is zero. (Without HI)
# Ha: b1>0 (without HI)
# The slope of the regression equation describing life expactancy from 
#  average $ days freezing is greater than zero. (Without HI)
testStat.noHI=(b1hat.noHI-0)/SEb1hat.noHI
pt(testStat.noHI, df=47, lower.tail=FALSE)


# Let's address the hypothesis H0: b1=0;
# The slope of the regression equation describing life expectancy from
#  average # days freezing is zero. (With HI)
# Ha: b1>0 (with HI)
# The slope of the regression equation describing life expactancy from 
#  average $ days freezing is greater than zero. (With HI)
summary(modelYesHI)

# According to both of these analyses: There is evidence (statistically
#  significant) that the life expectancy in states with more average # 
#  of days freezing is higher (on average)

# Quick aside - let's construct a 80% CI for the no HI data:
Tstar=qt(.9, df=47)
c(b1hat.noHI-Tstar*SEb1hat.noHI, b1hat.noHI+Tstar*SEb1hat.noHI)

# We are 80% confident that the slope decribing the relationship between
#  Avg # days freezing and life expectancy is between (0.00525, 0.01431)