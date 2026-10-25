#' Filter crashes by year and month
#'
#' Filter the dataset to keep only the crashes that happened in the chosen years and months.
#' Leave an argument as `NULL` to keep everything for that dimension.
#'
#' @param data A data frame of crashes with `year` and `month` columns, such as [vic_crashes].
#' @param years Numeric vector of years to keep, for example `2019:2023`. Years that are not in
#'   the data are ignored (the data covers 2012 to February 2026).
#' @param months Character vector of month abbreviations to keep, using the values of [month.abb]:
#'   `"Jan"`, `"Feb"`, `"Mar"`, `"Apr"`, `"May"`, `"Jun"`, `"Jul"`, `"Aug"`, `"Sep"`, `"Oct"`, `"Nov"`, `"Dec"`.
#'   Any other value is an error that lists the valid choices.
#'
#' @return The rows of `data` that match, with the same columns. This can be a data frame with zero rows
#'   if nothing matches, for example March 2026, because the data stops at the end of February 2026.
#'
#' @examples
#' # Summer crashes between 2019 and 2023
#' summer <- filter_crashes(vic_crashes, years = 2019:2023, months=c("Dec", "Jan", "Feb"))
#' nrow(summer)
#'
#' # Years only: all months are kept
#' nrow(filter_crashes(vic_crashes, years = 2024))
#'
#' # Nothing matches, so zero rows come back (not an error)
#' nrow(filter_crashes(vic_crashes, years = 2026, months = "Mar"))
#' 
#' @export

filter_crashes <- function(data, years = NULL, months = NULL) {
  if (!is.null(years)) {
    if (!is.numeric(years)) {
      stop("`years` must be a numeric vector, e.g. 2019:2023.", call. = FALSE)
    }
    data <- dplyr::filter(data, .data$year %in% years)
  }
  if (!is.null(months)) {
    bad <- setdiff(months, month.abb)
    if (length(bad) > 0) {
      stop(
        "Unrecognised month(s): ", paste(bad, collapse = ", "), ".\n",
        "Use any of: ", paste(month.abb, collapse = ", "), ".",
        call. = FALSE
      )
    }
    data <- dplyr::filter(data, .data$month %in% months)
  }
  data
}