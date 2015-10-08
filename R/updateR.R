

## scratch

#compose url ( get last version using a bit of web scraping)
#download package, set folder for download
system("curl -o 'R-3.2.2.pkg' 'https://cran.rstudio.com/bin/macosx/R-3.2.2.pkg'")
#install .pkg file
system("installer -pkg 'R-3.2.2.pkg' -target / -verbose")

