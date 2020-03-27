#inport csv table as character
file <- c("./data_tidy/2020-03-22_ky_historic_markers.csv")
df.00 <- read.csv(file = file, 
                  header = T, 
                  colClasses = "character"
                  )
#format variables
my_gps <-grep("^lat|^lon", colnames(df.00))
df.00[, my_gps] <- sapply(df.00[, my_gps], as.numeric)

#add jitter to the lat and the lon
library(dplyr)
library(magrittr)
df.01 <-
        df.00 %>%
        group_by(county) %>%
        mutate(lat1 = lat + runif(n(), min = -0.015, max = 0.0015) * (n() > 1)
        ) %>%
        mutate(lon1 = lon + runif(n(), min = -0.015, max = 0.0015) * (n() > 1)
        ) %>%
        select(-lat, -lon)

colnames(df.01)[grep("lat1|lon1", colnames(df.01))] <- c("lat", "lon")

#convert it to geojson
library(geojson)
dest <- "./data_tidy/"
name <- paste0(Sys.Date(),
               "_",
               "ky_hist_markers")
# toGeoJSON(data = df.01,
#           name = name, 
#           dest = dest,
#           lat.lon = my_gps
#           )
#convert it to json
df.JSON <- jsonlite::toJSON(df.01,
                      digits = 5,
                      pretty = T)
file <- paste0("./data_tidy/",
              Sys.Date(),
              "_",
              "ky_hist_markers.json"
)
write(df.JSON, file = file)
#save as "final" csv file
file.csv <- paste0("./data_tidy/",
              Sys.Date(),
              "_",
              "final_ky_hist_markers.csv"
)
file.csv
write.csv(df.01, file = file.csv, row.names = F)
