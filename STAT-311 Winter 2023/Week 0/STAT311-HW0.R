## ## ## ## ## DO NOT MODIFY BELOW ## ## ## ## ## 
sampleData1<-read.csv('SampleData.csv',header=FALSE)
sampleData2<-matrix(20:28,nrow=3)
## ## ## ## ## DO NOT MODIFY ABOVE ## ## ## ## ## 

# PART 1
# Create a vector of length 5 with values 1, 2, 3, 4, 7
# Call it "myVector"
myVector <- c(1,2,3,4,7)

# PART 2
# Create a string containing your name
# Call it "myString"
myString <- "Anthony Wen"

# PART 3
# Create a function that takes a single variable and
#  returns a vector equal to the sum of the rows of 
#  a 3x3 matrix or dataframe
# Call it "myFunction"
myFunction <- function(input){
  mysum <- c(0,0,0)
  for (i in 1:3){
    for (j in 1:3){
      mysum[i] <- mysum[i]+input[i,j]
    }
  }
  return(mysum)
}

## ## ## ## ## DO NOT MODIFY BELOW ## ## ## ## ## 
# The code below should return TRUE
myResult1<-myFunction(sampleData1)
all(myResult1==c(6,15,24))
myResult2<-myFunction(sampleData2)
all(myResult2==c(69,72,75))
## ## ## ## ## DO NOT MODIFY ABOVE ## ## ## ## ## 