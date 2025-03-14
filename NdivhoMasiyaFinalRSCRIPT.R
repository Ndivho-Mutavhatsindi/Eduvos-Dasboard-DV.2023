library(dplyr)
library(readr)

#load data set into a data frame
df<- read.csv("graduate_survey.csv")

#selecting relevant columns
gradsurv<- df %>%
  select(Campus, StudyField, Branch, Role, EduLevel, ProgLang, Databases, Platform, WebFramework, Industry, AISearch, AITool, Employment)

#missing value treatment steps:
#1.changing blank rows to NA
gradsurv[gradsurv== ""] <- NA

#2. determine the class of each column
glimpse(gradsurv)

#3. determine percentage of "NA" in the dataframe 
total_cells= prod(dim(gradsurv))
print(total_cells)

Na_cells= sum(is.na(gradsurv))
print(Na_cells)

Na_percentage= (Na_cells * 100) / (total_cells)
print(Na_percentage)

#4. filtering out the empty rows
gradsurv1= gradsurv[complete.cases(gradsurv), ]
print(gradsurv1)

#standardizing the catergorical data
gradsurv1 <- gradsurv1 %>% mutate(Campus= case_when(
  Campus %in% c("Durban Campus", "Umhlanga Campus") ~"Umhlanga Campus",
  TRUE~ Campus
))
gradsurv1 <- gradsurv1 %>% mutate(Campus= case_when(
  Campus %in% c("Mbombela Campus", "Nelspruit Campus") ~"Mbombela Campus",
  TRUE~ Campus
))
gradsurv1 <- gradsurv1 %>% mutate(Campus= case_when(
  Campus %in% c("Port Elizabeth Campus", "Nelson Mandela Bay Campus") ~"Port Elizabeth Campus",
  TRUE~ Campus
))

#subsetting 3-5 with the most responses
#1. counting the responses
campus_res <- gradsurv1 %>% count(Campus, sort= TRUE)

#2. finding the top 5
top5 <- campus_res %>% slice(1:5) %>% pull(Campus)

#3. filtering the top 5
top5_campus <- gradsurv1 %>% filter(Campus %in% top5)

#4. subsetting
unique(top5_campus$Campus)

top_campuses <- gradsurv1 %>%
  filter(Campus %in% ( #filtering the top 5
    count(gradsurv1, Campus, sort =TRUE) %>% #counting the responses
      slice(1:5) %>% #finding the top 5
      pull(Campus)
  ))

unique(top_campuses$Campus) #subsetting

write.csv (top_campuses, "top_campuses.csv", row.names= FALSE)


# Load necessary libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(forcats) # For better ordering of categorical data

# Load dataset
top_campuses <- read.csv("top_campuses.csv", stringsAsFactors = FALSE)

# Function to count occurrences of tools
count_top_tools <- function(top_campuses, columns) {
  
  # Selecting relevant columns
  sel_columns <- top_campuses %>% select(all_of(columns))
  
  # Reshaping data from wide to long format
  long_format <- sel_columns %>%
    pivot_longer(cols = everything(), names_to = "Category", values_to = "Tools") %>%
    separate_rows(Tools, sep = ";")  # Splitting tools into separate rows
  
  # Counting occurrences of tools
  count_top_tool <- long_format %>%
    count(Category, Tools, sort = TRUE)
  
  return(count_top_tool)  # Ensure function returns the counted dataset
}

# Columns containing tool names
tool_col <- c("ProgLang", "Databases", "Platform", "WebFramework", "AISearch", "AITool")

# Using the function to count occurrences
top_tools <- count_top_tools(top_campuses, tool_col)

print(top_tools)

# ===========================
# Plotting Top Tools
# ===========================
plot_top_tools <- function(category_name, title, x_label) {
  ggplot(filter(top_tools, Category == category_name), aes(x = fct_reorder(Tools, n), y = n, fill = Tools)) +
    geom_col(show.legend = FALSE) +
    coord_flip() +
    ggtitle(title) +
    xlab(x_label) +
    ylab("Count") +
    theme_minimal()
}

# Plot for each category
plot_top_tools("ProgLang", "Top Programming Languages Used by Graduates", "Language")
plot_top_tools("Databases", "Top Databases Used by Graduates", "Database")
plot_top_tools("Platform", "Top Platforms Used by Graduates", "Platform")
plot_top_tools("WebFramework", "Top Web Frameworks Used by Graduates", "Web Framework")
plot_top_tools("AISearch", "Top AI Search Tools Used by Graduates", "AI Search Tool")
plot_top_tools("AITool", "Top AI Developer Tools Used by Graduates", "AI Tool")


industries_count <- function(top_campuses, column) {
  
  industry_info <- top_campuses %>%
    select(all_of(column)) %>%
    separate_rows(Industry, sep = ";") # Splitting industries into separate rows
  
  count_industry <- industry_info %>%
    count(Industry, sort = TRUE)
  
  return(count_industry)
}

industry_total <- industries_count(top_campuses, "Industry")

ggplot(industry_total, aes(x = fct_reorder(Industry, n), y = n, fill = Industry)) +
  geom_col(show.legend = FALSE) +
  ggtitle("Popular Industries Graduates Go Into") +
  xlab("Industry") +
  ylab("Number of Graduates") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Selecting specific columns
