# Source: https://github.com/statistikat/codeModules/blob/master/R/renderCode.R

r_code_container <- function(...) {
  code <- shiny::HTML(
    as.character(shiny::tags$code(class = "language-r", ...))
  )
  shiny::div(shiny::pre(code))
}

inject_highlight_handler <- function() {
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

include_highlight_js <- function() {
  resources <- system.file("www/shared/highlight", package = "shiny")
  shiny::singleton(list(
    shiny::includeScript(file.path(resources, "highlight.pack.js")),
    shiny::includeCSS(file.path(resources, "rstudio.css")),
    inject_highlight_handler()
  ))
}

render_code <- function(expr, env = parent.frame(), quoted = FALSE,
                        output_args = list(), delay = 100) {
  func <- shiny::exprToFunction(expr, env, quoted)
  render_func <- function(shinysession, name, ...) {
    value <- func()
    for (d in delay) {
      shinysession$sendCustomMessage(
        "highlight-code",
        list(id = name, delay = d)
      )
    }
    return(paste(utils::capture.output(cat(value)), collapse = "\n"))
  }
  shiny::markRenderFunction(code_output, render_func, outputArgs = output_args)
}

code_output <- function(output_id) {
  shiny::tagList(
    include_highlight_js(),
    shiny::uiOutput(output_id, container = r_code_container)
  )
}
