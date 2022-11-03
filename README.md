
I love pufferfish

The goal of our project is to find what variables are most prominent
when causing crashes that are fatal, have significant crash severity, or
cause the most property damage. The variables we are looking at right
now include roadway type, roadway surface, environmental/weather
conditions, and light conditions. Eventually, we would like to create a
model to predict what conditions are most likely to cause serious
injuries.

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.3.6     ✔ purrr   0.3.4
    ## ✔ tibble  3.1.8     ✔ dplyr   1.0.9
    ## ✔ tidyr   1.2.0     ✔ stringr 1.4.1
    ## ✔ readr   2.1.2     ✔ forcats 0.5.2
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
#Use this if the below code doesn't work - file must be stored on your device.
#crashes <- read.csv("../Vehicle_Crashes_in_Iowa.csv")
crashes <- read_csv("https://media.githubusercontent.com/media/nathanrethwisch/Team-Pufferfish/main/Vehicle_Crashes_in_Iowa.csv")
```

    ## Rows: 728442 Columns: 37
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (26): Law Enforcement Case Number, Date of Crash, Month of Crash, Day o...
    ## dbl  (10): Iowa DOT Case Number, Number of Fatalities, Number of Injuries, N...
    ## time  (1): Time of Crash
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
#View(crashes)
```

``` r
dim(crashes)
```

    ## [1] 728442     37

