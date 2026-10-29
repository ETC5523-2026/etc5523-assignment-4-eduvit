#' Summarise crashes and casualties by one or more variables
#'
#' Counts crashes and people killed and injured in each group, and the number of casualties per 1,000 crashes.
#' KSI is people killed or seriously injured.
#'
#' @param data A data frame of crashes, such as [vic_crashes], optionally filtered with [filter_crashes()].
#' @param by Character vector of columns to group by, for example `"hour"` or `c("day_of_week", "hour")`.
#'
#' @return A tibble with one row per group, sorted by the grouping columns, with columns:
#'   \describe{
#'     \item{`crashes`}{Number of crashes.}
#'     \item{`fatalities`}{People killed.}
#'     \item{`serious_injuries`}{People seriously injured.}
#'     \item{`other_injuries`}{People with other injuries.}
#'     \item{`ksi`}{People killed or seriously injured.}
#'     \item{`fatalities_per_1000_crashes`}{People killed per 1,000 crashes.}
#'     \item{`serious_injuries_per_1000_crashes`}{People seriously injured per 1,000 crashes.}
#'     \item{`other_injuries_per_1000_crashes`}{People with other injuries per 1,000 crashes.}
#'     \item{`ksi_per_1000_crashes`}{People killed or seriously injured per 1,000 crashes.}
#'   }
#' @examples
#' summarise_crashes(vic_crashes, by = "hour")
#'
#' vic_crashes |>
#'   filter_crashes(start_date = "2022-01-01", end_date = "2024-12-31") |>
#'   summarise_crashes(by = c("day_of_week", "hour"))
#' 
#' @export
summarise_crashes <- function(data, by) {
  data |>
    dplyr::summarise(
      crashes = dplyr::n(),
      fatalities = sum(fatality),
      serious_injuries = sum(seriousinjury),
      other_injuries = sum(otherinjury),
      ksi = fatalities + serious_injuries,
      fatalities_per_1000_crashes = 1000 * fatalities / crashes,
      serious_injuries_per_1000_crashes = 1000 * serious_injuries / crashes,
      other_injuries_per_1000_crashes = 1000 * other_injuries / crashes,
      ksi_per_1000_crashes = 1000 * ksi / crashes,
      .by = dplyr::all_of(by)
    ) |>
    dplyr::arrange(dplyr::across(dplyr::all_of(by)))
}