top_job <- top_campuses %>% select("StudyField", "Role")

# Counting occurrences of roles based on StudyField
top_job_counts <- count(top_job, StudyField, Role)

# Plotting Top Job Roles
ggplot(top_job_counts, aes(x = fct_reorder(Role, n), y = n, fill = Role)) +
  geom_col(show.legend = FALSE) +
  ggtitle("Top Roles Graduates Go Into") +
  xlab("Job Roles") +
  ylab("Count of Graduates in Various Roles") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Standardizing Employment Status
employment_state <- top_campuses %>%
  mutate(Employment = case_when(
    Employment %in% c("Not employed, but looking for work", "Not employed, but looking for work;Employed, part-time",
                      "Not employed, but looking for work;Not employed, and not looking for work",
                      "Not employed, but looking for work;Student, full-time",
                      "Not employed, but looking for work;Student, full-time;Student, part-time",
                      "Not employed, but looking for work;Student, part-time") ~ "Unemployed",
    TRUE ~ "Employed"
  ))

# Grouping by StudyField to calculate employment rate
employment_summary <- employment_state %>%
  group_by(StudyField) %>%
  summarise(
    Total_Graduates = n(),
    Employed = sum(Employment == "Employed"),
    Employment_Rate = (Employed / Total_Graduates) * 100
  )

# Print Employment Summary
print(employment_summary)

# Plot Employment Rate
ggplot(employment_summary, aes(x = fct_reorder(StudyField, Employment_Rate), y = Employment_Rate, fill = StudyField)) +
  geom_col(show.legend = FALSE) +
  ggtitle("Employment Rate by Study Field") +
  xlab("Study Field") +
  ylab("Employment Rate (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(forcats)
library(shinydashboard)

# Load dataset
top_campuses <- read.csv("top_campuses.csv", stringsAsFactors = FALSE)

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Eduvos Graduate Survey"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Top Tools", tabName = "top_tools", icon = icon("cogs")),
      menuItem("Industries", tabName = "industries", icon = icon("briefcase")),
      menuItem("Job Roles", tabName = "job_roles", icon = icon("users")),
      menuItem("Employment Rate", tabName = "employment", icon = icon("chart-line"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              h2("Welcome to the Eduvos Graduate Survey Dashboard"),
              p("This dashboard provides insights into the tools, industries, and roles of Eduvos IT graduates.")
      ),
      tabItem(tabName = "top_tools",
              selectInput("category", "Select Tool Category:", 
                          choices = c("ProgLang", "Databases", "Platform", "WebFramework", "AISearch", "AITool")),
              plotOutput("top_tools_plot")
      ),
      tabItem(tabName = "industries",
              plotOutput("industry_plot")
      ),
      tabItem(tabName = "job_roles",
              plotOutput("job_roles_plot")
      ),
      tabItem(tabName = "employment",
              plotOutput("employment_plot")
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  output$top_tools_plot <- renderPlot({
    tool_data <- top_campuses %>%
      select(all_of(input$category)) %>%
      pivot_longer(cols = everything(), names_to = "Category", values_to = "Tools") %>%
      separate_rows(Tools, sep = ";") %>%
      count(Tools, sort = TRUE)
    
    ggplot(tool_data, aes(x = fct_reorder(Tools, n), y = n, fill = Tools)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      ggtitle(paste("Top", input$category, "Used by Graduates")) +
      xlab("Tool") +
      ylab("Count") +
      theme_minimal()
  })
  
  output$industry_plot <- renderPlot({
    industry_data <- top_campuses %>%
      select(Industry) %>%
      separate_rows(Industry, sep = ";") %>%
      count(Industry, sort = TRUE)
    
    ggplot(industry_data, aes(x = fct_reorder(Industry, n), y = n, fill = Industry)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      ggtitle("Popular Industries Graduates Go Into") +
      xlab("Industry") +
      ylab("Number of Graduates") +
      theme_minimal()
  })
  
  output$job_roles_plot <- renderPlot({
    job_data <- top_campuses %>% count(StudyField, Role)
    
    ggplot(job_data, aes(x = fct_reorder(Role, n), y = n, fill = Role)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      ggtitle("Top Roles Graduates Go Into") +
      xlab("Job Roles") +
      ylab("Count of Graduates") +
      theme_minimal()
  })
  
  output$employment_plot <- renderPlot({
    employment_data <- top_campuses %>%
      mutate(Employment = ifelse(Employment %in% c("Not employed, but looking for work", 
                                                   "Not employed, but looking for work;Employed, part-time", 
                                                   "Not employed, but looking for work;Student, full-time"), 
                                 "Unemployed", "Employed")) %>%
      group_by(StudyField) %>%
      summarise(Total_Graduates = n(),
                Employed = sum(Employment == "Employed"),
                Employment_Rate = (Employed / Total_Graduates) * 100)
    
    ggplot(employment_data, aes(x = fct_reorder(StudyField, Employment_Rate), y = Employment_Rate, fill = StudyField)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      ggtitle("Employment Rate by Study Field") +
      xlab("Study Field") +
      ylab("Employment Rate (%)") +
      theme_minimal()
  })
}

shinyApp(ui, server)


