#scrape table of counties
url <- "https://secure.kentucky.gov/kyhs/hmdb/CountyMap.aspx"

#build table with separate href for each county
library(magrittr)
library(rvest)

df.00 <- read_html(x = url) %>% 
        html_nodes(c("table")) %>%
        html_table(header = T, 
                   trim = T, 
                   fill = T
                   )
df.01 <- data.frame(matrix(unlist(df.00), nrow = 120, byrow = F),
                 stringsAsFactors=FALSE)

#get hrefs
hrefs <- read_html(x = url) %>% 
        html_nodes(c("td a")) %>%
        html_attr("href")

hrefs <- paste0("https://secure.kentucky.gov/kyhs/hmdb/", hrefs)
df.01$hrefs <- hrefs

#name vars
colnames(df.01) <- c("county", 
                     "markers", 
                     "founding", 
                     "county_seat", 
                     "urls"
                     )

#scrape urls for marker
url <- df.01$urls[1:nrow(df.01)]
library(magrittr)
name <- sapply(url, function(x){
        read_html(x) %>% 
        html_nodes(c("font strong")) %>%
        html_text("")
}
)
county <-       sapply(url, function(x){
                        read_html(x) %>% 
                        html_nodes(c("strong+ a")) %>%
                        html_text("")
}
)

marker <- sapply(url, function(x){
                read_html(x) %>% 
                        html_nodes(c("#onecol")) %>%
                        html_text(trim = T)
        }
)

marker01 <- lapply(marker, function(x){
        stringr::str_extract_all(x, pattern = "\\(Marker Number\\:.*\\)")
}
)
marker02 <- unlist(marker01)
names(marker02) <- NULL

# location <- sapply(url[1:3], function(x){
#                 read_html(x) %>% 
#                 html_nodes(c("#onecol")) %>%
#                 html_text(trim = T)
# 
#         }
# )
# location1 <- lapply(location, function(x){
#         stringr::str_extract_all(location, pattern = "Location\\:.*")
# }
# )
# location1





df.02 <- data.frame(
        county = unlist(county),
        name = unlist(name),
        marker = marker02, stringsAsFactors = F
)
df.03 <- merge(df.02, df.01, stringsAsFactors = FALSE)
df.03$urls <- NULL
pattern <- "[0-9]{1,4}"
df.03$marker <- stringr::str_extract(df.03$marker, pattern = pattern)
df.03$state <- "KY"
df.03$update <- Sys.Date()
df.03$county_seat <- gsub("Mt\\.", "Mount", df.03$county_seat)
df.03$county_seat[grep("Madisonvillle", df.03$county_seat)] <-"Madisonville"


##scrape county table
file <- "./data_raw/2020-03-21_county_fips_lat_lon.csv"
df.04 <- read.csv(file = file, header = T, colClasses = "character")
df.04$lat <- as.numeric(gsub("\\+|\\p{So}", "", df.04$lat, perl = TRUE))
df.04$lon <- as.numeric(gsub(".{1}$|^.{1}", "", df.04$lon))
df.04$lon <- df.04$lon * -1
df.04$county_seat[grep("McCracken", df.04$county)] <- "Paducah"
df.04$county_seat[grep("Murray", df.04$county)] <- "Benton"
df.04$county_seat[grep("Madison", df.04$county)] <- "Richmond"
df.04$county_seat[grep("Magoffin", df.04$county)] <- "Salyersville"
df.04$county_seat[grep("Marion", df.04$county)] <- "Lebanon"
df.04$county_seat[grep("Martin", df.04$county)] <- "Inez"
df.04$county_seat[grep("Mason", df.04$county)] <- "Maysville"
df.04$county_seat[grep("McCreary", df.04$county)] <- "Whitley City"
df.04$county_seat[grep("McLean", df.04$county)] <- "Calhoun"
df.04$county_seat[grep("Marshall", df.04$county)] <- "Benton"
#merge".{1}$"
df.05 <- merge(df.03, df.04)

file <- paste0("./data_tidy/",
               Sys.Date(),
              "_",
              "ky_historic_markers.csv"
              )
write.csv(df.05, file = file, row.names = F)
