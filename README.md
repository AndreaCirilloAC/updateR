
updateR : update your R version in a breeze (on a Mac)
======================================================

### Installation

**updateR** is not currently on CRAN. To install it, you can use the devtools package:

``` r
install.packages("devtools")

devtools::install_github("yaccos/updateR")
```

### Usage

To update R, run `updateR()` with your system password. The function will display the version that R has been updated to when it finishes. **previously installed packages will be installed back from CRAN and Bioconductor, ( this may require time)**

### More information

To find out more on updateR, see the dedicated blog post: <https://andreacirilloblog.wordpress.com/2015/10/22/updater-package-update-r-version-with-a-function-on-mac-osx/>
