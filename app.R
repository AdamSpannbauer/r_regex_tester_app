# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

# Deploy to r_regex_tester_app for testing
# Deploy to r_regex_tester for prod

library(shinyBS)

pkgload::load_all(
  export_all = FALSE,
  helpers = FALSE,
  attach_testthat = FALSE
)

options("golem.app.prod" = TRUE)

regexTestR::run_app() # add parameters here (if any)
