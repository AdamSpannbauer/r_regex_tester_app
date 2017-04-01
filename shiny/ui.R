shinyUI(
  navbarPage("R regex",
             theme=shinythemes::shinytheme("cosmo"),
             tabPanel("Test Regex",
                      fluidRow(
                        column(width=12, align="left",
                               sidebarLayout(
                                 sidebarPanel(
                                   checkboxInput("escape_slashes_pattern",label = "Escape backslashes in Pattern", value = FALSE),
                                   checkboxInput("escape_slashes_test_str",label = "Escape backslashes in Test String", value = FALSE),
                                   # radioButtons("environ", "Engine", choices=c("base","stringr")),
                                   checkboxGroupInput("additional_params", "Additional Parameters",
                                                      choices = c("Ignore Case"="ignore_case",
                                                                  "Global"="global",
                                                                  "Perl"="perl",
                                                                  "Fixed (overrides Perl)"="fixed"),
                                                      selected = c("ignore_case","global","perl"))
                                 ),
                                 mainPanel(
                                   fluidRow(
                                     column(width=12, align="left",
                                            textInput("pattern",  label="Matching Pattern", value="t(es)(t)", 
                                                      placeholder="Enter regex to match"),
                                            textAreaInput("test_str", label="Test String",  value="This is a test string for testing regex.", 
                                                          placeholder="Enter string to match regex against"),
                                            uiOutput("highlight_str"),
                                            uiOutput("match_list_html"))
                                     )
                                   )
                                 )
                               )
                        ),
                      hr(),
                      br(),
                          fluidRow(
                            column(width=12, align="center",
                                   HTML(paste0("<h4>When in Doubt</h4> ",
                                               "<img src='https://imgs.xkcd.com/comics/backslashes_2x.png' ",
                                               "height='200' width='500'> ",
                                               "<h5>image source <a href='https://xkcd.com/1638/' target='_blank'>xkcd</a> </h5>"))
                                   )
                          )
                      ),#tabPanel
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