``` r
str(crashes)
```

    ## spec_tbl_df [728,442 × 37] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
    ##  $ Iowa DOT Case Number           : num [1:728442] 2.01e+09 2.01e+09 2.01e+09 2.01e+09 2.01e+09 ...
    ##  $ Law Enforcement Case Number    : chr [1:728442] "0954" NA "09000001" "09000001" ...
    ##  $ Date of Crash                  : chr [1:728442] "01/01/2009" "01/01/2009" "01/01/2009" "01/01/2009" ...
    ##  $ Month of Crash                 : chr [1:728442] "01-January" "01-January" "01-January" "01-January" ...
    ##  $ Day of Week                    : chr [1:728442] "5-Thursday" "5-Thursday" "5-Thursday" "5-Thursday" ...
    ##  $ Time of Crash                  : 'hms' num [1:728442] 15:49:00 02:15:00 00:14:00 04:51:00 ...
    ##   ..- attr(*, "units")= chr "secs"
    ##  $ Hour                           : chr [1:728442] "Hour 16" "Hour 03" "Hour 01" "Hour 05" ...
    ##  $ DOT District                   : chr [1:728442] "District 6 (East Central)" "District 4 (Southwest)" "District 5 (Southeast)" "District 3 (Northwest)" ...
    ##  $ City Name                      : chr [1:728442] NA NA NA NA ...
    ##  $ County Name                    : chr [1:728442] NA NA NA NA ...
    ##  $ Route with System              : chr [1:728442] NA "IA 4" NA NA ...
    ##  $ Location Description           : chr [1:728442] "E DOVER CT" "IA 4/IOWA 4 & 170TH ST" "Co Rd J44/520TH ST" "Co Rd L36/D AVE" ...
    ##  $ First Harmful Event            : chr [1:728442] "Collision with:  Parked motor vehicle" "Collision with fixed object:  Other fixed object (explain in narrative)" "Collision with:  Animal" "Non-collision events:  Overturn/rollover" ...
    ##  $ Location of First Harmful Event: chr [1:728442] "On Roadway" "Shoulder" "On Roadway" "On Roadway" ...
    ##  $ Manner of Crash/Collision      : chr [1:728442] "Sideswipe, same direction" "Non-collision (single vehicle)" "Non-collision (single vehicle)" "Non-collision (single vehicle)" ...
    ##  $ Major Cause                    : chr [1:728442] "Lost Control" "Ran off road - right" "Animal" "Crossed centerline (undivided)" ...
    ##  $ Drug or Alcohol                : chr [1:728442] "None Indicated" "None Indicated" "None Indicated" "Alcohol (Statutory)" ...
    ##  $ Environmental Conditions       : chr [1:728442] "None apparent" "None apparent" "Animal in roadway" "None apparent" ...
    ##  $ Light Conditions               : chr [1:728442] "Daylight" "Dark - roadway not lighted" "Dark - roadway not lighted" "Dark - roadway not lighted" ...
    ##  $ Surface Conditions             : chr [1:728442] "Ice/frost" "Dry" "Dry" "Dry" ...
    ##  $ Weather Conditions             : chr [1:728442] "Cloudy" "Clear" "Clear" "Cloudy" ...
    ##  $ Roadway Contribution           : chr [1:728442] "None apparent" "None apparent" "None apparent" "None apparent" ...
    ##  $ Roadway Type                   : chr [1:728442] "Non-intersection:  Non-junction/no special feature" "Non-intersection:  Non-junction/no special feature" "Intersection:  Other intersection (explain in narrative)" "Non-intersection:  Non-junction/no special feature" ...
    ##  $ Roadway Surface                : chr [1:728442] "Paved" "Paved" "Unpaved" "Paved" ...
    ##  $ Work Zone                      : chr [1:728442] "N/A" "N/A" "N/A" "N/A" ...
    ##  $ Crash Severity                 : chr [1:728442] "Property Damage Only" "Property Damage Only" "Minor Injury" "Property Damage Only" ...
    ##  $ Number of Fatalities           : num [1:728442] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ Number of Injuries             : num [1:728442] 0 0 2 0 0 0 1 0 1 1 ...
    ##  $ Number of Major Injuries       : num [1:728442] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ Number of Minor Injuries       : num [1:728442] 0 0 1 0 0 0 0 0 0 1 ...
    ##  $ Number of Possible Injuries    : num [1:728442] 0 0 1 0 0 0 1 0 1 0 ...
    ##  $ Number of Unknown Injuries     : num [1:728442] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ Amount of Property Damage      : num [1:728442] 2000 5750 8000 2000 1000 ...
    ##  $ Number of Vehicles Involved    : num [1:728442] 2 1 1 1 1 2 1 2 2 2 ...
    ##  $ Total Number of Occupants      : num [1:728442] 1 1 2 1 1 2 2 4 2 3 ...
    ##  $ Travel Direction               : chr [1:728442] "N/A" "N/A" "N/A" "N/A" ...
    ##  $ Location                       : chr [1:728442] "POINT (-90.567730450144 41.54429908431)" "POINT (-94.367629082433 41.76148937584)" "POINT (-92.944073472578 40.725020835225)" "POINT (-95.799893234639 42.801520512692)" ...
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   `Iowa DOT Case Number` = col_double(),
    ##   ..   `Law Enforcement Case Number` = col_character(),
    ##   ..   `Date of Crash` = col_character(),
    ##   ..   `Month of Crash` = col_character(),
    ##   ..   `Day of Week` = col_character(),
    ##   ..   `Time of Crash` = col_time(format = ""),
    ##   ..   Hour = col_character(),
    ##   ..   `DOT District` = col_character(),
    ##   ..   `City Name` = col_character(),
    ##   ..   `County Name` = col_character(),
    ##   ..   `Route with System` = col_character(),
    ##   ..   `Location Description` = col_character(),
    ##   ..   `First Harmful Event` = col_character(),
    ##   ..   `Location of First Harmful Event` = col_character(),
    ##   ..   `Manner of Crash/Collision` = col_character(),
    ##   ..   `Major Cause` = col_character(),
    ##   ..   `Drug or Alcohol` = col_character(),
    ##   ..   `Environmental Conditions` = col_character(),
    ##   ..   `Light Conditions` = col_character(),
    ##   ..   `Surface Conditions` = col_character(),
    ##   ..   `Weather Conditions` = col_character(),
    ##   ..   `Roadway Contribution` = col_character(),
    ##   ..   `Roadway Type` = col_character(),
    ##   ..   `Roadway Surface` = col_character(),
    ##   ..   `Work Zone` = col_character(),
    ##   ..   `Crash Severity` = col_character(),
    ##   ..   `Number of Fatalities` = col_double(),
    ##   ..   `Number of Injuries` = col_double(),
    ##   ..   `Number of Major Injuries` = col_double(),
    ##   ..   `Number of Minor Injuries` = col_double(),
    ##   ..   `Number of Possible Injuries` = col_double(),
    ##   ..   `Number of Unknown Injuries` = col_double(),
    ##   ..   `Amount of Property Damage` = col_double(),
    ##   ..   `Number of Vehicles Involved` = col_double(),
    ##   ..   `Total Number of Occupants` = col_double(),
    ##   ..   `Travel Direction` = col_character(),
    ##   ..   Location = col_character()
    ##   .. )
    ##  - attr(*, "problems")=<externalptr>

