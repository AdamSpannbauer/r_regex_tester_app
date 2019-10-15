#' @import shiny
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    navbarPage("R Regex Tester",
               theme=shinythemes::shinytheme("cosmo"),
               tabPanel("Home",
                        tags$head(tags$link(rel="shortcut icon", href="favicon.png")),
                        fluidRow(
                          column(width=12, align="left",
                                 sidebarLayout(
                                   sidebarPanel(style = "background-color: #ffffff;",
                                                HTML("<p style='text-align:left;'>
                                          <strong><font size='5'>Options</font></strong>
                                          <span style='float:right;'><img src='logo.png' width='50px'></span>
                                         </p>
                                         <hr>"),
                                                checkboxGroupInput("auto_escape_check_group", "Auto Escape Backslashes",
                                                                   choices = c("Pattern"="pattern",
                                                                               "Test String"="test_str")),
                                                checkboxGroupInput("additional_params", "Additional Parameters",
                                                                   choices = c("Ignore Case"="ignore_case",
                                                                               "Global"="global",
                                                                               "Perl"="perl",
                                                                               "Fixed (overrides Ignore Case & Perl)"="fixed"),
                                                                   selected = c("ignore_case","global","perl")),
                                                br(),
                                                fluidRow(
                                                  column(width=4, align="center",
                                                         HTML('<div style="float:center">
                                                  <a class="github-button" 
                                                    href="https://github.com/AdamSpannbauer/r_regex_tester_app/issues" 
                                                    data-icon="octicon-issue-opened" 
                                                    data-style="mega" 
                                                    data-count-api="/repos/AdamSpannbauer/r_regex_tester_app#open_issues_count" 
                                                    data-count-aria-label="# issues on GitHub" 
                                                    aria-label="Issue AdamSpannbauer/r_regex_tester_app on GitHub">
                                                    Issue</a>
                                                  <!-- Place this tag in your head or just before your close body tag. -->
                                                  <script async defer src="https://buttons.github.io/buttons.js"></script>
                                                  </div>')
                                                  ),
                                                  column(width=4, align="center",
                                                         HTML('<div style="float:center">
                                                  <a class="github-button" 
                                                    href="https://github.com/AdamSpannbauer/r_regex_tester_app" 
                                                    data-icon="octicon-star" 
                                                    data-style="mega" 
                                                    data-count-href="/AdamSpannbauer/r_regex_tester_app/stargazers" 
                                                    data-count-api="/repos/AdamSpannbauer/r_regex_tester_app#stargazers_count" 
                                                    data-count-aria-label="# stargazers on GitHub" 
                                                    aria-label="Star AdamSpannbauer/r_regex_tester_app on GitHub">
                                                    Star</a>
                                                  <!-- Place this tag in your head or just before your close body tag. -->
                                                  <script async defer src="https://buttons.github.io/buttons.js"></script>
                                                  </div>')
                                                  ),
                                                  column(width=4, align="center",
                                                         HTML("<div style='float:center'>
                                                  <a href='https://twitter.com/share' 
                                                   class='twitter-share-button' 
                                                   align='middle' 
                                                   data-url='https://spannbaueradam.shinyapps.io/r_regex_tester' 
                                                   data-text='Check out this shiny app for testing regex in an #rstats environment' 
                                                   data-size='large'>Tweet
                                                   </a>
                                                  <script>!function(d,s,id){
                                                   var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
                                                   if(!d.getElementById(id)){
                                                   js=d.createElement(s);
                                                   js.id=id;
                                                   js.src=p+'://platform.twitter.com/widgets.js';
                                                   fjs.parentNode.insertBefore(js,fjs);
                                                   }
                                                   }(document, 'script', 'twitter-wjs');
                                                   </script>
                                                  </div>")
                                                  )
                                                ),
                                                hr(),
                                                fluidRow(
                                                  column(width=12, align='center',
                                                         shiny::includeHTML(buy_me_stuff_button_html)
                                                  )
                                                )
                                   ),
                                   mainPanel(
                                     fluidRow(
                                       column(width=12, align="left",
                                              wellPanel(style = "background-color: #f2f2f2;",
                                                        HTML("<strong><font size='5'>Input</font></strong><hr>"),
                                                        textInput("pattern",  label="Matching Pattern", value="t(es)(t)", 
                                                                  placeholder="Enter regex to match", width="100%"),
                                                        textAreaInput("test_str", label="Test String",  value="This is a test string for testing regex.",
                                                                      placeholder="Enter string to match regex against",width="100%")
                                              ),
                                              bsCollapse(id = "collapseExample",
                                                         bsCollapsePanel(HTML("<strong><font size='5'>Reg-Explanation</font></strong>"), 
                                                                         HTML('explanation provided by <a href="http://rick.measham.id.au/paste/explain", target="_blank">rick.measham.id.au</a><hr>'),
                                                                         DT::dataTableOutput("explaination_dt"),
                                                                         style = "default")),
                                              wellPanel(style = "background-color: #f2f2f2;",
                                                        HTML("<strong><font size='5'>Results</font></strong><hr>"),
                                                        uiOutput("highlight_str"),
                                                        uiOutput("match_list_html")
                                              )
                                       )
                                     )
                                   )
                                 )
                          )
                        ),
                        br(),
                        br(),
                        br(),
                        hr(),
                        fluidRow(
                          column(width=12, align="center",
                                 HTML(paste0("<h4>When in Doubt</h4> ",
                                             "<img src='https://imgs.xkcd.com/comics/backslashes_2x.png' title='I searched my .bash_history for the line with the highest ratio of special characters to regular alphanumeric characters, and the winner was: cat out.txt | grep -o \"[[(].*[])][^)]]*$\" ... I have no memory of this and no idea what I was trying to do, but I sure hope it worked.'",
                                             "height='200' width='500'> ",
                                             "<h5>image source <a href='https://xkcd.com/1638/' target='_blank'>xkcd</a> </h5>"))
                          )
                        ),
                        icon = icon("home")),#tabPanel
               tabPanel("RStudio Regex Cheatsheet",
                        fluidRow(
                          column(width=12, align="center",
                                 HTML('<object width="1100" height="850" data="regex_cheatsheet.pdf"></object>')
                          )
                        )
               ),
               tabPanel(HTML("<code>?regex</code>"),
                        HTML(readLines("inst/app/www/regex_documentation.txt"))
               )
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'regexTestR')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
