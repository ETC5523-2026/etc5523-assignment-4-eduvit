# Crash and casualty rates per 100,000 residents

Adds the population and the number of crashes and casualties per 100,000
residents per year to
[`summarise_crashes()`](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/summarise_crashes.md).
Groups that cover several years use the population summed over those
years.

## Usage

``` r
crash_rates(data, population, by = "year")
```

## Arguments

- data:

  A data frame of crashes, such as
  [vic_crashes](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_crashes.md),
  optionally filtered with
  [`filter_crashes()`](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/filter_crashes.md).

- population:

  A data frame of population by `year` and `lga_name`, such as
  [vic_population](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_population.md).

- by:

  `"year"`, `"lga_name"` or `c("year", "lga_name")`.

## Value

The columns of
[`summarise_crashes()`](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/summarise_crashes.md),
plus:

- `population`:

  Residents, summed over the years in the group.

- `crashes_per_100k`:

  Crashes per 100,000 residents per year.

- `fatalities_per_100k`:

  People killed per 100,000 residents per year.

- `serious_injuries_per_100k`:

  People seriously injured per 100,000 residents per year.

- `other_injuries_per_100k`:

  People with other injuries per 100,000 residents per year.

- `ksi_per_100k`:

  People killed or seriously injured per 100,000 residents per year.

## Examples

``` r
# Victoria, year by year
crash_rates(vic_crashes, vic_population, by = "year")
#> # A tibble: 14 × 16
#>     year crashes fatalities serious_injuries other_injuries   ksi
#>    <int>   <int>      <dbl>            <dbl>          <dbl> <dbl>
#>  1  2012   13912        282             5480          12685  5762
#>  2  2013   14023        243             5493          12708  5736
#>  3  2014   14503        248             5922          12984  6170
#>  4  2015   15684        252             6254          13972  6506
#>  5  2016   15779        290             6787          13575  7077
#>  6  2017   13351        259             6562          10966  6821
#>  7  2018   12765        213             6542          10215  6755
#>  8  2019   14398        266             6716          12109  6982
#>  9  2020   12170        211             5338           9843  5549
#> 10  2021   14012        234             5800          11924  6034
#> 11  2022   15041        241             5440          13608  5681
#> 12  2023   15566        295             5889          13692  6184
#> 13  2024   15393        284             5624          13394  5908
#> 14  2025   15468        289             6109          13295  6398
#> # ℹ 10 more variables: fatalities_per_1000_crashes <dbl>,
#> #   serious_injuries_per_1000_crashes <dbl>,
#> #   other_injuries_per_1000_crashes <dbl>, ksi_per_1000_crashes <dbl>,
#> #   population <dbl>, crashes_per_100k <dbl>, fatalities_per_100k <dbl>,
#> #   serious_injuries_per_100k <dbl>, other_injuries_per_100k <dbl>,
#> #   ksi_per_100k <dbl>

# Average annual rate in each LGA over 2021 to 2025
vic_crashes |>
  filter_crashes(start_date = "2021-01-01", end_date = "2025-12-31") |>
  crash_rates(vic_population, by = "lga_name")
#> # A tibble: 81 × 16
#>    lga_name   crashes fatalities serious_injuries other_injuries   ksi
#>    <chr>        <int>      <dbl>            <dbl>          <dbl> <dbl>
#>  1 ALPINE         257          6              108            208   114
#>  2 ARARAT         173         14               82            143    96
#>  3 BALLARAT      1448         16              514           1427   530
#>  4 BANYULE       1026          6              243            988   249
#>  5 BASS COAST     403         13              205            404   218
#>  6 BAW BAW        888         27              344            737   371
#>  7 BAYSIDE        813          2              349            596   351
#>  8 BENALLA        199          7               76            167    83
#>  9 BOROONDARA    1485         12              463           1259   475
#> 10 BRIMBANK      2220         34              882           1911   916
#> # ℹ 71 more rows
#> # ℹ 10 more variables: fatalities_per_1000_crashes <dbl>,
#> #   serious_injuries_per_1000_crashes <dbl>,
#> #   other_injuries_per_1000_crashes <dbl>, ksi_per_1000_crashes <dbl>,
#> #   population <dbl>, crashes_per_100k <dbl>, fatalities_per_100k <dbl>,
#> #   serious_injuries_per_100k <dbl>, other_injuries_per_100k <dbl>,
#> #   ksi_per_100k <dbl>
```
