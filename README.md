# Project assignment in Getting and Cleaning Data

The run_analysis.R script assumes you are in the right directory and everything is
setup as is should be. No checking of any kind is performed for any necesarry library or
file.

## Reading data in
First of there are six files containing raw data and we need to read and merge rows with rbind. There are theree files for test and there files for training. I have used function 
"read.table()" for reading data.
The files are:

- X_test.txt (contains 561 columns)
- y_test.txt
- subject_test.txt
- X_train.txt (contains 561 columns)
- y_train.txt
- subject_train.txt

I read X_test.txt and then I add a column containg y_test.txt and another column containing subject_test.txt

I do the same for the training data set and then I use "rbind()" to concatenate two data frames.

End result is data frame with 563 columns.

## Reading the columns table
There is a file named "features.txt" and it contains 561 rows of data in 2 columns. First column
is row number and the second one is column name which represents columns in "X_test.txt" and "X_train.txt"

## Cleaning column names
After reading "features.txt" into a data frame I clean that data frame by replacing 
- string "-mean" with string "mmean"
- string "-std" with string "sstd"
- any character within squared brackets "[-|\\(),]" with ""
with function "gsub()". I also called "tolower()" function to set everything to lower case so I've ended up with clean column names

After that I did cal "grep()" with selective parameters ".*mmean.*|.*sstd.*" and I've ended up
with vector of rows that were conating "mmean" or "sstd" and those were my column names,
79 of them, that I've ended up using.

Finally I call "colnames()" and set those column names to the previously selected ones. I also
add two more column names to those i.e. "activity" and "subject".

## Descriptive activity names
Values in column "activity" has a numeric value and has to be replaced with a string i.e. 
- 1 => "WALKING"

The string values for "activty" column are supplied in file "activity_labels.txt" so that gets
loaded into data frame and then I cycle with a "for" loop and I use function "gsub()" to
apply new values. I suppose here I could instead use a function from "apply" family.

## Agreggate
I pass "mean()" function to the "agreggate()" function with list of columns "activity" and
"subject" and those are my grouping sets. I have ended up with 83 columns so what I did is
visually inspect first and last columns and as a result I did a subset of subset "agTidy" (result of calling "agreggate()" function) with "agTidy = agTidy[, 3:81]"

## Writing to file
As the last thing I did is call "write.table()" with parameters "tidy.txt" for file and
"row.names=FALSE" for not writing row numbers into my tidy text file. I used "\t" as a 
separator so the file should be uploaded by calling function "read.table()" with "\t" for
a separator parameter.

## MORE
You can find out more about the data itself in the "CodeBook.md" that is included in
this repo.
 
