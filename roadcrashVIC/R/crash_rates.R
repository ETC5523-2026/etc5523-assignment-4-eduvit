#' Crash and casualty rates per 100,000 residents
#'
#' Adds the population and the number of crashes and casualties per 100,000 residents per year to
#' [summarise_crashes()]. Groups that cover several years use the population summed over those years.
#'
#' @param data A data frame of crashes, such as [vic_crashes], optionally filtered with [filter_crashes()].
#' @param population A data frame of population by `year` and `lga_name`, such as [vic_population].
#' @param by `"year"`, `"lga_name"` or `c("year", "lga_name")`.
#'
#' @return The columns of [summarise_crashes()], plus:
#'   \describe{
#'     \item{`population`}{Residents, summed over the years in the group.}
#'     \item{`crashes_per_100k`}{Crashes per 100,000 residents per year.}
#'     \item{`fatalities_per_100k`}{People killed per 100,000 residents per year.}
#'     \item{`serious_injuries_per_100k`}{People seriously injured per 100,000 residents per year.}
#'     \item{`other_injuries_per_100k`}{People with other injuries per 100,000 residents per year.}
#'     \item{`ksi_per_100k`}{People killed or seriously injured per 100,000 residents per year.}
#'   }
#' @examples
#' # Victoria, year by year
#' crash_rates(vic_crashes, vic_population, by = "year")
#'
#' # Average annual rate in each LGA over 2021 to 2025
#' vic_crashes |>
#'   filter_crashes(start_date = "2021-01-01", end_date = "2025-12-31") |>
#'   crash_rates(vic_population, by = "lga_name")
#' @export
crash_rates <- function(data, population, by = "year") {
  # Population of the same years as the crashes
  population <- population |>
    dplyr::filter(year %in% data$year) |>
    dplyr::summarise(population = sum(population), .by = dplyr::all_of(by))

  summarise_crashes(data, by) |>
    dplyr::left_join(population, by = by) |>
    dplyr::mutate(
      crashes_per_100k = 1e5 * crashes / population,
      fatalities_per_100k = 1e5 * fatalities / population,
      serious_injuries_per_100k = 1e5 * serious_injuries / population,
      other_injuries_per_100k = 1e5 * other_injuries / population,
      ksi_per_100k = 1e5 * ksi / population
    )
}
