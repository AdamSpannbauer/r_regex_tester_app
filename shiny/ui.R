shinyUI(
  fluidPage(
    textInput("pattern",  label="Matching Pattern", value="t(es)(t)", 
              placeholder="Enter regex to match"),
    textAreaInput("test_str", label="Test String",  value="This is a test string for testing regex.", 
                  placeholder="Enter string to match regex against"),
    radioButtons("environ", "Engine", choices=c("base","stringr")),
    checkboxGroupInput("additional_params", "Additional Parameters",
                       choices = c("Ignore Case"="ignore_case",
                                   "Global"="global",
                                   "Perl*"="perl"),
                       selected = c("ignore_case","global","perl")),
    wellPanel(uiOutput("match_list_html"))
  )#fluidPage
)#shinyui
