buy_me_stuff_btn = function() {
  #' Randomly select if donate button will be alcoholic
  #'
  #' @return name of HTML file to use for button
  #' @keywords internal

  options = c("buy_me_coffee_button.html",
              "buy_me_beer_button.html")
  sample(options, size = 1)
}
