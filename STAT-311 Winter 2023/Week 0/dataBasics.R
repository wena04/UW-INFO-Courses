# RStudio allows for formatting code, running code, reviewing current 
# variables, viewing plots, and reviewing documentation. It is an IDE
# for working with R, which is a coding language used by many statisticians. 


# Comments can be added to code by using # to comment out a line!
"The area in the top left is for writing code, but is just a text editor."
"We can run code by using the run command, which can be accessed via hotkeys"
# The above lines run just fine, as the R intrepreter treats them as text, but this line throws an error (Which Rstudio warns about!)
# Be sure to comment the above line out or it makes Rstudio sad.


# Variables are created using <- or = to assign a value; 
#  . or numbers can be used in variables names, but not first
variable.a<-526
variable.b=7634.236
variable.c="Hello"

# We can use these variables in calculations
variable.a^(1/2)
(variable.a+variable.b)/2
# or pass them to functions, which are called via 
#  functionname(argument1, argument2, ...)
sqrt(variable.a)
mean(variable.a, variable.b)

# This mean function doesn't work like we'd expect... what's happening?


# We can view a variable by just typing its name
variable.a
#  or using the print function, which in necessary inside a custom function 
print(variable.a)

# R does not require specifying the class of a variable (IE: string, integer, double), 
#  but we can see what type of class a variable is with the class() function
class(variable.a)
class(variable.b)
class(variable.c)

# We can create a list or vector of variables, using the function c(), which is short for 'combine'
#  Each argument to the function is separated by a comma.
variables.all=c(variable.a, variable.b, variable.c, "one more", 1)
variables.all
class(variables.all)

# R forces the vector into a single datatype - if the variables you pass to 
# a function aren't an appropriate type, R will attempt to fix it, will ignore them, 
#  or will throw an error.


# One common type of class you will see is 'factor'
class(iris$Species)
# This is a reflection of the statistical focus of R, where factors represent 
#  categorical variables, such as the species of a flower

# The iris dataset is loaded into R and accessible at any time
unique(iris$Species)
print(iris)

# If we want to access a specific value in a vector, we index it with 
# vectorvariable[index]
variables.all

# Note that R is 1 indexed, meaning the first value in a list is 1, not 0.
variables.all[1]
variables.all[4]


# ADVANCED DATA STRUCTURES
# 

# Aside from storing data as individual values or lists (vectors), bigger 
# datasets are often
#  handled as either matrices or data frames (which function very similarly)
# Note that R is not designed for high dimensional data structures, but does 
# have some limited capability

# We can make a matrix with the matrix() function
#  We will make a 3x6 matrix of zeroes.
variable.matrix<-matrix(0, nrow=3, ncol=6)

# We can access an individual value in the matrix by indexing with 
#  matrixvariable[row, column]
variable.matrix[2,4]=24
variable.matrix

# We can also access a row or column by including a comma, 
#  but removing one of the digits.
variable.matrix[2,]
variable.matrix[,4]

# If we assign a value to a row or column, it will try to apply it 
#  to the whole row or column
variable.matrix[1,]=1
variable.matrix[,2]=2
variable.matrix

# We can pass in a list of values

# if the list is too short it will repeat values if possible
variable.matrix[3,]=c(1,2,3,4)#This fails
variable.matrix[3,]=c(1,2,3)#This passes
variable.matrix

variable.matrix[,c(1,3,4)]
variable.matrix[c(1,3),]
variable.matrix[c(TRUE, FALSE, TRUE),]

# Much of the data we will explore in this course will be in the form of dataframes
#  these data structures combine together many vectors, such as the iris dataset
# Let's make our own first, to describe 4 different creatures
var.1=c("cat","dog","bird","spider")
var.2=c(2,2,2,8)
var.3=c(4,4,2,8)

# We put them together into a dataframe, and can name each column of the dataframe 
creatures.df=data.frame(species=var.1, eyes=var.2, legs=var.3)
creatures.df

# Each column of the dataframe can be accessed by using dataframe$column
creatures.df$eyes

# or by indexing the column like a matrix
creatures.df[,2]

# You can view a single observation by indexing the row
creatures.df[2,2]
creatures.df[2,]

# What happens if we index without a comma?
creatures.df[2]

# A dataframe is an array of arrays, so it is passing us the third item, 
#  the array for legs

# The colon command can be used to create lists of sequential numbers
1:5
