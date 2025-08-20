# Eduvos Graduate Survey Analysis

##  Overview

This repository contains the code and analysis for a data exploration and visualization project based on a survey of Eduvos IT graduates. The project cleans and processes the raw survey data, performs exploratory data analysis (EDA), and presents the insights through an interactive dashboard built with R Shiny.

The dashboard allows users to explore trends in:
*   **Technology Stacks:** Popular programming languages, databases, platforms, and AI tools.
*   **Career Outcomes:** Employment rates, popular industries, and job roles.
*   **Demographics:** Distribution of graduates across campuses and fields of study.

##  Project Structure

```
Eduvos-Graduate-Survey/
├── data/
│   ├── graduate_survey.csv          # Raw survey data (not included in repo)
│   ├── cleaned_graduate_survey.csv  # Processed and cleaned data (generated)
│   └── top_campuses.csv             # Subset of data for top 5 campuses (generated)
├── scripts/
│   ├── NdivhoMasiyaFinalRSCRIPT.R   # Main data cleaning, EDA, and static plotting script
│   ├── Ndivho MASIYA R SCRIPT.R     # Alternative/earlier version of the analysis script
│   └── app.R                        # R Shiny dashboard script (if separated)
├── images/                          # Folder for storing generated plots
│   ├── Industry Trends-1.png
│   └── setup-1.png
├── README.md                        # This file
└── Eduvos_Graduate_Survey_Dashboard.Rproj  # RStudio project file (optional)
```

## Installation & Setup

To run this project locally, you will need **R** and **RStudio** installed.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/eduvos-graduate-survey.git
    cd eduvos-graduate-survey
    ```

2.  **Install Required R Packages:**
    Open RStudio and run the following command in the console to install all necessary dependencies.
    ```r
    install.packages(c("dplyr", "readr", "tidyr", "ggplot2", "forcats", "shiny", "shinydashboard", "plotly", "DT"))
    ```

3.  **Add the Data:**
    *   Place the original `graduate_survey.csv` file into the `data/` directory.
    *   *Note: The original data file is not included in this repository for privacy reasons.*

## Usage

### 1. Data Cleaning & Analysis (Scripts)
Run the main R scripts to reproduce the data cleaning and generate static plots.
*   **`scripts/NdivhoMasiyaFinalRSCRIPT.R`**: The primary script for processing data, handling missing values, standardizing campus names, and creating visualizations for the top 5 campuses.
*   **`scripts/Ndivho MASIYA R SCRIPT.R`**: An alternative script that performs similar analysis and includes a different version of the Shiny app.

### 2. Interactive Dashboard (Shiny App)
To launch the interactive dashboard:

**Option A: If the app code is in a separate `app.R` file:**
```r
shiny::runApp("app.R")
```

**Option B: If using the script that contains the app:**
*   Open `scripts/Ndivho MASIYA R SCRIPT.R` in RStudio.
*   Select and run the entire code block from `library(shiny)` to `shinyApp(ui, server)`.
*   A window will open displaying the interactive dashboard.

## Key Features of the Dashboard

The Shiny dashboard is organized into several tabs:

*   **Demographics:** Visualizes the distribution of age, study fields, and campuses.
*   **Employment:** Shows employment status, salary distribution, and salary by field of study.
*   **Tech Tools:** An interactive plot showing the top 10 tools for selected categories (Programming Languages, Databases, Web Frameworks, AI Tools).
*   **Industry:** A plot displaying the popular industries graduates enter.
*   **Data Table:** A searchable and sortable table of the underlying filtered data.

##  Methodology

1.  **Data Cleaning:**
    *   Handled missing values by replacing blanks with `NA` and then with "Unknown".
    *   Standardized campus names (e.g., merged "Durban Campus" and "Umhlanga Campus").
    *   Filtered the dataset to include only the top 5 campuses by response count.

2.  **Analysis:**
    *   **Tool Popularity:** Split multi-response columns (e.g., `ProgLang`, `Databases`) and counted frequencies.
    *   **Industry & Roles:** Analyzed the most common industries and job roles for graduates.
    *   **Employment Rate:** Calculated employment rates by study field by categorizing employment status into "Employed" and "Unemployed".

## Results

The analysis revealed key insights about Eduvos IT graduates, including:
*   The most in-demand programming languages and databases.
*   The industries that hire the most graduates (e.g., IT, Financial Services).
*   Employment rates across different fields of study like Data Science, IT, and Computer Science.
*   The most common job roles graduates transition into.

Static visualizations of these results can be found in the `images/` directory.

## 👤 Author

**Ndivho Masiya**

## 📄 License

This project is for educational and portfolio purposes. The data is proprietary and confidential.
