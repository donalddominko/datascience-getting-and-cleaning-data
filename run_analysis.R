run_analysis = function(){
        
        # This function does assume everything is in it proper place i.e. does not check
        # if the files exist or not, packages installed, ...
        
        # Let's start reading test files and add two columns
        df1 = read.table("./UCI\ HAR\ Dataset/test/X_test.txt", header=FALSE)
        df1[562] = read.table("./UCI\ HAR\ Dataset/test/y_test.txt", header=FALSE)
        df1[563] = read.table("./UCI\ HAR\ Dataset/test/subject_test.txt", header=FALSE)
                
        # Now we read train files and add two columns
        df2 = read.table("./UCI\ HAR\ Dataset/train/X_train.txt", header=FALSE)
        df2[562] = read.table("./UCI\ HAR\ Dataset/train/y_train.txt", header=FALSE)
        df2[563] = read.table("./UCI\ HAR\ Dataset/train/subject_train.txt", header=FALSE)
        
        
        ## Bind train and test rows
        # Make data set ready and we can subset the columns we need 
        dfAll = rbind(df2, df1) # We have data set ready
        
        
        # Remove temp data frames from memory - Environment friendly housekeeping
        rm(df1);rm(df2)
        
                
        ## Reading the columns table
        # Read all columns into dataframe so we can pick and choose mean() and dev() columns
        dfFeatures = read.table("./UCI\ HAR\ Dataset/features.txt", header=FALSE)
        dfFeaturesClean = dfFeatures # We might need dfFeatures later TODO: Remove?
        dfFeaturesClean[, 2] = gsub("-mean", "mmean", dfFeaturesClean[, 2])
        dfFeaturesClean[, 2] = gsub("-std", "sstd", dfFeaturesClean[, 2])
        dfFeaturesClean[, 2] = gsub("[-|\\(),]", "", tolower(dfFeaturesClean[, 2]))
        
        
        # Vector of integers for columns we want to read
        vinColsOK = grep(".*mmean.*|.*sstd.*", dfFeaturesClean[,2])
        
        # We select lowever case colls that were OK
        vinColsSelect = dfFeaturesClean[vinColsOK, ]
        
        # We add additional two last columns that we'll want
        vinColsOK = c(vinColsOK, 562, 563)
        
        # And we select all rows with selected we want to read
        dfAllColsOK = dfAll[, vinColsOK]
        rm(dfAll) # Housekeeping
        
        # Finally we add those column names and we can get rid of dfAll
        colnames(dfAllColsOK) = c(vinColsSelect[[2]], "activity", "subject")
        
        
        ## Descriptive activity names
        # Let's fix those descriptive activiy names
        dfActivity = read.table("./UCI\ HAR\ Dataset/activity_labels.txt", header=FALSE)
        
        # Now we can cycle through the activity column and replace everything with gsub
        for(i in dfActivity[[1]]) {
                #dfAllColsOK[[80]] = gsub(i, dfActivity[[2]][i], dfAllColsOK[[80]])
                dfAllColsOK$activity = gsub(i, dfActivity[[2]][i], dfAllColsOK$activity)
        }
        
        
        ## Let's aggreate something
        # This is where we group by activity and subject. We could as well try 'dcast' here
        agTidy = aggregate(dfAllColsOK, by=list(activity=dfAllColsOK$activity, subject=dfAllColsOK$subject), mean)
        
        # Let's remove duplicate activity and subject i.e. we have 83 columns instead of 79
        agTidy = agTidy[, 3:81]
        
        
        ## Done
        # Finally we can write the file
        write.table(agTidy, "tidy.txt", sep="\t", row.names=FALSE)
        
}