#Run scripts
x <- c("./R/010_scrape_historical_society_website.R",
       "./R/020_convert_table_to_json.R"
)
         
)
#function to run scripts and clear env
run_scripts <- function(x){
      source(x,
             echo = FALSE,
             verbose = FALSE
      )
      rm(list = ls())
}
sapply(x, run_scripts)
