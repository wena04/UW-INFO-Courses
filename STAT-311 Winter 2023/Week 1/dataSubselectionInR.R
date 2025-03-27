# Consider the following (fictional) data consisting of a population
#  of students at a local highschool. 
students<-read.csv('artificialStudentData.csv')

# The head and tail commands show us the top 6 or bottom 6 of the dataset
head(students)
tail(students)

# The dim command can show us how much data we have in total
#  by showing the data frame dimension, number of rows then columns
dim(students)

# The names command can show us all the vectors in the dataframe
names(students)

# Imagine we want to take samples from this population, we need
#  a way to subselect data from this dataset: let's review that first

# We can index into a list using a number of different techniques.
exampleList<-c("A","B","C","D","E","F","G")

# As we have previously seen, we can request specific indexes
#  using either an individual index, or a list of indices
exampleList[1]
exampleList[5]
exampleList[c(1,5)]

# We can do the same for our students by specifying rows
students[100, ]
students[850, ]
students[c(100,850), ]

# In practice, it can be easier to index using a vector of TRUE/FALSE
#  For each index with value TRUE, the value is returned
exampleList[c(TRUE,FALSE,TRUE,TRUE,FALSE,FALSE,TRUE)]

# As expected, we can do the same to select rows of the student data
head(students)
head(students)[c(TRUE,FALSE,TRUE,FALSE,FALSE,TRUE), ]

# While this isn't useful to do by hand, it can make subselecting
#  specific individuals in the data very easy

# Let's try and make a list of only Freshman students
# We can see all the grade levels using the unique() function
gradeLevels=unique(students$gradeLevel)
gradeLevels

# We can make a list that is TRUE for rows with Freshman, and 
#  FALSE for rows with other grade levels using the logical 
#  operation ==
students$gradeLevel==gradeLevels[1]
# This is the same as students$gradeLevel=="Freshman"

# We will call this vector freshman.tf
#  using ( ) can help ensure there is no confusion about the ==
freshman.tf=(students$gradeLevel==gradeLevels[1])

# We can then use that list to get a data frame of students
#  who are Freshman, ignoring the rest, by indexing for the rows
freshmen=students[freshman.tf, ]

# We can get the same data frame without saving intermediate 
#  terms using a command like so 
students[(students$gradeLevel==gradeLevels[1]), ]

# Once we have our data frame of Freshmen, we can try and
#  take a random sample from this reduced population
#  using the sample command to choose rows to keep
?sample

# sample() will take a list and return some subset of items
#  from the list, by default without replacement.
sample(c(1,2,3,4,5), 3)
sample(1:10, 6)

# We are unsure how many freshman there are, so we need to find
#  that information using the dim() function
n.freshmen=dim(freshmen)[1]
n.freshmen

# Then we can select which freshmen are going to be in our sample
#  we will sample 50 students from the freshmen class
random.rows.freshmen=sample(1:n.freshmen, 50)
sampled.freshmen=freshmen[random.rows.freshmen, ]

# Reminder that . is a character like any other, and is not
#  handled as in other languages with variable definitions
#  these variables are just called "random.rows.freshmen"
#  and "sampled.freshmen", "sampled" and "random.rows"
#  are not objects in an of themselves.

# Let's construct a stratified sample of 50 students from each
#  grade level; freshmen are done, so let's create a random set of 
#  students from the other grade levels, repeating the same process
sophomores=students[(students$gradeLevel==gradeLevels[2]), ]
n.sophomores=dim(sophomores)[1]
random.rows.sophomores=sample(1:n.sophomores, 50)
sampled.sophomores=sophomores[random.rows.sophomores, ]

juniors=students[(students$gradeLevel==gradeLevels[3]), ]
n.juniors=dim(juniors)[1]
random.rows.juniors=sample(1:n.juniors, 50)
sampled.juniors=juniors[random.rows.juniors, ]

seniors=students[(students$gradeLevel==gradeLevels[4]), ]
n.seniors=dim(seniors)[1]
random.rows.seniors=sample(1:n.seniors, 50)
sampled.seniors=seniors[random.rows.seniors, ]

# We are repeating the same steps each time; perhaps this would work
#  better as a loop or function? Regardless, we now have 50 random 
#  students from each of the grade levels. Let's put them all 
#  into a single dataframe using the row bind command, rbind()
stratified.sample=rbind(sampled.freshmen, sampled.sophomores, 
                        sampled.juniors, sampled.seniors)

# We can check the results using the table command
table(stratified.sample$gradeLevel)

# Let's try constructing a cluster sample using the homeroom 
#  of the students. We can get a list of all homerooms using the
#  unique() function, as was done with grade levels.
# We of course return to our original, full "students" data frame
homerooms=unique(students$homeroom)
homerooms

# We can use the sample command again to directly sample which
#  homerooms will be a part of our sample. We will sample 10 clusters
clusters=sample(homerooms, 10)
clusters

# We can then use rbind to create this new cluster sample, but
#  it looks a bit tedius...
cluster.sample1 = 
      rbind(students[students$homeroom==clusters[1], ],
      students[students$homeroom==clusters[2], ],
      students[students$homeroom==clusters[3], ],
      students[students$homeroom==clusters[4], ],
      students[students$homeroom==clusters[5], ],
      students[students$homeroom==clusters[6], ],
      students[students$homeroom==clusters[7], ],
      students[students$homeroom==clusters[8], ],
      students[students$homeroom==clusters[9], ],
      students[students$homeroom==clusters[10],])
# Because each of these lines remains open, either unresolving
#  the = or not closing the function, R treats this all as one line.

# Let's try and do the same but in a cleaner manner using a for loop

# First we need to create an empty data frame, but it should match
#  the structure of the original; we can do this by taking the
#  "0th" row as our starting data frame.
cluster.sample2=students[0, ]

for(cluster in clusters){
  print(paste("Sampling cluster",cluster))
  # first we sample the cluster as above
  temporary=students[students$homeroom==cluster, ]
  # then we put it together with the rest of the sampled clusters
  cluster.sample2 = rbind(cluster.sample2, temporary)
  # note that we rbind the current list of cluster.sample2 
  #  with the newest cluster we sampled
}

# We can double check that we did things properly by looking
#  at a table of the homeroom values
table(cluster.sample1$homeroom)
table(cluster.sample2$homeroom)

# From the population of students, we have now created a stratified
#  sample by class level, and a clustered sample by homeroom!
