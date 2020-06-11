# R Regex Tester Shiny App <img src='inst/app/www/logo.png' width='75px' align='right'>

[![Build Status](https://travis-ci.org/AdamSpannbauer/r_regex_tester_app.svg?branch=master)](https://travis-ci.org/AdamSpannbauer/r_regex_tester_app) 
[![Codecov test coverage](https://codecov.io/gh/AdamSpannbauer/r_regex_tester_app/branch/master/graph/badge.svg)](https://codecov.io/gh/AdamSpannbauer/r_regex_tester_app?branch=master)

<p align="center">
   <img src="https://adamspannbauer.github.io/assets/2018/01/regex_full_screenshot.png", width="80%">
</p>


## Usage

### Online

* Visit the application live on [shinyapps.io](https://spannbaueradam.shinyapps.io/r_regex_tester/).

### Local
 
* Install from GitHub with devtools

```r
devtools::install_github("AdamSpannbauer/r_regex_tester_app")
```
  
* Run app
  
```r
regexTestR::run_app()
```

## Features

### Options

* Use the common options used across the R [Pattern Matching and Replacement](https://stat.ethz.ch/R-manual/R-devel/library/base/html/grep.html) family of functions.

<p align="center">
  <kbd>
   <img src="https://adamspannbauer.github.io/assets/2018/01/regex_app_options.png", width="50%">
  </kbd>
</p>


* The other 2 options concerning backslashes allow you to write an R flavored regex.  
    * For example, if you want to match a literal period with a regex you'll type "\\\\." (as if you were writing the regex in R).  
    * If you don't like this behavior, and you'd rather type half of the slashes needed to make the regex functional in R, you can select the "Auto Escape Backslashes" option for "Pattern" and then use "\\." to match literal periods in the app.

### Input

* There are 2 text inputs:
    1. __Matching Pattern__: type the regular expression or fixed pattern here that you want to use to match against your text.
    2. __Test String__: type the text that you want your Matching Pattern to search through

<p align="center">
  <kbd>
   <img src="https://adamspannbauer.github.io/assets/2018/01/regex_app_input.png", width="50%">
  </kbd>
</p>

### Results

* After the pattern and test string are entered we see 2 different versions of the resulting pattern matching:
    1. The test string is shown with the matches/capture groups highlighted where they appear in the text
        * As noted in the UI, currently nested capture group highlighting isn't supported.  If our matching pattern was "t(e(s))(t)" the highlighting wouldn't display correctly.
    2. The second output is a bulleted list of the matches and capture groups found in our test string.  In the screen shot below we see we matched 2 instances of "test", and each of these matches display below them the contents of the 2 capture groups we included in our regex pattern.

<p align="center">
  <kbd>
   <img src="https://adamspannbauer.github.io/assets/2018/01/regex_app_results.png", width="50%">
  </kbd>
</p>

### Regex Explanation

* There's additionally a collapsable panel that will do it's best to break down your regex and explain the components.  As noted in the UI these explanations are provided by [rick.measham.id.au](http://rick.measham.id.au/paste/explain)
* The screen shot below shows the explanation for our regex: "t(es)(t)"

<p align="center">
  <kbd>
   <img src="https://adamspannbauer.github.io/assets/2018/01/regex_app_explain.png", width="50%">
  </kbd>
</p>

### Helping Documentation

<p align="center">
  <img src="https://adamspannbauer.github.io/assets/2018/01/regex_app_navbar.png", width="70%">
</p>


* The app includes some documentation for using regular expressions in R.  The two including pieces of helping documentaion are:
    1. The [RStudio](https://www.rstudio.com/) Regex Cheatsheet
    2. The base R documentation on regex (this is what would appear if you ran the command `?regex`)

### Extra

Shiny's bootstrap roots allow apps to transition between desktop and mobile pretty seamlessly.  The app's mobile experience isn't terrible, so you can use it for all your regex-ing fun on the go! (I won't ask why) 

<p align="center">
  <kbd>
   <img src="https://adamspannbauer.github.io/assets/2018/01/regex_app_mobile.jpg", width="30%">
  </kbd>
</p>
