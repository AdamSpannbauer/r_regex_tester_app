shinyUI(
  navbarPage("R Regex Tester",
             theme=shinythemes::shinytheme("cosmo"),
             tabPanel("Home",
                      fluidRow(
                        column(width=12, align="left",
                               sidebarLayout(
                                 sidebarPanel(style = "background-color: #ffffff;",
                                   HTML("<strong><font size='5'>Options</font></strong><hr>"),
                                   checkboxGroupInput("auto_escape_check_group", "Auto Escape Backslashes",
                                                      choices = c("Pattern"="pattern",
                                                                  "Test String"="test_str")),
                                   # checkboxInput("escape_slashes_pattern",label = "Escape backslashes in Pattern", value = FALSE),
                                   # checkboxInput("escape_slashes_test_str",label = "Escape backslashes in Test String", value = FALSE),
                                   # radioButtons("environ", "Engine", choices=c("base","stringr")),
                                   checkboxGroupInput("additional_params", "Additional Parameters",
                                                      choices = c("Ignore Case"="ignore_case",
                                                                  "Global"="global",
                                                                  "Perl"="perl",
                                                                  "Fixed (overrides Ignore Case & Perl)"="fixed"),
                                                      selected = c("ignore_case","global","perl")),
                                   br(),
                                   hr(),
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
                                                   data-url='www.mywebsite.com' 
                                                   data-text='Regex Tester for R www.mywebsite.com' 
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
                                            # actionButton("tweet_share", "Tweet", icon("twitter"), 
                                            #              style="color: #ffffff; background-color: #00aced;",
                                            #              href ="https://twitter.com/intent/tweet?text=test&url=https://www.google.com)")
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
                                               "<img src='https://imgs.xkcd.com/comics/backslashes_2x.png' ",
                                               "height='200' width='500'> ",
                                               "<h5>image source <a href='https://xkcd.com/1638/' target='_blank'>xkcd</a> </h5>"))
                                   )
                          ),
                      icon = icon("home")),#tabPanel
             tabPanel("Regex Cheatsheet",
                      fluidRow(
                        column(width=12, align="center",
                               HTML('<object width="1100" height="850" data="regex_cheatsheet.pdf"></object>')
                               )
                      )
                      ),
             tabPanel("Regular Expressions as used in R",
                      readr::read_lines("www/regex_documentation.txt") %>% 
                        HTML()
                      )
             )#navbarpage  
)#shinyui
