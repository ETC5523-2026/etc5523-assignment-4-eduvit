#' Estimated resident population of Victorian local government areas
#'
#' Estimated resident population (ERP) of each Victorian local government area (LGA) as at 30 June each year, from 2012 to 2025,
#' on 2025 LGA boundaries. It is included so crashes can be compared with the number of people living in each area.
#'
#' @format A tibble with 1134 rows and 4 columns:
#' \describe{
#'   \item{lga_code}{(character) ABS LGA code. Victorian codes start with 2.}
#'   \item{lga_name}{(character) LGA name.}
#'   \item{year}{(integer) Reference year (population at 30 June).}
#'   \item{population}{(numeric) Estimated resident population, in persons.}
#' }
#' 
#' @source Australian Bureau of Statistics, *Regional population, 2024-25*
#'   (Cat. no. 3218.0), dataset ERP_LGA2025, <https://www.abs.gov.au/statistics/people/population/regional-population/2024-25>,
#'   licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
#'   Retrieved 25 October 2026. **Changes made:** filtered to Victoria and to 2012
#'   onwards; columns renamed.
"vic_population"