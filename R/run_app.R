#' Launch the Victorian road crash dashboard
#'
#' @return No return value; called for its side effect of launching the app.
#' 
#' @examples
#' if (interactive()) run_app()
#' 
#' @export
run_app <- function() {
  app_dir <- system.file("app", package = "roadcrashVIC")
  shiny::runApp(app_dir)
}
