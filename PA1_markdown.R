
# Firstly, Load the data and preprocess the data file activity.csv

mydir <- setwd("~/study_coursera/Data Science/5_Reproducible_Research/2W/work/")
.mystepdata <- read.csv("./repdata-data-activity/activity.csv",header=T, colClasses="character")

#.filteredstepdata <- subset(.mystepdata, .mystepdata$steps != "NA", NA.rm=TRUE) 

####.filteredstepdata <- subset(.mystepdata, .mystepdata$steps != "NA")

.filteredstepdata <- .mystepdata[complete.cases(.mystepdata), ]

# what is the mean total number of steps taken per day?

# You can use the rowsum and group the data by the date values. 
#The resultant data is summed on steps by date

rowsum(as.numeric(.filteredstepdata$steps), group = .filteredstepdata$date)

'
            [,1]
2012-10-02   126
2012-10-03 11352
2012-10-04 12116
2012-10-05 13294
2012-10-06 15420
2012-10-07 11015
2012-10-09 12811
2012-10-10  9900
2012-10-11 10304
2012-10-12 17382
2012-10-13 12426
2012-10-14 15098
2012-10-15 10139
2012-10-16 15084
2012-10-17 13452
2012-10-18 10056
2012-10-19 11829
2012-10-20 10395
2012-10-21  8821
2012-10-22 13460
2012-10-23  8918
2012-10-24  8355
2012-10-25  2492
2012-10-26  6778
2012-10-27 10119
2012-10-28 11458
2012-10-29  5018
2012-10-30  9819
2012-10-31 15414
2012-11-02 10600
2012-11-03 10571
2012-11-05 10439
2012-11-06  8334
2012-11-07 12883
2012-11-08  3219
2012-11-11 12608
2012-11-12 10765
2012-11-13  7336
2012-11-15    41
2012-11-16  5441
2012-11-17 14339
2012-11-18 15110
2012-11-19  8841
2012-11-20  4472
2012-11-21 12787
2012-11-22 20427
2012-11-23 21194
2012-11-24 14478
2012-11-25 11834
2012-11-26 11162
2012-11-27 13646
2012-11-28 10183
2012-11-29  7047'

# This one actually receives the rowsum of the filtered data set (after removing the NA's)
# Passes this set to hist which plots the histogram of the data. Frequency on Y-Axis and Total # of steps taken

.sum_of_steps_taken_by_date <- rowsum(as.numeric(.filteredstepdata$steps), group = .filteredstepdata$date)

hist(.sum_of_steps_taken_by_date, main = "Histogram of total number of steps per day",xlab = "Steps per day")

# here is my histogram showing the total number of steps taken each day [Histogram] histo_plot_step_Data.png

# Calculate and report the mean of the total number of steps taken per day

mean(.sum_of_steps_taken_by_date)

#> mean(rowsum(as.numeric(.filteredstepdata$steps), group = .filteredstepdata$date))
## [1] 10766.19

# Rounded mean
round(mean(.sum_of_steps_taken_by_date))


# Calculate and report the median of the total number of steps taken per day

median(.sum_of_steps_taken_by_date)

#> median(rowsum(as.numeric(.filteredstepdata$steps), group = .filteredstepdata$date))
## [1] 10765

summary(.sum_of_steps_taken_by_date)

'
summary(.sum_of_steps_taken_by_date)
V1       
Min.   :   41  
1st Qu.: 8841  
Median :10765  
Mean   :10766  
3rd Qu.:13294  
Max.   :21194  
'

##avg_step_interval <- aggregate(steps ~ interval, .sum_of_steps_taken_by_date, mean)
# Now find out the maximum steps in any interval.

maxsteps <- which.max(.mystepdata$steps)
#maxstepinterval <- paste(which.max(.mystepdata$steps), which.max(.mystepdata$interval))

maxinterval <- which.max(.mystepdata$interval)
print (paste("The maximum # of steps found in the data is with steps",maxsteps, "in the Interval", maxinterval,"of the activity data set"))

ts.plot(.sum_of_steps_taken_by_date,gpars=list(xlab = "Minute interval", ylab = "Across all days (Averaged)"))

## Imputing Missing values
## Calculate and report the total number of missing values in the dataset
## i.e. the total number of rows with NA's

nacounts <- .mystepdata[!complete.cases(.mystepdata), ]

print (nrow(nacounts))
##[1] 2304


# Then identify the avg steps for that interval in avg_steps_per_interval
# Substitute the NA value with that value

#average_steps_per_day <- aggregate(steps ~ date, .mystepdata, mean)

#average_steps_per_interval <- aggregate(steps ~ interval, .mystepdata, mean)

#plot(average_steps_per_interval$interval, average_steps_per_interval$steps, 
#     type='l', col=1, 
#     main="Average number of steps by Interval", 
#     xlab="Time Intervals", ylab="Average number of steps")

#for (i in 1:nrow(.mystepdata)) {
#  if(is.na(.mystepdata$steps[i])) {
#    val <- average_steps_per_interval$steps[which(average_steps_per_interval$interval == .mystepdata$interval[i])]
#    .mystepdata$steps[i] <- val 
#  }
#}

# Aggregate the steps per day with the imputed values
#steps_per_day_imputed <- aggregate(steps ~ date, .mystepdata, sum)
#steps_per_day_imputed <- rowsum(as.numeric(.mystepdata$steps), group = .mystepdata$date)

# Draw a histogram of the value 
#hist(steps_per_day_imputed$steps, main = "Histogram of total number of steps per day (IMPUTED)", xlab = "Steps per day", ylab = "Test")


# Calculate the mean and median of the total number of steps taken per day
#round(mean(steps_per_day_imputed$steps))


week_day <- function(date_valu) {
  wd <- weekdays(as.Date(date_valu, '%Y-%m-%d'))
  if  (!(wd == 'Saturday' || wd == 'Sunday')) {
    x <- 'Weekday'
  } else {
    x <- 'Weekend'
  }
  x
}

# Apply the week_day function and add a new column to .mystepdata dataset
.mystepdata$day_type <- as.factor(sapply(.mystepdata$date, week_day))

#load the ggplot library
library(ggplot2)

# Create the aggregated data frame by intervals and the day_type
steps_per_day_imputed <- aggregate(steps ~ interval+day_type, .mystepdata, mean)

# Create the plot
plt <- ggplot(steps_per_day_imputed, aes(interval, steps)) +
  geom_line(stat = "identity", aes(colour = day_type)) + theme_gray() +
  facet_grid(day_type ~ ., scales="fixed", space="fixed") +
  labs(x="Interval", y=expression("No of Steps ")) +
  ggtitle("No of steps Per Interval by daytype ")
print(plt)