library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  title = " Victoria Road Crash Explorer",
  subtitle = "How have road crashes changed since 2012? Where do most happen, when, and which road users are most vulnerable?",
  tabsetPanel(
    tabPanel(
      "Victoria", fluid=TRUE,
      sidebarLayout(
        sidebarPanel(
          sliderInput(
            "years", "Choose a time interval to analyze",
            min = min(unique(vic_crashes$year)),
            max = max(unique(vic_crashes$year)),
            value = c(min(unique(vic_crashes$year)), max(unique(vic_crashes$year)))
          ),
          selectInput(
            "measure", "Choose a metric to analyze",
            choices = c("Crashes", "KSI", "Deaths")
          ),
          selectInput(
            "scale", "Show results as:",
            choices = c("Count", "Per 100k residents", "Index (1st year = 100)")
          ),
          card(
            "Short help text"
          )
        ),
        mainPanel(
          layout_column_wrap(
            width = 1/3,
            height = 200,
            card(full_screen = TRUE, card_header("Crashes"), cardBody(summarise_crashes(vic_crashes, by="year")$crashes)),
            card(full_screen = TRUE, card_header("KSI"), cardBody(summarise_crashes(vic_crashes, by="year")$ksi)),
            card(full_screen = TRUE, card_header("Deaths"), cardBody(summarise_crashes(vic_crashes, by="year")$fatalities))
          ),
          layout_column_wrap(
            width = 1,
            height = 500,
            card(full_screen = TRUE, card_header("How has it changed?"), plotOutput("yearly_trend"))
          ),
          layout_column_wrap(
            width = 1/2,
            height = 500,
            card(full_screen = TRUE, card_header("When accidents occur the most?"), plotOutput("bar_chart_when")),
            card(full_screen = TRUE, card_header("Who is the most vulnerable road user?"), plotOutput("bar_chart_vulnerable")),
          ),
          layout_column_wrap(
            width = 1,
            height = 700,
            card(full_screen = TRUE, card_header("Where accidents occur the most?"), plotOutput("victoria_map")),
          )
        )
      )
    ),
    tabPanel(
      "My area", fluid=TRUE,
      sidebarLayout(
        sidebarPanel(
          selectizeInput(
            "LGA", "Choose one or multiple LGA to analyze",
            choices = sort(unique(vic_crashes$lga_name)),
            multiple=TRUE
          ),
          selectInput(
            "start_month", "From:",
            choices = sort(unique(vic_crashes |> distinct(month, year)))
          ),
          selectInput(
            "end_month", "To:",
            choices = sort(unique(vic_crashes |> distinct(month, year)))
          ),
          selectInput(
            "crash_severity", "Severity of accident:",
            choices = c("All crashes", "Fatal + serious")
          ),
          selectInput(
            "road_user", "Road user",
            choices = c("All", "Pedestrian", "Cyclist", "Motorcycle riders")
          ),
          selectInput(
            "scale", "Show results as:",
            choices = c("Count", "Per 100k residents")
          ),
          card(
            "Short help text"
          )
        ),
        mainPanel(
          layout_column_wrap(
            width = 1/3,
            height = 200,
            card(full_screen = TRUE, card_header("Crashes"), cardBody(summarise_crashes(vic_crashes, by="year")$crashes)),
            card(full_screen = TRUE, card_header("KSI"), cardBody(summarise_crashes(vic_crashes, by="year")$ksi)),
            card(full_screen = TRUE, card_header("Deaths"), cardBody(summarise_crashes(vic_crashes, by="year")$fatalities))
          ),
          layout_column_wrap(
            width = 1/2,
            height = 700,
            card(full_screen = TRUE, card_header("Where have accidents happened?"), plotOutput("lga_map")),
            card(full_screen = TRUE, card_header("Top 5 accident hotspots"), textOutput("top_5_hotspots"))
          ),
          layout_column_wrap(
            width = 1/2,
            height = 500,
            card(full_screen = TRUE, card_header("When accidents occur the most?"), plotOutput("bar_chart_when")),
            card(full_screen = TRUE, card_header("Who is the most vulnerable road user?"), plotOutput("bar_chart_vulnerable")),
          )
        )
      )
    )
  )
)


ui <- page_sidebar(
  title = " Victoria Road Crash Explorer",
  subtitle = "How have road crashes changed since 2012? Where do most happen, when, and which road users are most vulnerable?",
  sidebar = sidebar(
    sliderInput(
      "years", "Choose a time interval to analyze",
      min = min(unique(vic_crashes$year)),
      max = max(unique(vic_crashes$year)),
      value = c(min(unique(vic_crashes$year)), max(unique(vic_crashes$year)))
    ),
    selectInput(
      "measure", "Choose a metric to analyze",
      choices = c("Crashes", "KSI", "Deaths")
    ),
    selectInput(
      "scale", "Show results as:",
      choices = c("Count", "Per 100k residents", "Index (1st year = 100)")
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)