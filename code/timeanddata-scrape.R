library(tidyverse)
library(rvest)

#Using rvest to extract sunrise and sunset data
#A function that takes in the url and month number
dfmonth <- function(url, number) {
  
  #Extraction of the table
  page <- read_html(url)
  tables <- page %>% html_table(fill = TRUE)
  tables %>% str
  weather<- tables[[2]]
  
  #Setting names to date, sunrise, and sunset
  names(weather)[1] <- "Date"
  names(weather)[2] <- "Sunrise"
  names(weather)[3] <- "Sunset" 
  names(weather)[4] <- "Daylight"
  
  
  #The first day for each month in the dataframe is in it's own column, so I created a new dataframe with the pertinent intformation and renamed those columns
  weather2 <-weather[14:17]
  names(weather2)[1] <- "Date"
  names(weather2)[2] <- "Sunrise"
  names(weather2)[3] <- "Sunset"
  names(weather2)[4] <- "Daylight"
  
  #I then changed the Date to a character so it can be merged with the other data
  weather2$Date <- as.character(weather2$Date)
  
  #I select only the pertinent data from the original weather data set
  weather <- weather[1:4]
  
  #Next, I join the data sets while omitting NA values
  final_weather <- full_join(na.omit(weather), na.omit(weather2))
  
  #The first day in the dataset will be at the end, so I move it towards the front
  final_weather[1,]<- final_weather[nrow(final_weather),]
  
  #Next, I remove the labels that stuck onto this dataset that are unnecessary
  final_weather <- final_weather[-2,]
  
  #The last two rows are removed because they contain a copy of day 1 and some additional information from the webpage
  final_weather <- final_weather[-nrow(final_weather)+1: -nrow(final_weather),]
  
  #These loops are to deal with notices for time changes. If there is a time change notice in the dataframe, they are removed.
  if (any(final_weather == "Note: hours shift because clocks change forward 1 hour. (See the note below this table for details)")){
    final_weather <-final_weather[-which(final_weather$Sunrise ==  "Note: hours shift because clocks change forward 1 hour. (See the note below this table for details)"),]
  } else if (any(final_weather == "Note: hours shift because clocks change backward 1 hour. (See the note below this table for details)")){
    final_weather <- final_weather[-which(final_weather$Sunrise == "Note: hours shift because clocks change backward 1 hour. (See the note below this table for details)"),]
  }
  
  #Creating a new column that corresponds to the month number
  final_weather$Month <- number
  
  #Seperating additional informatoin from the sunset and sunrise times in the graph
  final_weather<-final_weather%>%
    separate(col = Sunrise, into = c("Sunrise Time", NA), remove = TRUE, sep = " ↑")
  
  final_weather<-final_weather%>%
    separate(col = Sunset, into = c("Sunset Time", NA), remove = TRUE, sep = " ↑")
  
  #Making the sunset time in Hour:Minute:Second format
  final_weather$`Sunset Time` <- format(strptime(final_weather$`Sunset Time`, "%I:%M %p"), format="%H:%M:%S")
  
  final_weather$`Sunrise Time` <- format(strptime(final_weather$`Sunrise Time`, "%I:%M %p"), format="%H:%M:%S")
  
  
  #Making the data type of sunset and sunrise an hms so it can be compared to the original data
  final_weather$`Sunrise Time` <- as_hms(final_weather$`Sunrise Time`)
  final_weather$`Sunset Time` <- as_hms(final_weather$`Sunset Time`)
  final_weather$`Daylight` <- as_hms(final_weather$`Daylight`)
  
  #Returns the altered dataframe
  return (final_weather)
}


#Creating a dataframe using my previous function in the month January
#I'm choosing 2020 because it is the most recent leap year - so I will have data for February 29th. I'm choosing Ames because it is close to the geographical center of Iowa
sun<- dfmonth("https://www.timeanddate.com/sun/@4846834?month=1&year=2020", 1)

#For the rest of the months, I run this loop and join them with the dataframe
for (i in 2:12){
  url<- paste0("https://www.timeanddate.com/sun/@4846834?month=", i, "&year=2020")
  dfTemp<- dfmonth(url, i)
  sun<- full_join(sun, dfTemp)
  
}

#Checking if there are any null values 
sum(is.na(sun$`Sunrise Time`))
sum(is.na(sun$`Date`))
sum(is.na(sun$`Sunset Time`))
sum(is.na(sun$`Daylight`))

write_csv(sun, "data/ames-sunset-sunrise-2020.csv")
