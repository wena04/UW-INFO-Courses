#Let's save our sample sizes, which are same as before
naz=649
nwv=600

# Do you agree with... 
# Making pre-school free for all three and four year-old children
az.q2a=467;
wv.q2a=438;

# Do you strongly agree or agree?
az.q2=312
wv.q2=342

# Let's start with comparing the strongly-agree proportions:
paz=az.q2/naz
pwv=wv.q2/nwv

#H0: The proportions strongly-agreeing is equal for WV and AZ
# paz = pwv
#Ha: The proportions strongly-agreeing is not equal for WV and AZ
# paz != pwv 
paz; pwv

ppooled=(az.q2+wv.q2)/(naz+nwv)
pp=ppooled

SEpooled=sqrt(pp*(1-pp)/naz+pp*(1-pp)/nwv)

Z=((pwv-paz)-0)/SEpooled

p.val=pnorm(abs(Z), lower.tail=FALSE)*2

# Because the p-value is <5%, we can reject H0 and conclude
#  the proportion strongly-agreeing with free preschool for 
#  3 and 4 year olds is not the same for AZ and WV.

prop.test(x=c(az.q2, wv.q2), n=c(naz, nwv), correct=FALSE)
prop.test(x=c(az.q2, wv.q2), n=c(naz, nwv), alternative="less", correct=TRUE)


# What about testing for any agreement?
# Do you agree with... 
# Making pre-school free for all three and four year-old children
az.q2a=467;
wv.q2a=438;

paz=az.q2a/naz
pwv=wv.q2a/nwv

#H0: The proportions agreeing is equal for WV and AZ
#Ha: The proportions agreeing is not equal for WV and AZ
paz; pwv

ppooled=(az.q2a+wv.q2a)/(naz+nwv)
pp=ppooled

SEpooled=sqrt(pp*(1-pp)/naz+pp*(1-pp)/nwv)

Z=(paz-pwv)/SEpooled

p.val=pnorm(Z)*2

# Our p-value is greater than 5%, thus we fail to reject H0
#  we do not have significant evidence that the proportion of voters
#  who agree with the statement is different for AZ and WV.

prop.test(x=c(az.q2a, wv.q2a), n=c(naz, nwv))
