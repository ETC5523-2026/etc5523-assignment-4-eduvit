#' Estimated resident population of Victorian local government areas
#'
#' Estimated resident population of each Victorian local government area (LGA) at 30 June, 2012 to 2025.
#'
#' @format A tibble with 1,120 rows and 4 columns:
#' \describe{
#'   \item{lga_code}{(character) ABS LGA code.}
#'   \item{lga_name}{(character) LGA name in capitals, spelled as in [vic_lga] and [vic_crashes].}
#'   \item{year}{(integer) Year (population at 30 June).}
#'   \item{population}{(numeric) Estimated resident population.}
#' }
#'
#' @source Australian Bureau of Statistics, *Regional population, 2024-25*
#'   (Cat. no. 3218.0), dataset ERP_LGA2025, <https://www.abs.gov.au/statistics/people/population/regional-population/2024-25>,
#'   licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
#'   Retrieved 25 October 2026. **Changes made:** kept Victorian LGAs for 2012 to 2025; renamed columns; LGA names
#'   in capitals without the "(Vic.)" suffix.
"vic_population"
