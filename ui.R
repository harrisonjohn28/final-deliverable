library(plotly)
library(bslib)
library(shiny)
library(thematic)
library(showtext)

# Read in clean csv file for bubble chart
clean_book_data <- read.csv("clean_book_data.csv")
# Read in clean csv file for line chart
genre_data <- read.csv("top_10_genres_per_month.csv")
# Read in clean csv file for bar chart
format_data <- read.csv("format_trunc.csv")

# Setting our default theme to flatly and adding css
shiny_theme <- bs_theme(bootswatch = "flatly") %>% 
  bs_add_rules(sass::sass_file("style.scss"))

# Intro tab
intro_tab <- tabPanel(
  "Intro",
   fluidPage(
      includeHTML("introduction.html")
  )
)

# Making sidebar widgets for title selection from a fill/dropdown
title_widget <- sidebarPanel(
  selectInput(
    inputId = "title",
    label = "Select Title(s)",
    choices = clean_book_data$Title_1,
    multiple = TRUE,
    selected = "So You Want To Talk About Race"
    )
)

# Displaying interactive plot, built with Plotly
bubble_plot <- mainPanel(
  plotlyOutput(outputId = "bubble_plot")
)

# Building second tab
titles_page <- tabPanel(
  "Most Popular Titles",
  sidebarLayout(
    title_widget,
    bubble_plot
   ),
  p(`class` = "ben",
    "This chart visualizes the city's interests by month in 2020. We chose to
generate this chart because it displays the five books that Seattle residents
checked out most each month from the Seattle Public Libraries in 2020. These
books represent Seattlites' interests throughout the months of 2020. We chose
to exclude all titles classified as classic literature because those titles
skewed our results away from Seattlites' current interests. People often choose
to check out classic literature from public libraries because public libraries'
collections skew towards older publications and it is more convenient to borrow
these books (that will only be read once) rather than purchase them. Such titles
include", em("Jane Eyre,"), em("Treasure Island,"), em("Pride and Prejudice,"), "and ", em("Frankenstein.")
  ),
  p(`class` = "ben",
    "Of all non-classical literature titles in 2020, the text that Seattlites were
most interested in reading for the year was Michelle Obama's memoir,",
em("Becoming,"), "followed by Ijeoma Oluo's", em("So You Want to Talk About Race"), "and
Tara Westover's memoir", em("Educated."), "Coinciding with protests in 2020 following
the death of George Floyd at the hands of police, 40% of the top ten list for
the year spoke directly on race in America; notably, aside from Obama and
Oluo's aforementioned texts, Ibram X. Kendi and Robin Wall Kimmerer are the only
other authors of color on this list with", em("How to Be an Antiracist"), "and",
em("Braiding Sweetgrass."), "In monthly terms, the highest number of monthly checkouts
was 5,218 checkouts of", em("So You Want to Talk about Race"), "followed by
3,211 checkouts of", em("White Fragility,"), "and 2,811 checkouts of",
em("Me and White Supremacy,"), "all in June, the month after George Floyd's death."
  ),
  p(`class` = "ben",
    "Checkout trends generally follow what's nationally interesting; at the end of
2020,", em("Becoming"), "sat on the New York Times bestseller list for 88 weeks, as did
Glennon Doyle's", em("Untamed"), "with 39 weeks and", em("Braiding Sweetgrass"), "with 34.")
)


# Ben's line chart page
genres_sidebar <- sidebarPanel(
  sliderInput(
    inputId = "numGenres",
    label = "Select the number of genres per month you'd like to display:",
    min = 1,
    max = 10,
    value = 6
  )
)
genre_chart <- mainPanel(
  plotlyOutput(outputId = "line_chart")
)
genres_page <- tabPanel(
  "Top Genres",
  sidebarLayout(
    genres_sidebar,
    genre_chart
  ),
  p(`class` = "ben",
    "We chose this chart to analyze the public's interest in specific genres over
    the course of the year, as a worldwide pandemic may affect the topics people 
    are interested in checking out. As we can see, the most popular genres stay 
    fairly regular relative to one another, with the exception of Juvenile Fiction 
    (YA novel), which began being checked out at an incredible rate as quarantine 
    set in. A likely explanation for this finding is that when school was canceled 
    for middle and high schoolers, many of them choose to check out their favorite 
    books to read while stuck at home. Young Adult is a very popular genre with this 
    age group and this would explain the sudden boom in checkouts."
),
p(`class` = "ben",
  "Many of the books' primary genres were labeled as fiction/nonfiction, which 
  would've been the most popular \"genres\" by far had they been included on the
  graph. Because splitting up books into these two labels is vague and 
  inconsistent (not every book had this distinction, and some had them elsewhere
  in their list of subjects), we chose to replace these labels with their secondary,
  more specific genre. \"Literature\" refers to the books that were labeled as 
  fiction but had no other listed genre. Note: When displaying 3 genres, Historical 
  Fiction and Mystery are overtaken by Juvenile Fiction from April and July. These 
  two genres should disappear, but because they re-enter the top 3 at a later point, 
  ggplotly erroneously connects the dots between these time periods. 
  The tooltips for these genres only appear over the true data points.")

)

summary_tab <- tabPanel(
  "Summary",
  fluidPage(
    includeHTML("summary.html")
  )
)

###Bar chart
chart_sidebar <- sidebarPanel(
  sliderInput(
    inputId = "barMonths",
    label = "Time Period in 2020",
    min = 1, #January
    max = 12, #December
    value = c(1, 12) #Setting slider range to full year
    ),
  checkboxGroupInput(
    "barFormat", 
    label = "Formats of Interest", 
    choices = list("Book", "eBook", "Audio", "Video", "Other"),
    selected = c("Book", "eBook", "Audio", "Video", "Other")
    )
)

format_chart <- mainPanel(
  plotlyOutput(outputId = "format_chart")
)

format_page <- tabPanel(
  "Format Checkouts",
  sidebarLayout(
    chart_sidebar,
    format_chart
  ),
  p(`class` = "ben",
    "As the times have changed, libraries have grown from just spaces to house 
    books into a cultural hub where materials of any medium can be shared - within
    the dataset, there are over 30 unique categories of materials, from books and 
    CDs to atlases and flash cards. We wanted to see the breakdown of how these 
    materials were used by the general public, while simultaneously seeing how the 
    closure of SPL locations due to the coronavirus pandemic affected checkout rates 
    over the course of the year. We split the dataset into five coded categories; 
    books, eBooks, audio-related materials such as CDs, cassettes, and audio books,
    video-related materials such as DVDs and VHS tapes, and a catch all 'other' 
    category."
  ),
  p(`class` = "ben",
    "When charting the checkout rates over the course of 2020, you're able to see
    exactly how hard SPL was hit by COVID; overall checkouts were cut in half, 
    going from over 200,000 in March to just under 100,000 in April. The split 
    in format is also pretty distinct; eBooks jump in share slightly and audio 
    checkouts shrink slightly, but physical books and videos are decimated until 
    August, when curbside pickup was opened early in the month. Overall patronage 
    never recovered from its early highs in 2020, but the continued use of eBooks 
    and digital audio book services showed that Seattlites were still wanting to 
    engage with the materials they had during quarantine. Further exploration is 
    needed to explain why the video category consistently ranked so low; is it 
    simply because SPL only did physical checkouts of videos, or are their streaming 
    services less feasible than something like a Netflix or Hulu, if they're 
    present at all?")
  
)

ui <- navbarPage(
  theme = shiny_theme,
  "INFO 201",
  intro_tab,
  titles_page,
  genres_page,
  format_page,
  summary_tab
)