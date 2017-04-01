shinyUI(
  navbarPage("R regex",
             theme=shinythemes::shinytheme("cosmo"),
             tabPanel("Test Regex",
                      textInput("pattern",  label="Matching Pattern", value="t(es)(t)", 
                                placeholder="Enter regex to match"),
                      checkboxInput("escape_slashes_pattern",label = "Escape backslashes in Pattern", value = FALSE),
                      textAreaInput("test_str", label="Test String",  value="This is a test string for testing regex.", 
                                    placeholder="Enter string to match regex against"),
                      checkboxInput("escape_slashes_test_str",label = "Escape backslashes in Test String", value = FALSE),
                      radioButtons("environ", "Engine", choices=c("base","stringr")),
                      checkboxGroupInput("additional_params", "Additional Parameters",
                                         choices = c("Ignore Case"="ignore_case",
                                                     "Global"="global",
                                                     "Perl (only used when Engine is base)"="perl",
                                                     "Fixed (overrides Perl)"="fixed"),
                                         selected = c("ignore_case","global","perl")),
                      uiOutput("highlight_str"),
                      uiOutput("match_list_html")
                      ),#tabPanel
             tabPanel("Regex Cheatsheet",
                      HTML('<object width="1100" height="850" data="regex_cheatsheet.pdf"></object>')
                      )
             )#navbarpage  
)#shinyui
