#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui = function(request) {
  shiny::tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here
    shiny::navbarPage(title = "R Regex Tester",
                      theme = shinythemes::shinytheme("cosmo"),
                      shiny::tabPanel("Home",
                                      shiny::fluidRow(
                                        col_12(align = "left",
                                               shiny::sidebarLayout(
                                                 shiny::sidebarPanel(style = "background-color: #ffffff;",
                                                 shiny::HTML("<p style='text-align:left;'>
                                                                <strong><font size='5'>Options</font></strong>
                                                                <span style='float:right;'><img src='www/logo.png' width='50px'></span>
                                                              </p>
                                                              <hr>"),
                                                 shiny::checkboxGroupInput(
                                                   "auto_escape_check_group",
                                                   label = shiny::HTML(
                                                     "<label>Auto Escape Backslashes (<span id='auto_escape_doc_popover'><u><code>?</code></u></span>)</label>"
                                                     ),
                                                   choices = c("Pattern" = "pattern",
                                                               "Test String" = "test_str"),
                                                   selected = "test_str"
                                                   ),  # shiny::checkboxGroupInput
                                                 shinyBS::bsPopover(
                                                   id = "auto_escape_doc_popover",
                                                   title = "Bring your own escapes?",
                                                   content = paste0("When working with regex in R, you often need more ",
                                                                    shiny::code("\\\\"), " than you think.  For example, in Rs regex ",
                                                                    shiny::code("\\\\\\\\n"), " is a new line and ", shiny::code("\\\\n"),
                                                                    " is an ", shiny::code("n"), ". ", shiny::br(), shiny::br(),
                                                                    "When selected, this feature will force you to write regex with the number of ",
                                                                    "backslashes that R is looking for.  This can lead to some unexpected behavior; ",
                                                                    "for example, a new line in the test string will be converted to the letter ",
                                                                    shiny::code("n"), " (because ", shiny::code("\\\\n"), " -> ", shiny::code("n"), ")."
                                                   ),
                                                   placement = "right",
                                                   trigger = "hover",
                                                   options = list(container = "body")
                                                 ),  # shinyBS::bsPopover
                                                 shiny::checkboxGroupInput(
                                                   "additional_params",
                                                   label = shiny::tags$label("Additional Parameters"),
                                                   choices = c("Ignore Case" = "ignore_case",
                                                               "Global" = "global",
                                                               "Perl" = "perl",
                                                               "Fixed (overrides Ignore Case & Perl)" = "fixed"),
                                                   selected = c("ignore_case", "global", "perl")
                                                   ),  # shiny::checkboxGroupInput
                                                 shiny::br(),
                                                 shiny::fluidRow(
                                                   col_4(align = "center",
                                                   shiny::HTML('<div style="float:center">
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
                                                   ),  # col_4
                                                   col_4(align = "center",
                                                   shiny::HTML('<div style="float:center">
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
                                                   ),  # col_4
                                                   col_4(align = "center",
                                                   shiny::HTML("<div style='float:center'>
                                                                  <a href='https://twitter.com/share'
                                                                   class='twitter-share-button'
                                                                   align='middle'
                                                                   data-url='https://spannbaueradam.shinyapps.io/r_regex_tester'
                                                                   data-text='Check out this shiny app for testing regex in an #rstats environment'
                                                                   data-size='large'>Tweet
                                                                   </a>
                                                                  <script>!function(d,s,id) {
                                                                   var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
                                                                   if(!d.getElementById(id)) {
                                                                   js=d.createElement(s);
                                                                   js.id=id;
                                                                   js.src=p+'://platform.twitter.com/widgets.js';
                                                                   fjs.parentNode.insertBefore(js,fjs);
                                                                   }
                                                                   }(document, 'script', 'twitter-wjs');
                                                                   </script>
                                                                </div>")
                                                   )  # col_4
                                                   ),  # fluidRow
                                                 shiny::hr(),
                                                 shiny::fluidRow(
                                                   col_5(align = "center",
                                                         offset = 1,
                                                         shiny::actionButton(
                                                           inputId = "about_app",
                                                           "About",
                                                           icon = shiny::icon("file-alt"),
                                                           onclick = "window.open('https://adamspannbauer.github.io/2018/01/16/r-regex-tester-shiny-app/', '_blank')"
                                                           )
                                                         ),  # col
                                                   col_5(align = "center",
                                                         shiny::actionButton(
                                                           inputId = "buy_me_stuff",
                                                           "Buy me a coffee",
                                                           icon = shiny::icon("coffee"),
                                                           onclick = "window.open('https://www.buymeacoffee.com/qp7GmCrco', '_blank')"
                                                           )
                                                         )  # col
                                                   )  # fluidRow
                                                 ),  # sidebarPanel
                                                 shiny::mainPanel(
                                                   shiny::fluidRow(
                                                     col_12(align = "left",
                                                            shiny::wellPanel(style = "background-color: #f2f2f2;",
                                                                             shiny::HTML("<strong><font size='5'>Input</font></strong><hr>"),
                                                                             shiny::textInput("pattern",
                                                                                              label = "Matching Pattern",
                                                                                              value = "t(es)(t)",
                                                                                              placeholder = "Enter regex to match",
                                                                                              width = "100%"),
                                                                             shiny::textAreaInput("test_str",
                                                                                                  label = HTML("Test String (<a href='https://stackoverflow.com/a/1732454/5731525' target='_blank'>HTML tags are not supported</a>)"),
                                                                                                  value = "This is a test string for testing regex.",
                                                                                                  placeholder = "Enter string to match regex against",
                                                                                                  width = "100%")
                                                                             ),  # wellPanel
                                                            shinyBS::bsCollapse(
                                                              id = "collapseExample",
                                                              shinyBS::bsCollapsePanel(
                                                                shiny::HTML("<strong><font size='5'>Reg-Explanation</font></strong>"),
                                                                shiny::HTML('explanation provided by <a href="http://rick.measham.id.au/paste/explain", target="_blank">rick.measham.id.au</a><hr>'),
                                                                DT::dataTableOutput("explaination_dt"),
                                                                style = "default"
                                                                )  # bsCollapsePanel
                                                              ),  # bsCollapse
                                                            shiny::wellPanel(style = "background-color: #f2f2f2;",
                                                                             shiny::HTML("<strong><font size='5'>Results</font></strong><hr>"),
                                                                             shiny::uiOutput("highlight_str"),
                                                                             shiny::uiOutput("match_list_html")
                                                                             )  # wellPanel
                                                            )  # col_12
                                                     )  # fluidRow
                                                   )  # mainPanel
                                                 )  # sidebarLayout
                                               )  # col_12
                                        ),  # fluidRow
                                      rep_br(3),
                                      shiny::hr(),
                                      shiny::fluidRow(
                                        col_12(align = "center",
                                               shiny::HTML(
                                                 paste0("<h4>When in Doubt</h4> ",
                                                        "<img src='https://imgs.xkcd.com/comics/backslashes_2x.png' title='I searched my .bash_history for the line with the highest ratio of special characters to regular alphanumeric characters, and the winner was: cat out.txt | grep -o \"[[(].*[])][^)]]*$\" ... I have no memory of this and no idea what I was trying to do, but I sure hope it worked.'",
                                                        "height='200' width='500'> ",
                                                        "<h5>image source <a href='https://xkcd.com/1638/' target='_blank'>xkcd</a> </h5>"
                                                        )
                                                 )  # HTML
                                               )  # col_12
                                        ),  # fluidRow
                                      icon = shiny::icon("home")
                                      ), # tabPanel
                      shiny::tabPanel("RStudio Regex Cheatsheet",
                                      shiny::fluidRow(
                                        col_12(align = "center",
                                               shiny::HTML('<object width="1100" height="850" data="www/regex_cheatsheet.pdf"></object>')
                                               )  # col_12
                                        )  # fluidRow
                                      ),  # tabPanel
                      shiny::tabPanel(HTML("<code>?regex</code>"),
                                      shiny::includeHTML(
                                        app_sys("app/www/regex_documentation.html")
                                        )
                                      )  # tabPanel
                      )  # navbarPage
    )  # tagList
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www", app_sys("app/www")
  )

  shiny::tags$head(
    golem::favicon(ext = "png"),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "R Regex Tester"
    )
  )
}
