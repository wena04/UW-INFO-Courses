# FUNCTIONS

# Let's look back back at one of the functions we used
variable.a=526
variable.b=7547.235

# Why didn't the function give us this value?
mean(variable.a, variable.b)
(variable.a+variable.b)/2

# We can view documentation of a function by using the ?command
?mean

# It lists the default method as mean(x, trim = 0, na.rm = FALSE, ...)
#  Because we passed it two variables, the first was treated as x, 
#  and the second was taken as trim. 
# If we want to calculate standard mean, we need to pass the function one variable
variables.all=c(variable.a, variable.b)
mean(variables.all)

# We need to pass a single variable in; a list of values to find the mean of.

# Some functions have default arguments, such as sort()
#  sort(x, decreasing = FALSE, na.last = NA, ...)
tosort=c(3,4,7,2,3,5,8,8,4,2,34,7,5,3,NA,2,3,6,NA)
sort(tosort)

# By default, sort orders them in increasing order
sort(tosort, decreasing=FALSE)

#  if you need the order reversed, you can set decreasing to TRUE
sort(tosort, decreasing=TRUE)

#  TRUE, FALSE, and NA are all special variables for boolean true/false, and null values
sort(tosort, decreasing=TRUE, na.last=FALSE)
sort(tosort, na.last=FALSE)
sort(tosort, FALSE)
sort(tosort, FALSE, FALSE)

# Looking back at our mean command

# It appears it was trying to take variable.b as the trim argument, which should have been
#  between 0 and .5, and was thus ignored, implying we calculated the mean of just variable.a


# You can create your own functions as well, and can set your own default values
#  by using the function() function
# Use the return() function to determine what your function sends back
trisum<-function(funcvar.1, funcvar.2=10, funcvar.3=100){
  tempsum=funcvar.1+funcvar.2+funcvar.3
  return(tempsum)
}

# The default values will be used unless other values are specified
trisum(5)

# Variables are taken in order, but if you want to specify a specific one, you can use 
#  the variable name in the function call
trisum(5,2,3)
trisum(5, funcvar.3=50)
trisum()

testvar=150
printtestvar<-function(funcvar.1){
  print(testvar)
}

# LOOPS

# While loops are not very different than other languages
counter=0
while(counter<10){
  print(counter)
  counter=counter+1
}

while(TRUE){
  print("Help I am trapped in a while loop")
}

# For loops are similar to other languages in that you use the loop to define a variable
# but you do not provide an end condition for the loop, rather it is defined over the 
# space of the defined variable
variables.matrix<-matrix(0,nrow=3,ncol=6)

for(x in 1:3){
  for(y in 1:6){
    variables.matrix[x,y]=x*y
  }
}

for(x in 1:10){
  print(x)
}


temp=3
if(temp<4){
  print("low")
} else if (temp<10){ 
  print("medium")  
} else {
  print("high")
}
