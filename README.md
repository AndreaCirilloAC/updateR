
updateR : update your R version in a breeze (on a Mac)
======================================================
### NEWS: 
**previously installed package retrieval feautre is currently available only if launching udpater from base R rather than IDE like Rstudio.**
**previously installed package retrieval feature is in beta mode and you may need to manually install back your packages after upgrading R version.**
Thanks God they are free :)

### Installation

**updateR** is not currently on CRAN. To install it, you can use the devtools package:

``` r
install.packages("devtools")

devtools::install_github("AndreaCirilloAC/updateR")
```

### Usage

To update R, simply run `updateR()`, ~~where "PASSWORD" stands for your system password~~ You will be asked to enter the admin password in the process. The function will display the version that R has been updated to when it finishes.

### Password

If the first character of your admin password is `\`, make sure enter an extra `\` before passing your admin password to `updateR()` to escape UNICODE characters coding, such as `"\123"`becomes `"S"` so you need to key in `"\\123"` for the actual `"\123"`.

### Compatibility

~~No compatibility check is currently performed between your OS and the installed version of R.~~
`{updateR}` only checks compactibility for the **latest update** available on CRAN. Some of the patch/minor releases will be skipped, depending on the update of the website. For those who runs a macOS lower than 10.13, an compactability error will be returned if run `updateR()`:
```
Error: Latest R Version 4.0.2 requires macOS at least 10.13 or higher,
        but 10.12 is running. Consider upgrading macOS or install legacy R binaries from
        http://cran.rstudio.com/bin/macosx/
```

### Restoring packages

`{updateR}` restores old libraries from previous version with the following actions, depending the type of releases: 
1. For major releases (R 3.x -> R 4.x), **reinstall** all the packages;
2. For minor releases (R 3.5.x -> R 3.6.x), users may choose between reinstall or **copy and paste** all the file folders under /Library/Frameworks/R.framework/Versions/[old_version]/library to /Library/Frameworks/R.framework/Versions/[new_version]/library;
3. For patch releases (R 4.0.1 -> R 4.0.2), no actions will be taken.

### More information

To find out more on updateR, see the dedicated blog post: http://www.andreacirillo.com/2018/03/10/updater-package-update-r-version-with-a-function-on-mac-osx/
