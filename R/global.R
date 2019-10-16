#' Button to get people to buy Author something
#' 
#' @export
buy_me_stuff_button_html <- function() {
  sample(c('inst/app/www/buy_me_coffee_button.html',
           'inst/app/www/buy_me_beer_button.html'),
         size = 1
  )
}
NULL