``` r
#NA values are only found in Amount of Property Damage?
colSums(is.na(crashes))
```

    ##            Iowa DOT Case Number     Law Enforcement Case Number 
    ##                               0                           45587 
    ##                   Date of Crash                  Month of Crash 
    ##                               0                               0 
    ##                     Day of Week                   Time of Crash 
    ##                               0                               0 
    ##                            Hour                    DOT District 
    ##                               0                               0 
    ##                       City Name                     County Name 
    ##                          279583                          109894 
    ##               Route with System            Location Description 
    ##                          451161                           50640 
    ##             First Harmful Event Location of First Harmful Event 
    ##                               0                               0 
    ##       Manner of Crash/Collision                     Major Cause 
    ##                               0                               0 
    ##                 Drug or Alcohol        Environmental Conditions 
    ##                               0                               0 
    ##                Light Conditions              Surface Conditions 
    ##                               0                               0 
    ##              Weather Conditions            Roadway Contribution 
    ##                               0                               0 
    ##                    Roadway Type                 Roadway Surface 
    ##                               0                               0 
    ##                       Work Zone                  Crash Severity 
    ##                               0                               0 
    ##            Number of Fatalities              Number of Injuries 
    ##                               0                               0 
    ##        Number of Major Injuries        Number of Minor Injuries 
    ##                               0                               0 
    ##     Number of Possible Injuries      Number of Unknown Injuries 
    ##                               0                               0 
    ##       Amount of Property Damage     Number of Vehicles Involved 
    ##                               9                               0 
    ##       Total Number of Occupants                Travel Direction 
    ##                               0                               0 
    ##                        Location 
    ##                               1

``` r
#This is strange because it appears that City.Name has NA values
sum(is.na(crashes$`City Name`))
```

    ## [1] 279583

``` r
#Making blank and N/A value in NA
crashes$`City Name`[crashes$`City Name` == ""] <- NA
crashes$`County Name`[crashes$`County Name` == ""] <- NA
crashes$`Route with System`[crashes$`Route with System` == ""] <- NA
crashes[crashes=="N/A"]<-NA

#Making the case number an integer
crashes$`Law Enforcement Case Number` <- as.integer(crashes$`Law Enforcement Case Number`)
```

    ## Warning: NAs introduced by coercion

    ## Warning: NAs introduced by coercion to integer range

``` r
#Checking NA sums after we made changes to the dataset
colSums(is.na(crashes))
```

    ##            Iowa DOT Case Number     Law Enforcement Case Number 
    ##                               0                          527840 
    ##                   Date of Crash                  Month of Crash 
    ##                               0                               0 
    ##                     Day of Week                   Time of Crash 
    ##                               0                               0 
    ##                            Hour                    DOT District 
    ##                               0                               4 
    ##                       City Name                     County Name 
    ##                          279583                          109894 
    ##               Route with System            Location Description 
    ##                          451161                           50640 
    ##             First Harmful Event Location of First Harmful Event 
    ##                            2311                           23872 
    ##       Manner of Crash/Collision                     Major Cause 
    ##                           51205                               0 
    ##                 Drug or Alcohol        Environmental Conditions 
    ##                               0                           63550 
    ##                Light Conditions              Surface Conditions 
    ##                           71992                           72352 
    ##              Weather Conditions            Roadway Contribution 
    ##                           72784                           79089 
    ##                    Roadway Type                 Roadway Surface 
    ##                           68521                           50634 
    ##                       Work Zone                  Crash Severity 
    ##                          719474                               0 
    ##            Number of Fatalities              Number of Injuries 
    ##                               0                               0 
    ##        Number of Major Injuries        Number of Minor Injuries 
    ##                               0                               0 
    ##     Number of Possible Injuries      Number of Unknown Injuries 
    ##                               0                               0 
    ##       Amount of Property Damage     Number of Vehicles Involved 
    ##                               9                               0 
    ##       Total Number of Occupants                Travel Direction 
    ##                               0                          491785 
    ##                        Location 
    ##                               1

``` r
#Getting the distinct latitude and longitude
crashes<- crashes%>%
  separate(col = Location, into = c(NA, "Latitude", "Longitude"), remove =
             FALSE, sep = " ")

crashes<- crashes%>%mutate(Latitude = parse_number(Latitude), Longitude = parse_number(Longitude))
```

``` r
crashes$`Date of Crash` <- lubridate::mdy(crashes$`Date of Crash`)

#Creating a new columns that are separate for year, month, and day
crashes <- crashes%>%
  separate(col = `Date of Crash`, into = c("Year", "Month", "Day"), remove =
             FALSE, sep = "-")
View(crashes)
```

``` r
#Looking at the different crash severities
crashes%>%
  group_by(`Crash Severity`)%>%
  summarise(n = n())
```

    ## # A tibble: 5 × 2
    ##   `Crash Severity`          n
    ##   <chr>                 <int>
    ## 1 Fatal                  4323
    ## 2 Major Injury          16810
    ## 3 Minor Injury          65801
    ## 4 Possible/Unknown     115784
    ## 5 Property Damage Only 525724

