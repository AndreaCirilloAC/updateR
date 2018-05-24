
updateR : update your R version in a breeze (on a Mac)
======================================================
### NEWS: 
**previously installed package retrieval feature is in beta mode and you may need to manually install back your packages after upgrading R version.**
Thanks God they are free :)

### Installation

**updateR** is not currently on CRAN. To install it, you can use the devtools package:

``` r
install.packages("devtools")

devtools::install_github("AndreaCirilloAC/updateR")
```

### Usage

To update R, run `updateR(admin_password = "PASSWORD")`, where "PASSWORD" stands for your system password. The function will display the version that R has been updated to when it finishes.

### Compatibility

No compatibility check is currently performed between your OS and the installed version of R.

### More information

To find out more on updateR, see the dedicated blog post: http://www.andreacirillo.com/2018/02/10/updater-package-update-r-version-with-a-function-on-mac-osx/
