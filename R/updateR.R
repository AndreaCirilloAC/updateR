library(rvest)
library(dplyr)
## scratch

#we scrape CRAN page to retrieve the last R version and compose dowloading URL
page_source       <- read_html("https://cran.rstudio.com/bin/macosx/")
version_block     <- html_nodes(page_source,"table:nth-child(7) tr:nth-child(1) td:nth-child(1)")
version           <-html_text(version_block) %>% strsplit("/")



# ADESSO RIMUOVI LA PARTE NON NECESSARIA ED HAI ESTRATTO IL LINK

#download package, set folder for download
system("curl -o 'R-3.2.2.pkg' 'https://cran.rstudio.com/bin/macosx/R-3.2.2.pkg'")
#install .pkg file
system("installer -pkg 'R-3.2.2.pkg' -target / -verbose")