``` r
#Roadway contribution to fatal car accidents
crashes%>%
  filter(`Crash Severity` == "Fatal")%>%
  group_by(`Roadway Contribution`)%>%
  summarise(n = n())
```

    ## # A tibble: 16 × 2
    ##    `Roadway Contribution`                           n
    ##    <chr>                                        <int>
    ##  1 Debris                                           8
    ##  2 Disabled vehicle                                12
    ##  3 Non-highway work                                 2
    ##  4 None apparent                                 3774
    ##  5 Obstruction in roadway                           3
    ##  6 Other (explain in narrative)                    24
    ##  7 Ruts/holes/bumps                                14
    ##  8 Shoulders (none, low, soft, high)               15
    ##  9 Slippery, loose, or worn surface                11
    ## 10 Surface condition (e.g., wet, icy)             306
    ## 11 Traffic backup, prior crash                      5
    ## 12 Traffic backup, prior non-recurring incident     3
    ## 13 Traffic backup, regular congestion               1
    ## 14 Unknown                                         56
    ## 15 Work Zone (roadway-related)                     84
    ## 16 <NA>                                             5

``` r
#The count of roadway contributions by injury severity
crashes%>%
  ggplot(aes(x = `Roadway Contribution`)) +geom_bar() + facet_wrap(~`Crash Severity`)+coord_flip()
```

![](README_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
#Map of all crashes in Iowa
crashes%>%
      ggplot(aes(x = Latitude, y = Longitude)) + geom_point()
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](README_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
#Crash severity grouped by roadway type
crashes2<- crashes%>%
  group_by(`Roadway Type`, `Crash Severity`)%>%
  summarise(n = n())
```

    ## `summarise()` has grouped output by 'Roadway Type'. You can override using the
    ## `.groups` argument.

``` r
crashes2[which.max(crashes2$n),]
```

    ## # A tibble: 1 × 3
    ## # Groups:   Roadway Type [1]
    ##   `Roadway Type`                                     `Crash Severity`          n
    ##   <chr>                                              <chr>                 <int>
    ## 1 Non-intersection:  Non-junction/no special feature Property Damage Only 243391

``` r
#The top cause of fatal crashes
crashes3<- crashes%>%
  filter(`Crash Severity` == "Fatal")%>%
  group_by(`Major Cause`)%>%
  summarise(n = n())

crashes3[which.max(crashes3$n),]
```

    ## # A tibble: 1 × 2
    ##   `Major Cause`            n
    ##   <chr>                <int>
    ## 1 Ran off road - right   708

``` r
#Looking at the top environmental and surface conditions for fatal accidents
Cause_crashes<- crashes%>%
  filter(`Crash Severity` == "Fatal")%>%
  group_by(`Environmental Conditions`, `Light Conditions`, `Surface Conditions`, `Weather Conditions`)%>%
  summarise(n = n())
```

    ## `summarise()` has grouped output by 'Environmental Conditions', 'Light
    ## Conditions', 'Surface Conditions'. You can override using the `.groups`
    ## argument.

``` r
Cause_crashes%>%filter(n > 100)
```

    ## # A tibble: 5 × 5
    ## # Groups:   Environmental Conditions, Light Conditions, Surface Conditions [3]
    ##   `Environmental Conditions` `Light Conditions`         Surface …¹ Weath…²     n
    ##   <chr>                      <chr>                      <chr>      <chr>   <int>
    ## 1 None apparent              Dark - roadway lighted     Dry        Clear     246
    ## 2 None apparent              Dark - roadway not lighted Dry        Clear     623
    ## 3 None apparent              Dark - roadway not lighted Dry        Cloudy    175
    ## 4 None apparent              Daylight                   Dry        Clear    1285
    ## 5 None apparent              Daylight                   Dry        Cloudy    463
    ## # … with abbreviated variable names ¹​`Surface Conditions`,
    ## #   ²​`Weather Conditions`

``` r
#Barplot of fatal crashes by light condition
crashes%>%
  filter(`Crash Severity` == "Fatal")%>%
  ggplot(aes(x = `Light Conditions`)) +geom_bar() + coord_flip()
```

![](README_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
#Fatal Crashes by Day
crashes%>%
  group_by(Month)%>%
  filter(`Crash Severity` == "Fatal")%>%
  ggplot(aes(x = Day, fill = `Crash Severity`)) +geom_bar() + facet_wrap(~Month) + coord_flip()
```

![](README_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
#All types of crashes by month
crashes%>%
  group_by(Month)%>%
  ggplot(aes(x = Day, fill = `Crash Severity`)) +geom_bar() + facet_wrap(~Month)
```

![](README_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->
