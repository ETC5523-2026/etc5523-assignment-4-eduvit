library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(leaflet)
library(roadcrashVIC)

# Choices built from the data
year_range <- range(vic_crashes$year)

month_starts <- seq(
  as.Date(format(min(vic_crashes$accident_date), "%Y-%m-01")),
  max(vic_crashes$accident_date),
  by = "month"
)
# Names are shown to the user ("Jan 2012"), values are sent to the server ("2012-01-01")
month_choices <- setNames(as.character(month_starts), format(month_starts, "%b %Y"))

measure_choices <- c("Crashes" = "crashes", "Killed or seriously injured (KSI)" = "ksi", "Deaths" = "fatalities")
when_choices <- c("Month" = "month", "Day of the week" = "day_of_week", "Hour of the day" = "hour")

ui <- page_navbar(
  id = "main_nav", 
  title = "Victoria Road Crash Explorer",
  fillable = FALSE, # let the page scroll
  header = list(
    p(
      class = "mb-1",
      strong(paste0(
        "How have road crashes in Victoria changed since ", year_range[1], "? ",
        "Where do most crashes happen, when are they most frequent, and which road users are most vulnerable?"
      ))
    ),
    p(
      paste0(
        "This dashboard presents the road crashes resulting in injury or death recorded by Victoria Police ",
        "from ", year_range[1], " to ", year_range[2], ", to help members of the public explore these questions ",
        "across the state and within their local area."
      )
    )
  ),
  nav_panel(
    "Victoria",
    layout_sidebar(
      sidebar = sidebar(
        sliderInput(
          "vic_years", "Choose a time interval to analyze",
          min = year_range[1],
          max = year_range[2],
          value = year_range,
          step = 1,
          sep = ""
        ),
        selectInput(
          "vic_measure", "Choose a metric to analyze",
          choices = measure_choices
        ),
        selectInput(
          "vic_scale", "Show results as:",
          choices = c("Count" = "count", "Per 100k residents" = "per_100k", "Index (1st year = 100)" = "index")
        ),
        helpText(
          "Definitions of each metric and scale, and notes on the data, are in the",
          actionLink("vic_go_about", "About"), "tab."
        )
      ),
      layout_column_wrap(
        width = 1/3,
        value_box(title = "Crashes", value = textOutput("vic_crashes_box")),
        value_box(title = "KSI", value = textOutput("vic_ksi_box")),
        value_box(title = "Deaths", value = textOutput("vic_deaths_box"))
      ),
      card(
        full_screen = TRUE, height = 500,
        card_header("How has it changed?"),
        plotOutput("vic_trend")
      ),
      layout_column_wrap(
        width = 1/2,
        height = 500,
        card(
          full_screen = TRUE,
          card_header("When do crashes happen most?"),
          selectInput("vic_when", NULL, choices = when_choices),
          plotOutput("vic_when_chart")
        ),
        card(
          full_screen = TRUE,
          card_header("Who is the most vulnerable road user?"),
          plotOutput("vic_vulnerable_chart")
        )
      ),
      card(
        full_screen = TRUE, height = 700,
        card_header("Where do crashes happen most?"),
        leafletOutput("vic_map")
      )
    )
  ),
  nav_panel(
    "My area",
    layout_sidebar(
      sidebar = sidebar(
        selectizeInput(
          "area_lga", "Choose one or multiple LGA to analyze",
          choices = sort(vic_lga$lga_name),
          multiple = TRUE
        ),
        selectInput(
          "area_from", "From:",
          choices = month_choices,
          selected = month_choices[length(month_choices) - 11] # last 12 months by default
        ),
        selectInput(
          "area_to", "To:",
          choices = month_choices,
          selected = month_choices[length(month_choices)]
        ),
        selectInput(
          "area_severity", "Severity of accident:",
          choices = c("All crashes" = "all", "Fatal + serious" = "ksi")
        ),
        selectInput(
          "area_road_user", "Road user",
          choices = c("All" = "all", "Pedestrian" = "pedestrian", "Cyclist" = "cyclist", "Motorcycle riders" = "motorcyclist")
        ),
        selectInput(
          "area_scale", "Show results as:",
          choices = c("Count" = "count", "Per 1,000 crashes" = "per_1000")
        ),
        helpText(
          p("One or more LGAs can be selected."),
          p("\"Fatal + serious\" hides crashes in which no one was killed or seriously injured."),
          p("\"Road user\" shows crashes in which at least one road user of that category was involved.",
            "It does not show how many of them were injured.")
        )
      ),
      layout_column_wrap(
        width = 1/3,
        value_box(title = "Crashes", value = textOutput("area_crashes_box")),
        value_box(title = "KSI", value = textOutput("area_ksi_box")),
        value_box(title = "Deaths", value = textOutput("area_deaths_box"))
      ),
      layout_column_wrap(
        width = 1/2,
        height = 700,
        card(full_screen = TRUE, card_header("Where have accidents happened?"), leafletOutput("area_map")),
        card(full_screen = TRUE, card_header("Top 5 roads"), tableOutput("area_top_roads"))
      ),
      layout_column_wrap(
        width = 1/2,
        height = 500,
        card(
          full_screen = TRUE,
          card_header("When do crashes happen most?"),
          selectInput("area_when", NULL, choices = when_choices),
          plotOutput("area_when_chart")
        ),
        card(
          full_screen = TRUE,
          card_header("Who is the most vulnerable road user?"),
          plotOutput("area_vulnerable_chart")
        )
      )
    )
  ),
  nav_panel(
    "About",
    markdown(readLines("about.md")) # text in inst/app/about.md
  )
)

server <- function(input, output, session) {
  # "About" link in the Victoria sidebar
  observeEvent(input$vic_go_about, nav_select("main_nav", "About"))
}

shinyApp(ui, server)