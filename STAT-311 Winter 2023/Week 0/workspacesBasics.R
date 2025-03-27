# When RStudio is opened it will set a workspace according 
#  to how it was opened, opening RStudio directly uses the default.
# You can find the current working directory via getwd()
getwd()

# If you need to change the working directory, you can use 
#  setwd("path\to\dir")
# setwd("C:\Users\AnneA\Dropbox\TeachingStuffs\STAT311-24W\Lectures\RBasics")

# Unfortunately Windows users have a conflict 
#  as the \ command is a special character

# You can resolve by replacing every \ with \\
setwd("C:\\Users\\AnneA\\Dropbox\\TeachingStuffs\\STAT311-24W\\Lectures\\RBasics")

# The working directory be used to save your progress, in a hidden file
#  called .RData
# When you exit RStudio it will prompt to save
#  and can maintain the progress of your current code. This can be
#  helpful, but it can also cause confusion and errors.
var.1<-c("Hello", "World")
var.2<-pi

# CLOSE

# Opening from the folder directly will start the workspace
#  in the folder.
getwd()

# If you create or read a data file, it will create or look for the
#  file in the working directory. 
# We can save the iris data and reload it.
write.csv(iris, file="SavedIrisData.csv")
read.csv("SavedIrisData.csv")

# It seems we got a bit more than we hoped for, check the optional
#  arguments to ?write.csv and see if you can discover the issue.
# There is an extra X variable that counts the observation number.
?write.csv

# It can be good practice to reset the working environment and rerun
#  your code, to ensure there are no errors - what if we rename the
#  variables above and try and use them?
print(var.1)

# The variables is saved in the workspace, so still accessible.
#  We can fix the above print command and ensure everything is working
#  by resetting the working environment and 
#  running the source("filename") command, 
#  which is easiest by clicking the source button above.

rm(list=ls()) #Will remove all variables and loaded data
# Watch the environment window in the top right when run.