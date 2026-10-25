#' Summarise crashes and casualties by one or more variables
#'
#' Counts crashes and adds up people killed and injured for each group, and works out how deadly the crashes in each group were.
#'
#' The `fatalities_per_1000_crashes` column is a *severity* measure: out of every 1,000 casualty crashes in the group,
#' how many people died. It is different from a count of deaths, because a group with many crashes (such as
#' the afternoon peak) can have a low rate. It is based on crashes, not on
#' traffic volume, so it does not measure risk per kilometre driven.
#'
#' @param data A data frame of crashes, such as [vic_crashes], optionally already filtered with [filter_crashes()].
#' @param by Character vector of column names to group by, for example `"hour"`, `"year"` or `c("day_of_week", "hour")`.
#'
#' @return A tibble with one row per group (only groups that occur in `data`), sorted by the grouping columns, with columns:
#'   \describe{
#'     \item{`crashes`}{Number of crashes.}
#'     \item{`fatalities`}{People killed.}
#'     \item{`serious_injuries`}{People seriously injured.}
#'     \item{`other_injuries`}{People with other injuries.}
#'     \item{`fatalities_per_1000_crashes`}{People killed per 1,000 crashes.}
#'   }
#' @examples
#' summarise_crashes(vic_crashes, by = "hour")
#'
#' vic_crashes |>
#'   filter_crashes(years = 2022:2024) |>
#'   summarise_crashes(by = c("day_of_week", "hour"))
#' @export

summarise_crashes <- function(data, by){
  if (!is.character(by) || length(by)<1){
    stop("`by` must be a character vector with at least one column name.")
  }
  missing_cols <- setdiff(by, names(data))
  if (length(missing_cols) > 0) {
    stop("Column(s) specified in `by` are not present in `data`")
  } 
  data |> 
    dplyr::summarise(
      total_crashes = dplyr::n(),
      fatalities = sum(.data$fatality),
      serious_injuries = sum(.data$seriousinjury),
      other_injuries = sum(.data$otherinjury),
      fatalities_per_1000 = 1000*.data$fatalities/.data$total_crashes,
      serious_injuries_per_1000 = 1000*.data$serious_injuries/.data$total_crashes,
      other_injuries_per_1000 = 1000*.data$other_injuries/.data$total_crashes,
      .by = dplyr::all_of(by)
    ) |>
    dplyr::arrange(dplyr::across(dplyr::all_of(by)))
}