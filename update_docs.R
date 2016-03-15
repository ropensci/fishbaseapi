library(readxl)
library(dplyr)
file <- "~/Downloads/FishBase_DataDictionary.xls"
topath <- "~/github/ropensci/fishbaseapi/docs/docs-sources/new"
sheets <- tolower(readxl::excel_sheets(file))
#i <- 1

for (i in seq_along(sheets)) {
  x <- readxl::read_excel(file, sheet = i)
  df <- x %>% 
    rename(column_name = Name) %>% 
    mutate(table_name = sheets[i]) %>% 
    select(table_name, everything()) %>% 
    setNames(tolower(names(.))) %>% 
    filter(!is.na(column_name)) %>% 
    mutate(description = gsub("\"", "", description)) %>% 
    mutate(description = gsub(",|:|\\=", "; ", description)) %>% 
    data.frame
  write.csv(df, 
            file = file.path(topath, paste0(sheets[i], ".csv")), 
            row.names = FALSE)
}


