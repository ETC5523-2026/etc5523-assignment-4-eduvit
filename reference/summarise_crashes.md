# Summarise crashes and casualties by one or more variables

Counts crashes and people killed and injured in each group, and the
number of casualties per 1,000 crashes. KSI is people killed or
seriously injured.

## Usage

``` r
summarise_crashes(data, by)
```

## Arguments

- data:

  A data frame of crashes, such as
  [vic_crashes](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_crashes.md),
  optionally filtered with
  [`filter_crashes()`](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/filter_crashes.md).

- by:

  Character vector of columns to group by, for example `"hour"` or
  `c("day_of_week", "hour")`.

## Value

A tibble with one row per group, sorted by the grouping columns, with
columns:

- `crashes`:

  Number of crashes.

- `fatalities`:

  People killed.

- `serious_injuries`:

  People seriously injured.

- `other_injuries`:

  People with other injuries.

- `ksi`:

  People killed or seriously injured.

- `fatalities_per_1000_crashes`:

  People killed per 1,000 crashes.

- `serious_injuries_per_1000_crashes`:

  People seriously injured per 1,000 crashes.

- `other_injuries_per_1000_crashes`:

  People with other injuries per 1,000 crashes.

- `ksi_per_1000_crashes`:

  People killed or seriously injured per 1,000 crashes.

## Examples

``` r
summarise_crashes(vic_crashes, by = "hour")
#> # A tibble: 24 × 10
#>     hour crashes fatalities serious_injuries other_injuries   ksi
#>    <int>   <int>      <dbl>            <dbl>          <dbl> <dbl>
#>  1     0    2610        106             1377           2000  1483
#>  2     1    2158         92             1201           1537  1293
#>  3     2    1674         78              955           1205  1033
#>  4     3    1559         70              899           1054   969
#>  5     4    1550         53              841           1017   894
#>  6     5    2793        103             1418           1886  1521
#>  7     6    6259        159             2800           4556  2959
#>  8     7    8699        135             3503           6885  3638
#>  9     8   12764        145             4471          11270  4616
#> 10     9   10497        154             4023           9073  4177
#> # ℹ 14 more rows
#> # ℹ 4 more variables: fatalities_per_1000_crashes <dbl>,
#> #   serious_injuries_per_1000_crashes <dbl>,
#> #   other_injuries_per_1000_crashes <dbl>, ksi_per_1000_crashes <dbl>

vic_crashes |>
  filter_crashes(start_date = "2022-01-01", end_date = "2024-12-31") |>
  summarise_crashes(by = c("day_of_week", "hour"))
#> # A tibble: 168 × 11
#>    day_of_week  hour crashes fatalities serious_injuries other_injuries   ksi
#>    <fct>       <int>   <int>      <dbl>            <dbl>          <dbl> <dbl>
#>  1 Monday          0      55          2               17             47    19
#>  2 Monday          1      47          1               23             35    24
#>  3 Monday          2      37          3               16             28    19
#>  4 Monday          3      39          1               19             30    20
#>  5 Monday          4      44          2               13             34    15
#>  6 Monday          5     123          3               54             89    57
#>  7 Monday          6     260          3              101            183   104
#>  8 Monday          7     332          3              131            248   134
#>  9 Monday          8     465          3              143            456   146
#> 10 Monday          9     339          2              120            310   122
#> # ℹ 158 more rows
#> # ℹ 4 more variables: fatalities_per_1000_crashes <dbl>,
#> #   serious_injuries_per_1000_crashes <dbl>,
#> #   other_injuries_per_1000_crashes <dbl>, ksi_per_1000_crashes <dbl>
```
