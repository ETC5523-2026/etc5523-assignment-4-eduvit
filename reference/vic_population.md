# Estimated resident population of Victorian local government areas

Estimated resident population of each Victorian local government area
(LGA) at 30 June, 2012 to 2025.

## Usage

``` r
vic_population
```

## Format

A tibble with 1,120 rows and 4 columns:

- lga_code:

  (character) ABS LGA code.

- lga_name:

  (character) LGA name in capitals, spelled as in
  [vic_lga](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_lga.md)
  and
  [vic_crashes](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_crashes.md).

- year:

  (integer) Year (population at 30 June).

- population:

  (numeric) Estimated resident population.

## Source

Australian Bureau of Statistics, *Regional population, 2024-25* (Cat.
no. 3218.0), dataset ERP_LGA2025,
<https://www.abs.gov.au/statistics/people/population/regional-population/2024-25>,
licensed under [CC BY
4.0](https://creativecommons.org/licenses/by/4.0/). Retrieved 25 October
2026. **Changes made:** kept Victorian LGAs for 2012 to 2025; renamed
columns; LGA names in capitals without the "(Vic.)" suffix.
