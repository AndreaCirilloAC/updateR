library(rvest)
library(dplyr)
## scratch

#compose url ( get last version using a bit of web scraping)
page_source <- read_html("https://cran.rstudio.com/bin/macosx/")
html_nodes(page_source,"table:nth-child(7) tr:nth-child(1) td:nth-child(1)")

#download package, set folder for download
system("curl -o 'R-3.2.2.pkg' 'https://cran.rstudio.com/bin/macosx/R-3.2.2.pkg'")
#install .pkg file
system("installer -pkg 'R-3.2.2.pkg' -target / -verbose")

