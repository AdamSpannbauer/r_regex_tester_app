# Source: https://github.com/statistikat/codeModules/blob/master/R/renderCode.R

rCodeContainer <- function(...) {
  code <- shiny::HTML(
    as.character(shiny::tags$code(class = "language-r", ...))
  )
  shiny::div(shiny::pre(code))
}

injectHighlightHandler <- function() {
  code <- "
    Shiny.addCustomMessageHandler(
      'highlight-code',
      function(message) {
        var id = message['id'];
        var delay = message['delay'];
        setTimeout(
          function() {
            var el = document.getElementById(id);
            hljs.highlightBlock(el);
          },
          delay
        );
      }
    );"
  tags$script(code)
}

includeHighlightJs <- function() {
  resources <- system.file("www/shared/highlight", package = "shiny")
  shiny::singleton(list(
    shiny::includeScript(file.path(resources, "highlight.pack.js")),
    shiny::includeCSS(file.path(resources, "rstudio.css")),
    injectHighlightHandler()
  ))
}

#' Render code with syntax highlighting
#'
#' shinyApp(
#'   fluidPage(
#'     textAreaInput("code_in", NULL,
#'       width = "1000px", height = "200px",
#'       paste("f <- function(x) {2*x + 3}", "f(1)", "#> 5", sep = "\n")
#'     ),
#'     codeOutput("code_out")
#'   ),
#'   function(input, output, session) {
#'     output$code_out <- renderCode({
#'       paste(input$code_in)
#'     })
#'   }
#' )
#' }
renderCode <- function(expr, env = parent.frame(), quoted = FALSE,
                       outputArgs = list(), delay = 100) {
  func <- shiny::exprToFunction(expr, env, quoted)
  renderFunc <- function(shinysession, name, ...) {
    value <- func()
    for (d in delay) {
      shinysession$sendCustomMessage(
        "highlight-code",
        list(id = name, delay = d)
      )
    }
    return(paste(utils::capture.output(cat(value)), collapse = "\n"))
  }
  shiny::markRenderFunction(codeOutput, renderFunc, outputArgs = outputArgs)
}

codeOutput <- function(outputId) {
  shiny::tagList(
    includeHighlightJs(),
    shiny::uiOutput(outputId, container = rCodeContainer)
  )
}
