#' Filter crashes to a date range
#'
#' Keep only the crashes that happened between two dates (both included).
#'
#' @param data A data frame of crashes with an `accident_date` column, such as [vic_crashes].
#' @param start_date,end_date First and last day to keep, as dates or `"YYYY-MM-DD"` strings.
#'   Default to the first and last date in `data`.
#'
#' @return The rows of `data` between `start_date` and `end_date`, with the same columns.
#'
#' @examples
#' # Crashes in the 2024-25 financial year
#' fy <- filter_crashes(vic_crashes, start_date = "2024-07-01", end_date = "2025-06-30")
#' nrow(fy)
#'
#' # Only a start date: everything from 2020 onwards
#' nrow(filter_crashes(vic_crashes, start_date = "2020-01-01"))
#'
#' @export
filter_crashes <- function(data, start_date = min(data$accident_date), end_date = max(data$accident_date)){
  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)
  first <- min(data$accident_date)
  last <- max(data$accident_date)

  if (start_date > end_date) {
    stop("`start_date` must be on or before `end_date`.", call. = FALSE)
  }
  if (start_date < first || end_date > last) {
    stop("Dates must be between ", first, " and ", last, ".", call. = FALSE)
  }

  dplyr::filter(data, accident_date >= start_date, accident_date <= end_date)
}
