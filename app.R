library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(readxl)
library(tidyverse)
library(plotly)
library(DT)

# ── Custom CSS ──────────────────────────────────────────────────────────────
custom_css <- "
/* Google Fonts */
@import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap');

/* ── Root Variables ── */
:root {
  --navy:      #0a0e1a;
  --navy-mid:  #111827;
  --navy-card: #141c2e;
  --navy-border: #1e2d47;
  --amber:     #f59e0b;
  --amber-glow:#fbbf24;
  --teal:      #14b8a6;
  --teal-dim:  #0d9488;
  --rose:      #f43f5e;
  --violet:    #8b5cf6;
  --sky:       #38bdf8;
  --text-primary: #e2e8f0;
  --text-secondary: #94a3b8;
  --text-muted: #4b5563;
  --glass: rgba(20, 28, 46, 0.85);
  --glow-amber: 0 0 30px rgba(245,158,11,0.15);
  --glow-teal:  0 0 30px rgba(20,184,166,0.15);
}

/* ── Base ── */
* { box-sizing: border-box; }

body, .wrapper {
  background: var(--navy) !important;
  font-family: 'DM Sans', sans-serif !important;
  color: var(--text-primary) !important;
}

/* ── Header ── */
.main-header .logo,
.main-header .navbar {
  background: linear-gradient(90deg, #0a0e1a 0%, #111827 100%) !important;
  border-bottom: 1px solid var(--amber) !important;
  box-shadow: 0 2px 20px rgba(245,158,11,0.2) !important;
}

.main-header .logo {
  font-family: 'Syne', sans-serif !important;
  font-weight: 800 !important;
  font-size: 17px !important;
  letter-spacing: 0.05em !important;
  color: var(--amber) !important;
  border-right: 1px solid var(--navy-border) !important;
}

.main-header .navbar-nav > li > a,
.main-header .sidebar-toggle {
  color: var(--text-secondary) !important;
}

/* ── Sidebar ── */
.main-sidebar {
  background: var(--navy-mid) !important;
  border-right: 1px solid var(--navy-border) !important;
}

.sidebar-menu > li > a {
  font-family: 'DM Sans', sans-serif !important;
  font-size: 13px !important;
  font-weight: 500 !important;
  color: var(--text-secondary) !important;
  letter-spacing: 0.03em !important;
  padding: 12px 18px 12px 18px !important;
  border-left: 3px solid transparent !important;
  transition: all 0.25s ease !important;
}

.sidebar-menu > li > a:hover,
.sidebar-menu > li.active > a {
  color: var(--amber) !important;
  background: rgba(245,158,11,0.07) !important;
  border-left: 3px solid var(--amber) !important;
}

.sidebar-menu > li > a > .fa {
  margin-right: 10px !important;
  width: 18px !important;
  text-align: center !important;
}

.sidebar-menu > li.active > a {
  background: rgba(245,158,11,0.1) !important;
}

/* ── Content ── */
.content-wrapper {
  background: var(--navy) !important;
  padding: 20px !important;
}

/* ── Boxes ── */
.box {
  background: var(--navy-card) !important;
  border: 1px solid var(--navy-border) !important;
  border-radius: 12px !important;
  box-shadow: 0 4px 24px rgba(0,0,0,0.4) !important;
  margin-bottom: 20px !important;
  overflow: hidden !important;
}

.box-header {
  background: transparent !important;
  border-bottom: 1px solid var(--navy-border) !important;
  padding: 14px 20px !important;
}

.box-title {
  font-family: 'Syne', sans-serif !important;
  font-size: 14px !important;
  font-weight: 700 !important;
  letter-spacing: 0.08em !important;
  text-transform: uppercase !important;
  color: var(--text-primary) !important;
}

.box-body {
  padding: 20px !important;
  color: var(--text-primary) !important;
}

.box.box-primary   { border-top: 2px solid var(--sky)    !important; }
.box.box-info      { border-top: 2px solid var(--teal)   !important; }
.box.box-warning   { border-top: 2px solid var(--amber)  !important; }
.box.box-danger    { border-top: 2px solid var(--rose)   !important; }
.box.box-success   { border-top: 2px solid #22c55e       !important; }

/* ── Value Boxes ── */
.small-box {
  border-radius: 12px !important;
  overflow: hidden !important;
  border: 1px solid var(--navy-border) !important;
  box-shadow: 0 4px 24px rgba(0,0,0,0.35) !important;
  transition: transform 0.2s ease, box-shadow 0.2s ease !important;
  position: relative !important;
}

.small-box:hover {
  transform: translateY(-3px) !important;
  box-shadow: 0 8px 32px rgba(0,0,0,0.5) !important;
}

.small-box .inner { padding: 18px 20px !important; }

.small-box h3 {
  font-family: 'Syne', sans-serif !important;
  font-weight: 800 !important;
  font-size: 28px !important;
  line-height: 1 !important;
  margin-bottom: 4px !important;
}

.small-box p {
  font-family: 'DM Sans', sans-serif !important;
  font-size: 12px !important;
  font-weight: 500 !important;
  letter-spacing: 0.08em !important;
  text-transform: uppercase !important;
  opacity: 0.85 !important;
}

.small-box .icon { opacity: 0.25 !important; }
.small-box .icon > .fa { font-size: 60px !important; top: 8px !important; }
.small-box .small-box-footer {
  background: rgba(0,0,0,0.15) !important;
  font-size: 11px !important;
  letter-spacing: 0.05em !important;
}

.bg-blue        { background: linear-gradient(135deg, #1e40af, #1d4ed8) !important; }
.bg-light-blue  { background: linear-gradient(135deg, #0369a1, #0284c7) !important; }
.bg-purple      { background: linear-gradient(135deg, #6d28d9, #7c3aed) !important; }
.bg-green       { background: linear-gradient(135deg, #065f46, #059669) !important; }
.bg-yellow      { background: linear-gradient(135deg, #92400e, #d97706) !important; }
.bg-red         { background: linear-gradient(135deg, #9f1239, #e11d48) !important; }
.bg-aqua        { background: linear-gradient(135deg, #134e4a, #0f766e) !important; }
.bg-orange      { background: linear-gradient(135deg, #7c2d12, #c2410c) !important; }

/* ── Sliders ── */
.irs--shiny .irs-bar,
.irs--shiny .irs-bar-edge {
  background: var(--amber) !important;
  border-color: var(--amber) !important;
}

.irs--shiny .irs-handle {
  background: var(--amber) !important;
  border: 2px solid var(--amber-glow) !important;
  box-shadow: 0 0 10px rgba(245,158,11,0.5) !important;
}

.irs--shiny .irs-from,
.irs--shiny .irs-to,
.irs--shiny .irs-single {
  background: var(--amber) !important;
  color: #0a0e1a !important;
  font-weight: 700 !important;
  font-size: 11px !important;
  font-family: 'Syne', sans-serif !important;
}

.irs--shiny .irs-line { background: var(--navy-border) !important; }

/* ── Checkboxes ── */
.checkbox input[type='checkbox']:checked + label::before,
.shiny-input-checkboxgroup .checkbox input[type='checkbox']:checked + label::before {
  background: var(--amber) !important;
  border-color: var(--amber) !important;
}

label, .control-label {
  color: var(--text-secondary) !important;
  font-size: 12px !important;
  font-weight: 500 !important;
  letter-spacing: 0.05em !important;
  text-transform: uppercase !important;
  font-family: 'DM Sans', sans-serif !important;
}

/* ── DataTables ── */
.dataTables_wrapper,
.dataTables_wrapper .dataTables_length,
.dataTables_wrapper .dataTables_filter,
.dataTables_wrapper .dataTables_info,
.dataTables_wrapper .dataTables_paginate {
  color: var(--text-secondary) !important;
  font-size: 12px !important;
}

table.dataTable thead th {
  background: var(--navy-mid) !important;
  color: var(--amber) !important;
  border-bottom: 1px solid var(--navy-border) !important;
  font-family: 'Syne', sans-serif !important;
  font-size: 11px !important;
  letter-spacing: 0.1em !important;
  text-transform: uppercase !important;
  font-weight: 700 !important;
  padding: 12px 10px !important;
}

table.dataTable tbody tr {
  background: transparent !important;
  border-bottom: 1px solid var(--navy-border) !important;
  transition: background 0.15s ease !important;
}

table.dataTable tbody tr:hover { background: rgba(245,158,11,0.05) !important; }

table.dataTable tbody td {
  color: var(--text-primary) !important;
  font-size: 13px !important;
  padding: 10px !important;
  border-top: none !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button {
  color: var(--text-secondary) !important;
  border-radius: 6px !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button.current,
.dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
  background: var(--amber) !important;
  color: #0a0e1a !important;
  border: 1px solid var(--amber) !important;
  font-weight: 700 !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
  background: rgba(245,158,11,0.1) !important;
  color: var(--amber) !important;
  border: 1px solid transparent !important;
}

.dataTables_wrapper select,
.dataTables_wrapper input[type='search'] {
  background: var(--navy-mid) !important;
  color: var(--text-primary) !important;
  border: 1px solid var(--navy-border) !important;
  border-radius: 6px !important;
  padding: 4px 8px !important;
}

/* ── Summary Stats HTML ── */
.box-body h4 {
  font-family: 'Syne', sans-serif !important;
  font-size: 13px !important;
  font-weight: 700 !important;
  letter-spacing: 0.1em !important;
  text-transform: uppercase !important;
  color: var(--amber) !important;
  margin-bottom: 16px !important;
  padding-bottom: 8px !important;
  border-bottom: 1px solid var(--navy-border) !important;
}

.box-body p {
  font-size: 13px !important;
  color: var(--text-secondary) !important;
  margin-bottom: 8px !important;
  line-height: 1.6 !important;
}

.box-body p strong { color: var(--text-primary) !important; font-weight: 600 !important; }

.box-body table { width: 100% !important; border-collapse: collapse !important; }

.box-body table tr th {
  background: var(--navy-mid) !important;
  color: var(--amber) !important;
  font-family: 'Syne', sans-serif !important;
  font-size: 11px !important;
  letter-spacing: 0.08em !important;
  text-transform: uppercase !important;
  padding: 10px 12px !important;
  text-align: left !important;
}

.box-body table tr td {
  color: var(--text-secondary) !important;
  padding: 9px 12px !important;
  font-size: 13px !important;
  border-bottom: 1px solid var(--navy-border) !important;
}

.box-body table tr:hover td { background: rgba(245,158,11,0.04) !important; }

/* ── Scrollbar ── */
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: var(--navy-mid); }
::-webkit-scrollbar-thumb { background: var(--navy-border); border-radius: 3px; }
::-webkit-scrollbar-thumb:hover { background: var(--amber); }

/* ── Page load fade ── */
.content-wrapper { animation: fadeIn 0.5s ease; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

.tab-pane .row:first-child .box { position: relative; }
"

# ── Plotly dark theme ──────────────────────────────────────────────────────
plotly_theme <- function(p) {
  p %>% layout(
    paper_bgcolor = "rgba(0,0,0,0)",
    plot_bgcolor  = "rgba(0,0,0,0)",
    font  = list(family = "DM Sans, sans-serif", color = "#94a3b8", size = 12),
    title = list(font = list(family = "Syne, sans-serif", color = "#e2e8f0", size = 15)),
    xaxis = list(
      gridcolor     = "#1e2d47",
      zerolinecolor = "#1e2d47",
      tickfont      = list(color = "#94a3b8", size = 11),
      titlefont     = list(color = "#cbd5e1", size = 12)
    ),
    yaxis = list(
      gridcolor     = "#1e2d47",
      zerolinecolor = "#1e2d47",
      tickfont      = list(color = "#94a3b8", size = 11),
      titlefont     = list(color = "#cbd5e1", size = 12)
    ),
    legend = list(
      bgcolor     = "rgba(17,24,39,0.9)",
      bordercolor = "#1e2d47",
      borderwidth = 1,
      font        = list(color = "#94a3b8", size = 11)
    ),
    hoverlabel = list(
      bgcolor     = "#0a0e1a",
      bordercolor = "#f59e0b",
      font        = list(family = "DM Sans", color = "#e2e8f0", size = 12)
    ),
    margin = list(t = 40, r = 20, b = 40, l = 60)
  )
}

# ── UI ──────────────────────────────────────────────────────────────────────
ui <- dashboardPage(
  skin = "black",
  
  dashboardHeader(title = tags$span(
    "UK DEMOGRAPHICS",
    style = "font-family:'Syne',sans-serif; font-weight:800; letter-spacing:0.08em;"
  )),
  
  dashboardSidebar(
    tags$head(
      tags$style(HTML(custom_css)),
      tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
      tags$link(rel = "preconnect", href = "https://fonts.gstatic.com"),
      tags$link(
        href = "https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap",
        rel  = "stylesheet"
      )
    ),
    sidebarMenu(
      menuItem("Population Pyramid",     tabName = "pyramid",        icon = icon("users")),
      menuItem("Death Rates",            tabName = "death_rates",    icon = icon("chart-line")),
      menuItem("Fertility Rate",         tabName = "fertility",      icon = icon("baby")),
      menuItem("Age-Specific Fertility", tabName = "asfr",           icon = icon("venus")),
      menuItem("Life Expectancy",        tabName = "life_expectancy",icon = icon("heartbeat")),
      menuItem("Aged 65+",               tabName = "aged65",         icon = icon("user-clock")),
      menuItem("Maternity Deaths",       tabName = "maternity",      icon = icon("heart")),
      menuItem("Leading Causes",         tabName = "lead_causes",    icon = icon("skull-crossbones")),
      menuItem("Smoking & Health",       tabName = "smoking",        icon = icon("smoking")),
      menuItem("Obesity & Activity",     tabName = "obesity",        icon = icon("weight")),
      menuItem("Combined Analysis",      tabName = "combined",       icon = icon("th-large")),
      menuItem("Data Tables",            tabName = "data",           icon = icon("table"))
    )
  ),
  
  dashboardBody(
    tabItems(
      
      # ── Population Pyramid ────────────────────────────────────────────────
      tabItem(tabName = "pyramid",
              fluidRow(
                box(title = "Pyramid Controls", status = "primary", solidHeader = TRUE, width = 12,
                    fluidRow(
                      column(8, sliderInput("age_range", "Age Range",
                                            min = 0, max = 100, value = c(0, 100), step = 5)),
                      column(4, checkboxInput("show_percentages", "Show as Percentage of Population", value = TRUE))
                    )
                )
              ),
              fluidRow(
                box(title = "United Kingdom — 2025 Population Pyramid",
                    status = "info", solidHeader = TRUE, width = 12,
                    plotlyOutput("pyramid_plot", height = "580px"))
              ),
              fluidRow(
                valueBoxOutput("total_pop_box"),
                valueBoxOutput("male_pop_box"),
                valueBoxOutput("female_pop_box")
              )
      ),
      
      # ── Death Rates ───────────────────────────────────────────────────────
      tabItem(tabName = "death_rates",
              fluidRow(
                box(title = "Time Period", status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("year_range", "Year Range",
                                min = 1960, max = 2024, value = c(1960, 2024), step = 1, sep = ""))
              ),
              fluidRow(
                box(title = "Crude Death Rate",  status = "warning", solidHeader = TRUE, width = 12,
                    plotlyOutput("crude_rate_plot", height = "380px"))
              ),
              
              fluidRow(
                box(title = "Infant Mortality Rate",
                    status = "info", solidHeader = TRUE, width = 12,
                    plotlyOutput("infant_mortality_plot", height = "400px"))
              ),
              fluidRow(
                valueBoxOutput("infant_current_box"),
                valueBoxOutput("infant_max_box"),
                valueBoxOutput("infant_min_box")
              )
      ),
      
      # ── Fertility Rate ────────────────────────────────────────────────────
      tabItem(tabName = "fertility",
              fluidRow(
                box(title = "Time Period", status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("fertility_year_range", "Year Range",
                                min = 1960, max = 2024, value = c(1960, 2024), step = 1, sep = ""))
              ),
              fluidRow(
                box(title = "UK Total Fertility Rate Over Time",
                    status = "info", solidHeader = TRUE, width = 12,
                    plotlyOutput("fertility_rate_plot", height = "460px"))
              ),
              fluidRow(
                valueBoxOutput("current_fertility_box"),
                valueBoxOutput("max_fertility_box"),
                valueBoxOutput("min_fertility_box")
              ),
              fluidRow(
                box(title = "Period Statistics", status = "primary", solidHeader = TRUE, width = 12,
                    htmlOutput("fertility_summary"))
              )
      ),
      
      # ── ASFR ──────────────────────────────────────────────────────────────
      tabItem(tabName = "asfr",
              fluidRow(
                box(title = "Controls", status = "primary", solidHeader = TRUE, width = 12,
                    fluidRow(
                      column(6, sliderInput("asfr_year_range", "Year Range",
                                            min = 1960, max = 2024, value = c(1960, 2024), step = 1, sep = "")),
                      column(6, checkboxGroupInput("asfr_age_groups", "Age Groups",
                                                   choices  = c("Under 20","20 to 24","25 to 29","30 to 34","35 to 39","40 and over"),
                                                   selected = c("Under 20","20 to 24","25 to 29","30 to 34","35 to 39","40 and over"),
                                                   inline   = TRUE))
                    )
                )
              ),
              fluidRow(
                box(title = "Age-Specific Fertility Rates Over Time",
                    status = "warning", solidHeader = TRUE, width = 12,
                    plotlyOutput("asfr_plot", height = "500px"))
              ),
              fluidRow(
                box(title = "ASFR Summary Statistics",
                    status = "warning", solidHeader = TRUE, width = 12,
                    htmlOutput("asfr_summary"))
              )
      ),
      
      # ── Life Expectancy ───────────────────────────────────────────────────
      tabItem(tabName = "life_expectancy",
              fluidRow(
                box(title = "Time Period", status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("life_exp_year_range", "Year Range",
                                min = 1960, max = 2024, value = c(1960, 2024), step = 1, sep = ""))
              ),
              fluidRow(
                box(title = "UK Life Expectancy at Birth",
                    status = "success", solidHeader = TRUE, width = 12,
                    plotlyOutput("life_expectancy_plot", height = "460px"))
              ),
              fluidRow(
                valueBoxOutput("current_life_exp_box"),
                valueBoxOutput("max_life_exp_box"),
                valueBoxOutput("min_life_exp_box")
              ),
              fluidRow(
                box(title = "Period Statistics", status = "success", solidHeader = TRUE, width = 12,
                    htmlOutput("life_exp_summary"))
              )
      ),
      
      # ── Aged 65+ ──────────────────────────────────────────────────────────
      tabItem(tabName = "aged65",
              fluidRow(
                box(title = "Time Period", status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("aged65_year_range", "Year Range",
                                min = 1960, max = 2024, value = c(1960, 2024), step = 1, sep = ""))
              ),
              fluidRow(
                box(title = "UK Population Aged 65 & Over",
                    status = "info", solidHeader = TRUE, width = 12,
                    plotlyOutput("aged65_plot", height = "460px"))
              ),
              fluidRow(
                valueBoxOutput("current_aged65_box"),
                valueBoxOutput("max_aged65_box"),
                valueBoxOutput("min_aged65_box")
              ),
              fluidRow(
                box(title = "Period Statistics", status = "info", solidHeader = TRUE, width = 12,
                    htmlOutput("aged65_summary"))
              )
      ),
      
      # ── Maternity Deaths ──────────────────────────────────────────────────
      tabItem(tabName = "maternity",
              fluidRow(
                box(title = "UK Maternity Death Rate Over Time",
                    status = "danger", solidHeader = TRUE, width = 12,
                    plotlyOutput("maternity_plot", height = "480px"))
              ),
              fluidRow(
                valueBoxOutput("maternity_total_periods_box"),
                valueBoxOutput("maternity_causes_box"),
                valueBoxOutput("maternity_peak_box")
              ),
              fluidRow(
                box(title = "Summary Statistics by Cause",
                    status = "warning", solidHeader = TRUE, width = 12,
                    htmlOutput("maternity_summary"))
              )
      ),
      
      # ── Leading Causes of Death ───────────────────────────────────────────
      tabItem(tabName = "lead_causes",
              fluidRow(
                box(title = "Leading Causes of Male Deaths",
                    status = "info", solidHeader = TRUE, width = 6,
                    plotlyOutput("lead_male_plot", height = "500px")),
                box(title = "Leading Causes of Female Deaths",
                    status = "success", solidHeader = TRUE, width = 6,
                    plotlyOutput("lead_female_plot", height = "500px"))
              ),
              fluidRow(
                box(title = "Side-by-Side Comparison",
                    status = "warning", solidHeader = TRUE, width = 12,
                    plotlyOutput("lead_combined_plot", height = "520px"))
              )
      ),
      
      # ── Smoking & Health Trends ───────────────────────────────────────────
      tabItem(tabName = "smoking",
              fluidRow(
                valueBoxOutput("smoking_prevalence_latest_box"),
                valueBoxOutput("smoking_deaths_latest_box"),
                valueBoxOutput("smoking_admissions_latest_box")
              ),
              fluidRow(
                box(
                  title       = "Smoking Prevalence in England (%)",
                  status      = "warning",
                  solidHeader = TRUE,
                  width       = 12,
                  tags$p("Smoking prevalence · Persons · 18 years and over",
                         style = "font-size:11px; color:#64748b; margin: -8px 0 12px 0;
                            letter-spacing:0.04em; font-style:italic;"),
                  plotlyOutput("smoking_prevalence_plot", height = "400px")
                )
              ),
              fluidRow(
                box(
                  title       = "Smoking-Attributable Deaths (per 100,000)",
                  status      = "danger",
                  solidHeader = TRUE,
                  width       = 6,
                  tags$p("Deaths attributable to smoking · Persons · 35 years and over",
                         style = "font-size:11px; color:#64748b; margin: -8px 0 12px 0;
                            letter-spacing:0.04em; font-style:italic;"),
                  plotlyOutput("smoking_deaths_plot", height = "380px")
                ),
                box(
                  title       = "Smoking-Attributable Hospital Admissions (per 100,000)",
                  status      = "info",
                  solidHeader = TRUE,
                  width       = 6,
                  tags$p("Hospital admissions attributable to smoking · Persons · 35 years and over",
                         style = "font-size:11px; color:#64748b; margin: -8px 0 12px 0;
                            letter-spacing:0.04em; font-style:italic;"),
                  plotlyOutput("smoking_admissions_plot", height = "380px")
                )
              ),
              fluidRow(
                box(
                  title       = "Smoking Health Trends — Summary Statistics",
                  status      = "primary",
                  solidHeader = TRUE,
                  width       = 12,
                  htmlOutput("smoking_summary")
                )
              )
      ),
      
      # ── Obesity & Physical Activity ───────────────────────────────────────
      tabItem(tabName = "obesity",
              fluidRow(
                valueBoxOutput("obesity_latest_box"),
                valueBoxOutput("inactive_latest_box"),
                valueBoxOutput("active_latest_box")
              ),
              fluidRow(
                box(
                  title       = "Obesity Prevalence in Adults — England (%)",
                  status      = "danger",
                  solidHeader = TRUE,
                  width       = 12,
                  tags$p("Obesity in adults · Persons · 16 years and over",
                         style = "font-size:11px; color:#64748b; margin: -8px 0 12px 0;
                            letter-spacing:0.04em; font-style:italic;"),
                  plotlyOutput("obesity_plot", height = "400px")
                )
              ),
              fluidRow(
                box(
                  title       = "Physically Inactive Adults (%)",
                  status      = "warning",
                  solidHeader = TRUE,
                  width       = 6,
                  tags$p("Physically inactive adults · Persons · 19 years and over",
                         style = "font-size:11px; color:#64748b; margin: -8px 0 12px 0;
                            letter-spacing:0.04em; font-style:italic;"),
                  plotlyOutput("inactive_plot", height = "360px")
                ),
                box(
                  title       = "Physically Active Adults (%)",
                  status      = "success",
                  solidHeader = TRUE,
                  width       = 6,
                  tags$p("Physically active adults · Persons · 19 years and over",
                         style = "font-size:11px; color:#64748b; margin: -8px 0 12px 0;
                            letter-spacing:0.04em; font-style:italic;"),
                  plotlyOutput("active_plot", height = "360px")
                )
              ),
              fluidRow(
                box(
                  title       = "Obesity & Physical Activity — Summary Statistics",
                  status      = "primary",
                  solidHeader = TRUE,
                  width       = 12,
                  htmlOutput("obesity_summary")
                )
              )
      ),
      
      # ── Combined Analysis ─────────────────────────────────────────────────
      tabItem(tabName = "combined",
              fluidRow(
                box(title = "Key Demographics at a Glance",
                    status = "primary", solidHeader = TRUE, width = 12,
                    htmlOutput("summary_stats"))
              ),
              fluidRow(
                box(title = "Age Distribution",    status = "info",    solidHeader = TRUE, width = 6,
                    plotlyOutput("age_distribution", height = "420px")),
                box(title = "Gender Ratio by Age", status = "warning", solidHeader = TRUE, width = 6,
                    plotlyOutput("gender_ratio_plot", height = "420px"))
              )
      ),
      
      # ── Data Tables ───────────────────────────────────────────────────────
      tabItem(tabName = "data",
              fluidRow(
                box(title = "Population by Age Group",
                    status = "primary", solidHeader = TRUE, width = 12,
                    DTOutput("population_table"))
              ),
              fluidRow(
                box(title = "Death Rate Statistics",
                    status = "warning", solidHeader = TRUE, width = 12,
                    DTOutput("death_rate_table"))
              ),
              fluidRow(
                box(title = "Infant Mortality Rate",
                    status = "danger", solidHeader = TRUE, width = 12,
                    DTOutput("infant_table"))
              ),
              fluidRow(
                box(title = "Total Fertility Rate",
                    status = "info", solidHeader = TRUE, width = 12,
                    DTOutput("fertility_table"))
              ),
              fluidRow(
                box(title = "Age-Specific Fertility Rates",
                    status = "warning", solidHeader = TRUE, width = 12,
                    DTOutput("asfr_table"))
              ),
              fluidRow(
                box(title = "Life Expectancy at Birth",
                    status = "success", solidHeader = TRUE, width = 12,
                    DTOutput("life_exp_table"))
              ),
              fluidRow(
                box(title = "Population Aged 65+",
                    status = "info", solidHeader = TRUE, width = 12,
                    DTOutput("aged65_table"))
              ),
              fluidRow(
                box(title = "Maternity Deaths",
                    status = "danger", solidHeader = TRUE, width = 12,
                    DTOutput("maternity_table"))
              ),
              fluidRow(
                box(title = "Leading Causes of Death",
                    status = "primary", solidHeader = TRUE, width = 12,
                    DTOutput("lead_causes_table"))
              ),
              fluidRow(
                box(title = "Smoking Prevalence",
                    status = "warning", solidHeader = TRUE, width = 12,
                    DTOutput("smoking_prev_table"))
              ),
              fluidRow(
                box(title = "Smoking-Attributable Deaths",
                    status = "danger", solidHeader = TRUE, width = 12,
                    DTOutput("smoking_deaths_table"))
              ),
              fluidRow(
                box(title = "Smoking-Attributable Hospital Admissions",
                    status = "info", solidHeader = TRUE, width = 12,
                    DTOutput("smoking_admissions_table"))
              ),
              fluidRow(
                box(title = "Adult Obesity Prevalence",
                    status = "danger", solidHeader = TRUE, width = 12,
                    DTOutput("obesity_table"))
              ),
              fluidRow(
                box(title = "Physically Inactive Adults",
                    status = "warning", solidHeader = TRUE, width = 12,
                    DTOutput("inactive_table"))
              ),
              fluidRow(
                box(title = "Physically Active Adults",
                    status = "success", solidHeader = TRUE, width = 12,
                    DTOutput("active_table"))
              )
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────────
server <- function(input, output, session) {
  
  # ── Data loaders ──────────────────────────────────────────────────────────
  pyramid_data <- reactive({
    read.csv("United Kingdom-2025.csv")
  })
  
  fertility_data <- reactive({
    data      <- read_excel("Fertility_rate_UK.xlsx")
    data$Year <- as.numeric(data$Year)
    data
  })
  
  life_expectancy_data <- reactive({
    data      <- read_excel("Life_expectancy_UK.xlsx")
    data$Year <- as.numeric(data$Year)
    data
  })
  
  asfr_data <- reactive({
    data      <- read_excel("ASFR.xlsx")
    data_long <- data %>%
      pivot_longer(cols = -Year, names_to = "Age_group", values_to = "Rate")
    data_long$Year <- as.numeric(data_long$Year)
    data_long
  })
  
  aged65_data <- reactive({
    data      <- read_excel("aged_over_65.xlsx")
    data$Year <- as.numeric(data$Year)
    data
  })
  
  lead_causes_data <- reactive({
    data <- read_excel("Leading_Causes.xlsx")
    data$`Leading Cause(Male)`   <- as.character(data$`Leading Cause(Male)`)
    data$`Leading Cause(Female)` <- as.character(data$`Leading Cause(Female)`)
    data$Percentage_M            <- as.numeric(data$Percentage_M)
    data$Percentage_F            <- as.numeric(data$Percentage_F)
    data$`Leading Cause(Male)`   <- reorder(data$`Leading Cause(Male)`,   data$Percentage_M)
    data$`Leading Cause(Female)` <- reorder(data$`Leading Cause(Female)`, data$Percentage_F)
    data
  })
  
  maternity_data <- reactive({
    read_excel("Maternity_deaths.xlsx")
  })
  
  infant_data <- reactive({
    data      <- read_excel("Infant_Mortality.xlsx")
    data$Year <- as.numeric(data$Year)
    data
  })
  
  death_rate_data <- reactive({
    crude     <- read_excel("Crude_death_rate_UK.xlsx")
    mortality <- read_excel("Mortality_rate_UK.xlsx")
    crude$Year     <- as.numeric(crude$Year)
    mortality$Year <- as.numeric(mortality$Year)
    left_join(crude, mortality, by = "Year")
  })
  
  filtered_death_rates <- reactive({
    death_rate_data() %>%
      filter(Year >= input$year_range[1], Year <= input$year_range[2])
  })
  
  # ── Smoking data loaders ──────────────────────────────────────────────────
  smoking_prevalence_data <- reactive({
    data <- read.csv("smoking-prevalence-chart-data.csv", check.names = FALSE)
    colnames(data) <- c("Period", "Value", "CI_Lower", "CI_Upper")
    data$Value    <- as.numeric(data$Value)
    data$CI_Lower <- as.numeric(data$CI_Lower)
    data$CI_Upper <- as.numeric(data$CI_Upper)
    data$Year     <- as.numeric(data$Period)
    data          <- data[order(data$Year), ]
    data
  })
  
  smoking_deaths_data <- reactive({
    data <- read.csv("deaths-attributable-to-smoking-chart-data.csv", check.names = FALSE)
    colnames(data) <- c("Period", "Value", "CI_Lower", "CI_Upper")
    data$Value    <- as.numeric(gsub(",", "", data$Value))
    data$CI_Lower <- as.numeric(gsub(",", "", data$CI_Lower))
    data$CI_Upper <- as.numeric(gsub(",", "", data$CI_Upper))
    data
  })
  
  smoking_admissions_data <- reactive({
    data <- read.csv("hospital-admissions-attributable-to-smoking-chart-data.csv", check.names = FALSE)
    colnames(data) <- c("Period", "Value", "CI_Lower", "CI_Upper")
    data$Value    <- as.numeric(gsub(",", "", data$Value))
    data$CI_Lower <- as.numeric(gsub(",", "", data$CI_Lower))
    data$CI_Upper <- as.numeric(gsub(",", "", data$CI_Upper))
    data
  })
  
  # ── Obesity data loaders ──────────────────────────────────────────────────
  obesity_data <- reactive({
    data <- read.csv("obesity-in-adults-chart-data.csv", check.names = FALSE)
    colnames(data) <- c("Period", "Value", "CI_Lower", "CI_Upper")
    data$Year     <- as.numeric(data$Period)
    data$Value    <- suppressWarnings(as.numeric(data$Value))
    data$CI_Lower <- suppressWarnings(as.numeric(data$CI_Lower))
    data$CI_Upper <- suppressWarnings(as.numeric(data$CI_Upper))
    data[!is.na(data$Value), ]
  })
  
  inactive_data <- reactive({
    data <- read.csv("physically-inactive-adults-chart-data.csv", check.names = FALSE)
    colnames(data) <- c("Period", "Value", "CI_Lower", "CI_Upper")
    data$Value    <- suppressWarnings(as.numeric(data$Value))
    data$CI_Lower <- suppressWarnings(as.numeric(data$CI_Lower))
    data$CI_Upper <- suppressWarnings(as.numeric(data$CI_Upper))
    data[!is.na(data$Value), ]
  })
  
  active_data <- reactive({
    data <- read.csv("physically-active-adults-chart-data.csv", check.names = FALSE)
    colnames(data) <- c("Period", "Value", "CI_Lower", "CI_Upper")
    data$Value    <- suppressWarnings(as.numeric(data$Value))
    data$CI_Lower <- suppressWarnings(as.numeric(data$CI_Lower))
    data$CI_Upper <- suppressWarnings(as.numeric(data$CI_Upper))
    data[!is.na(data$Value), ]
  })
  
  # ── Filtered reactives ────────────────────────────────────────────────────
  filtered_pyramid <- reactive({
    pyramid_data() %>%
      filter(Age >= input$age_range[1], Age <= input$age_range[2]) %>%
      mutate(
        total_pop    = sum(M) + sum(F),
        Male_pct     = (M / total_pop) * 100,
        Female_pct   = (F / total_pop) * 100,
        Male_pct_neg = -Male_pct,
        Agegroup     = factor(Age, levels = Age)
      )
  })
  
  filtered_fertility <- reactive({
    fertility_data() %>%
      filter(Year >= input$fertility_year_range[1], Year <= input$fertility_year_range[2])
  })
  
  filtered_life_expectancy <- reactive({
    life_expectancy_data() %>%
      filter(Year >= input$life_exp_year_range[1], Year <= input$life_exp_year_range[2])
  })
  
  filtered_asfr <- reactive({
    asfr_data() %>%
      filter(Year >= input$asfr_year_range[1], Year <= input$asfr_year_range[2]) %>%
      filter(Age_group %in% input$asfr_age_groups)
  })
  
  filtered_aged65 <- reactive({
    aged65_data() %>%
      filter(Year >= input$aged65_year_range[1], Year <= input$aged65_year_range[2])
  })
  
  filtered_infant <- reactive({
    infant_data() %>%
      filter(Year >= input$year_range[1], Year <= input$year_range[2])
  })
  
  # ── Plots ─────────────────────────────────────────────────────────────────
  
  output$pyramid_plot <- renderPlotly({
    data <- filtered_pyramid()
    p <- ggplot(data, aes(x = Agegroup)) +
      geom_col(aes(y = Male_pct_neg, fill = "Male"),   width = 0.85) +
      geom_col(aes(y = Female_pct,   fill = "Female"), width = 0.85) +
      coord_flip() +
      scale_y_continuous(labels = abs, limits = c(-10, 10), breaks = seq(-10, 10, by = 2)) +
      scale_fill_manual(values = c("Male" = "#38bdf8", "Female" = "#f472b6")) +
      labs(x = "Age Group", y = "% of Total Population", fill = "") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background    = element_rect(fill = "transparent", colour = NA),
        panel.background   = element_rect(fill = "transparent", colour = NA),
        panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text          = element_text(colour = "#94a3b8", size = 9),
        axis.title         = element_text(colour = "#cbd5e1", size = 10),
        legend.text        = element_text(colour = "#94a3b8"),
        legend.background  = element_rect(fill = "transparent", colour = NA)
      )
    ggplotly(p, tooltip = c("y", "fill")) %>% plotly_theme()
  })
  
  output$crude_rate_plot <- renderPlotly({
    data <- filtered_death_rates()
    p <- ggplot(data, aes(x = Year, y = `Crude Death Rate`)) +
      geom_ribbon(aes(ymin = min(`Crude Death Rate`, na.rm = TRUE) * 0.98, ymax = `Crude Death Rate`),
                  fill = "#f59e0b", alpha = 0.10) +
      geom_line(colour = "#f59e0b", linewidth = 1.1) +
      geom_point(colour = "#fbbf24", size = 2.5) +
      scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
      coord_cartesian(ylim = c(min(data$`Crude Death Rate`, na.rm = TRUE) * 0.97,
                               max(data$`Crude Death Rate`, na.rm = TRUE) * 1.03)) +
      labs(x = "Year", y = "Crude Death Rate (per 1,000)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$mortality_rate_plot <- renderPlotly({
    data <- filtered_death_rates()
    p <- ggplot(data, aes(x = Year, y = Mortality_Rate)) +
      geom_ribbon(aes(ymin = min(Mortality_Rate, na.rm = TRUE) * 0.98, ymax = Mortality_Rate),
                  fill = "#f43f5e", alpha = 0.10) +
      geom_line(colour = "#f43f5e", linewidth = 1.1) +
      geom_point(colour = "#fb7185", size = 2.5) +
      scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
      coord_cartesian(ylim = c(min(data$Mortality_Rate, na.rm = TRUE) * 0.97,
                               max(data$Mortality_Rate, na.rm = TRUE) * 1.03)) +
      labs(x = "Year", y = "Mortality Rate (per 1,000)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$combined_rates_plot <- renderPlotly({
    data <- filtered_death_rates() %>%
      pivot_longer(cols = c(`Crude Death Rate`, Mortality_Rate),
                   names_to = "Rate_Type", values_to = "Rate")
    p <- ggplot(data, aes(x = Year, y = Rate, colour = Rate_Type)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 2) +
      scale_colour_manual(
        values = c("Crude Death Rate" = "#f59e0b", "Mortality_Rate" = "#f43f5e"),
        labels = c("Crude Death Rate" = "Crude Death Rate", "Mortality_Rate" = "Mortality Rate")
      ) +
      scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
      coord_cartesian(ylim = c(min(data$Rate, na.rm = TRUE) * 0.97,
                               max(data$Rate, na.rm = TRUE) * 1.03)) +
      labs(x = "Year", y = "Rate (per 1,000)", colour = "") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background   = element_rect(fill = "transparent", colour = NA),
        panel.background  = element_rect(fill = "transparent", colour = NA),
        panel.grid        = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text         = element_text(colour = "#94a3b8"),
        axis.title        = element_text(colour = "#cbd5e1"),
        legend.background = element_rect(fill = "transparent", colour = NA),
        legend.text       = element_text(colour = "#94a3b8")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$infant_mortality_plot <- renderPlotly({
    data <- filtered_infant()
    p <- ggplot(data, aes(x = Year, y = `Rate per 1000 live births`)) +
      geom_ribbon(aes(ymin = min(`Rate per 1000 live births`, na.rm = TRUE) * 0.97,
                      ymax = `Rate per 1000 live births`),
                  fill = "#8b5cf6", alpha = 0.12) +
      geom_line(colour = "#8b5cf6", linewidth = 1.2) +
      geom_point(colour = "#a78bfa", size = 2.5) +
      scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
      coord_cartesian(ylim = c(min(data$`Rate per 1000 live births`, na.rm = TRUE) * 0.97,
                               max(data$`Rate per 1000 live births`, na.rm = TRUE) * 1.03)) +
      labs(x = "Year", y = "Rate per 1,000 Live Births") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$age_distribution <- renderPlotly({
    data <- filtered_pyramid() %>% mutate(Total = M + F)
    p <- ggplot(data, aes(x = Agegroup, y = Total)) +
      geom_col(fill = "#14b8a6", alpha = 0.85) +
      coord_flip() +
      labs(x = "Age Group", y = "Total Population") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background    = element_rect(fill = "transparent", colour = NA),
        panel.background   = element_rect(fill = "transparent", colour = NA),
        panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text          = element_text(colour = "#94a3b8"),
        axis.title         = element_text(colour = "#cbd5e1")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$gender_ratio_plot <- renderPlotly({
    data <- filtered_pyramid() %>% mutate(Gender_Ratio = (F / M) * 100)
    p <- ggplot(data, aes(x = Agegroup, y = Gender_Ratio)) +
      geom_line(group = 1, colour = "#8b5cf6", linewidth = 1.1) +
      geom_point(colour = "#a78bfa", size = 3) +
      geom_hline(yintercept = 100, linetype = "dashed", colour = "#4b5563") +
      coord_flip() +
      labs(x = "Age Group", y = "Females per 100 Males") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$fertility_rate_plot <- renderPlotly({
    data <- filtered_fertility()
    p <- ggplot(data, aes(x = Year, y = Fertility_rate)) +
      geom_ribbon(aes(ymin = min(Fertility_rate, na.rm = TRUE) * 0.98, ymax = Fertility_rate),
                  fill = "#14b8a6", alpha = 0.10) +
      geom_line(colour = "#14b8a6", linewidth = 1.2) +
      geom_point(colour = "#5eead4", size = 2.5) +
      scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
      coord_cartesian(ylim = c(min(data$Fertility_rate, na.rm = TRUE) * 0.97,
                               max(data$Fertility_rate, na.rm = TRUE) * 1.03)) +
      labs(x = "Year", y = "Births per Woman") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$life_expectancy_plot <- renderPlotly({
    data <- filtered_life_expectancy()
    p <- ggplot(data, aes(x = Year, y = Life_expectancy_at_Birth)) +
      geom_ribbon(aes(ymin = min(Life_expectancy_at_Birth, na.rm = TRUE) * 0.998,
                      ymax = Life_expectancy_at_Birth),
                  fill = "#22c55e", alpha = 0.10) +
      geom_line(colour = "#22c55e", linewidth = 1.2) +
      geom_point(colour = "#4ade80", size = 2.5) +
      scale_y_continuous(expand = expansion(mult = c(0.05, 0.08))) +
      coord_cartesian(ylim = c(min(data$Life_expectancy_at_Birth, na.rm = TRUE) * 0.99,
                               max(data$Life_expectancy_at_Birth, na.rm = TRUE) * 1.01)) +
      labs(x = "Year", y = "Life Expectancy (years)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$asfr_plot <- renderPlotly({
    data <- filtered_asfr()
    if (nrow(data) == 0) return(NULL)
    
    palette <- c(
      "Under 20"    = "#38bdf8",
      "20 to 24"    = "#14b8a6",
      "25 to 29"    = "#f59e0b",
      "30 to 34"    = "#f43f5e",
      "35 to 39"    = "#8b5cf6",
      "40 and over" = "#6b7280"
    )
    
    p <- ggplot(data, aes(x = Year, y = Rate, colour = Age_group)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 1.8) +
      scale_colour_manual(values = palette) +
      scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
      coord_cartesian(ylim = c(max(0, min(data$Rate, na.rm = TRUE) * 0.92),
                               max(data$Rate, na.rm = TRUE) * 1.05)) +
      labs(x = "Year", y = "Age-Specific Fertility Rate", colour = "Age Group") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background   = element_rect(fill = "transparent", colour = NA),
        panel.background  = element_rect(fill = "transparent", colour = NA),
        panel.grid        = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text         = element_text(colour = "#94a3b8"),
        axis.title        = element_text(colour = "#cbd5e1"),
        legend.background = element_rect(fill = "transparent", colour = NA),
        legend.text       = element_text(colour = "#94a3b8")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$aged65_plot <- renderPlotly({
    data <- filtered_aged65()
    p <- ggplot(data, aes(x = Year, y = Percentage)) +
      geom_ribbon(aes(ymin = min(Percentage, na.rm = TRUE) * 0.97, ymax = Percentage),
                  fill = "#38bdf8", alpha = 0.12) +
      geom_line(colour = "#38bdf8", linewidth = 1.2) +
      geom_point(colour = "#7dd3fc", size = 2.5) +
      scale_y_continuous(expand = expansion(mult = c(0.05, 0.10))) +
      coord_cartesian(ylim = c(min(data$Percentage, na.rm = TRUE) * 0.97,
                               max(data$Percentage, na.rm = TRUE) * 1.03)) +
      labs(x = "Year", y = "Population Aged 65+ (%)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p) %>% plotly_theme()
  })
  
  output$maternity_plot <- renderPlotly({
    data <- maternity_data()
    
    palette <- c(
      "#f43f5e", "#f59e0b", "#14b8a6", "#8b5cf6",
      "#38bdf8", "#4ade80", "#fb923c", "#e879f9",
      "#a3e635", "#67e8f9", "#fda4af", "#c4b5fd"
    )
    
    p <- ggplot(data, aes(x = Period, y = `Rate/100,000`, colour = Death, group = Death)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 3) +
      scale_colour_manual(values = palette) +
      scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
      labs(x = "3-Year Time Period", y = "Rate per 100,000 Maternities", colour = "Cause of Death") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background   = element_rect(fill = "transparent", colour = NA),
        panel.background  = element_rect(fill = "transparent", colour = NA),
        panel.grid        = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text.x       = element_text(colour = "#94a3b8", angle = 35, hjust = 1, size = 9),
        axis.text.y       = element_text(colour = "#94a3b8"),
        axis.title        = element_text(colour = "#cbd5e1"),
        legend.background = element_rect(fill = "transparent", colour = NA),
        legend.text       = element_text(colour = "#94a3b8")
      )
    
    ggplotly(p, tooltip = c("x", "y", "colour")) %>% plotly_theme()
  })
  
  output$lead_male_plot <- renderPlotly({
    data <- lead_causes_data()
    p <- ggplot(data, aes(x = `Leading Cause(Male)`, y = Percentage_M)) +
      geom_col(aes(fill = Percentage_M,
                   text = paste0("<b>", `Leading Cause(Male)`, "</b><br>",
                                 round(Percentage_M, 1), "% of male deaths")),
               width = 0.38, alpha = 0.90) +
      geom_point(inherit.aes = FALSE,
                 aes(x = `Leading Cause(Male)`, y = Percentage_M),
                 colour = "#7dd3fc", size = 2.8) +
      geom_text(inherit.aes = FALSE,
                aes(x = `Leading Cause(Male)`, y = Percentage_M,
                    label = paste0(round(Percentage_M, 1), "%")),
                hjust = -0.25, colour = "#cbd5e1", size = 3.4) +
      coord_flip() +
      scale_fill_gradient(low = "#0369a1", high = "#38bdf8", guide = "none") +
      scale_y_continuous(expand = expansion(mult = c(0, 0.22)),
                         labels = function(x) paste0(x, "%")) +
      labs(x = NULL, y = "Percentage of Male Deaths (%)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background    = element_rect(fill = "transparent", colour = NA),
        panel.background   = element_rect(fill = "transparent", colour = NA),
        panel.grid.major.y = element_blank(),
        panel.grid.minor   = element_blank(),
        panel.grid.major.x = element_line(colour = "#1e2d47", linewidth = 0.35, linetype = "dotted"),
        axis.text.y        = element_text(colour = "#e2e8f0", size = 9.5),
        axis.text.x        = element_text(colour = "#64748b", size = 8.5),
        axis.title.x       = element_text(colour = "#94a3b8", size = 10),
        plot.margin        = margin(10, 20, 10, 10)
      )
    ggplotly(p, tooltip = "text") %>%
      plotly_theme() %>%
      layout(margin = list(l = 10, r = 30, t = 20, b = 40))
  })
  
  output$lead_female_plot <- renderPlotly({
    data <- lead_causes_data()
    p <- ggplot(data, aes(x = `Leading Cause(Female)`, y = Percentage_F)) +
      geom_col(aes(fill = Percentage_F,
                   text = paste0("<b>", `Leading Cause(Female)`, "</b><br>",
                                 round(Percentage_F, 1), "% of female deaths")),
               width = 0.38, alpha = 0.90) +
      geom_point(inherit.aes = FALSE,
                 aes(x = `Leading Cause(Female)`, y = Percentage_F),
                 colour = "#86efac", size = 2.8) +
      geom_text(inherit.aes = FALSE,
                aes(x = `Leading Cause(Female)`, y = Percentage_F,
                    label = paste0(round(Percentage_F, 1), "%")),
                hjust = -0.25, colour = "#cbd5e1", size = 3.4) +
      coord_flip() +
      scale_fill_gradient(low = "#065f46", high = "#4ade80", guide = "none") +
      scale_y_continuous(expand = expansion(mult = c(0, 0.22)),
                         labels = function(x) paste0(x, "%")) +
      labs(x = NULL, y = "Percentage of Female Deaths (%)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background    = element_rect(fill = "transparent", colour = NA),
        panel.background   = element_rect(fill = "transparent", colour = NA),
        panel.grid.major.y = element_blank(),
        panel.grid.minor   = element_blank(),
        panel.grid.major.x = element_line(colour = "#1e2d47", linewidth = 0.35, linetype = "dotted"),
        axis.text.y        = element_text(colour = "#e2e8f0", size = 9.5),
        axis.text.x        = element_text(colour = "#64748b", size = 8.5),
        axis.title.x       = element_text(colour = "#94a3b8", size = 10),
        plot.margin        = margin(10, 20, 10, 10)
      )
    ggplotly(p, tooltip = "text") %>%
      plotly_theme() %>%
      layout(margin = list(l = 10, r = 30, t = 20, b = 40))
  })
  
  output$lead_combined_plot <- renderPlotly({
    data <- lead_causes_data()
    
    long <- data %>%
      transmute(
        Cause_M = as.character(`Leading Cause(Male)`),
        Cause_F = as.character(`Leading Cause(Female)`),
        Percentage_M,
        Percentage_F
      ) %>%
      pivot_longer(cols = c(Percentage_M, Percentage_F),
                   names_to = "Gender", values_to = "Percentage") %>%
      mutate(
        Cause  = ifelse(Gender == "Percentage_M", Cause_M, Cause_F),
        Gender = ifelse(Gender == "Percentage_M", "Male", "Female")
      )
    
    p <- ggplot(long, aes(x = reorder(Cause, Percentage), y = Percentage, fill = Gender)) +
      geom_col(aes(text = paste0("<b>", Cause, "</b>  (", Gender, ")<br>",
                                 round(Percentage, 1), "% of deaths")),
               position = position_dodge(0.6), width = 0.38, alpha = 0.90) +
      coord_flip() +
      scale_fill_manual(values = c("Male" = "#38bdf8", "Female" = "#4ade80")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.12)),
                         labels = function(x) paste0(x, "%")) +
      labs(x = NULL, y = "Percentage of Deaths (%)", fill = "") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background    = element_rect(fill = "transparent", colour = NA),
        panel.background   = element_rect(fill = "transparent", colour = NA),
        panel.grid.major.y = element_blank(),
        panel.grid.minor   = element_blank(),
        panel.grid.major.x = element_line(colour = "#1e2d47", linewidth = 0.35, linetype = "dotted"),
        axis.text.y        = element_text(colour = "#e2e8f0", size = 9.5),
        axis.text.x        = element_text(colour = "#64748b", size = 8.5),
        axis.title.x       = element_text(colour = "#94a3b8", size = 10),
        legend.background  = element_rect(fill = "transparent", colour = NA),
        legend.text        = element_text(colour = "#94a3b8", size = 10),
        legend.position    = "top",
        plot.margin        = margin(10, 20, 10, 10)
      )
    ggplotly(p, tooltip = "text") %>%
      plotly_theme() %>%
      layout(margin = list(l = 10, r = 30, t = 30, b = 40))
  })
  
  # ── Smoking plots ─────────────────────────────────────────────────────────
  
  output$smoking_prevalence_plot <- renderPlotly({
    data <- smoking_prevalence_data()
    p <- ggplot(data, aes(x = Year, y = Value)) +
      geom_ribbon(aes(ymin = CI_Lower, ymax = CI_Upper),
                  fill = "#f59e0b", alpha = 0.15) +
      geom_line(colour = "#f59e0b", linewidth = 1.3) +
      geom_point(aes(
        text = paste0("<b>", Period, "</b><br>",
                      "Prevalence: ", Value, "%<br>",
                      "95% CI: ", CI_Lower, "% – ", CI_Upper, "%")
      ), colour = "#fbbf24", size = 3) +
      scale_y_continuous(
        expand = expansion(mult = c(0.05, 0.10)),
        labels = function(x) paste0(x, "%")
      ) +
      coord_cartesian(ylim = c(max(0, min(data$CI_Lower, na.rm = TRUE) - 0.5),
                               max(data$CI_Upper, na.rm = TRUE) + 0.5)) +
      labs(x = "Year", y = "Adult Smoking Prevalence (%)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p, tooltip = "text") %>% plotly_theme()
  })
  
  output$smoking_deaths_plot <- renderPlotly({
    data <- smoking_deaths_data()
    p <- ggplot(data, aes(x = Period, y = Value, group = 1)) +
      geom_ribbon(aes(ymin = CI_Lower, ymax = CI_Upper),
                  fill = "#f43f5e", alpha = 0.15) +
      geom_line(colour = "#f43f5e", linewidth = 1.3) +
      geom_point(aes(
        text = paste0("<b>", Period, "</b><br>",
                      "Deaths: ", Value, " per 100,000<br>",
                      "95% CI: ", CI_Lower, " – ", CI_Upper)
      ), colour = "#fb7185", size = 3) +
      scale_y_continuous(expand = expansion(mult = c(0.05, 0.12))) +
      coord_cartesian(ylim = c(max(0, min(data$CI_Lower, na.rm = TRUE) - 2),
                               max(data$CI_Upper, na.rm = TRUE) + 2)) +
      labs(x = "3-Year Rolling Period", y = "Deaths per 100,000") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text.x      = element_text(colour = "#94a3b8", angle = 35, hjust = 1, size = 9),
        axis.text.y      = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p, tooltip = "text") %>% plotly_theme()
  })
  
  output$smoking_admissions_plot <- renderPlotly({
    data <- smoking_admissions_data()
    p <- ggplot(data, aes(x = Period, y = Value, group = 1)) +
      geom_ribbon(aes(ymin = CI_Lower, ymax = CI_Upper),
                  fill = "#38bdf8", alpha = 0.15) +
      geom_line(colour = "#38bdf8", linewidth = 1.3) +
      geom_point(aes(
        text = paste0("<b>", Period, "</b><br>",
                      "Admissions: ", formatC(Value, format = "f", digits = 0, big.mark = ","),
                      " per 100,000<br>",
                      "95% CI: ", formatC(CI_Lower, format = "f", digits = 0, big.mark = ","),
                      " – ", formatC(CI_Upper, format = "f", digits = 0, big.mark = ","))
      ), colour = "#7dd3fc", size = 3) +
      scale_y_continuous(
        expand = expansion(mult = c(0.05, 0.12)),
        labels = function(x) formatC(x, format = "f", digits = 0, big.mark = ",")
      ) +
      coord_cartesian(ylim = c(max(0, min(data$CI_Lower, na.rm = TRUE) - 10),
                               max(data$CI_Upper, na.rm = TRUE) + 10)) +
      labs(x = "Financial Year", y = "Admissions per 100,000") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text.x      = element_text(colour = "#94a3b8", angle = 35, hjust = 1, size = 9),
        axis.text.y      = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p, tooltip = "text") %>% plotly_theme()
  })
  
  # ── Obesity plots ─────────────────────────────────────────────────────────
  
  output$obesity_plot <- renderPlotly({
    data    <- obesity_data()
    has_ci  <- !is.na(data$CI_Lower)
    p <- ggplot(data, aes(x = Year, y = Value)) +
      geom_ribbon(data = data[has_ci, ],
                  aes(ymin = CI_Lower, ymax = CI_Upper),
                  fill = "#f43f5e", alpha = 0.15) +
      geom_line(colour = "#f43f5e", linewidth = 1.3) +
      geom_point(aes(
        text = paste0("<b>", Period, "</b><br>Obesity prevalence: ", Value, "%",
                      ifelse(!is.na(CI_Lower),
                             paste0("<br>95% CI: ", CI_Lower, "% – ", CI_Upper, "%"), ""))
      ), colour = "#fb7185", size = 3) +
      scale_y_continuous(
        expand = expansion(mult = c(0.05, 0.12)),
        labels = function(x) paste0(x, "%")
      ) +
      coord_cartesian(ylim = c(max(0, min(data$Value, na.rm = TRUE) - 1),
                               max(data$Value, na.rm = TRUE) + 1.5)) +
      labs(x = "Year", y = "Adults with Obesity (%)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text        = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p, tooltip = "text") %>% plotly_theme()
  })
  
  output$inactive_plot <- renderPlotly({
    data <- inactive_data()
    p <- ggplot(data, aes(x = Period, y = Value, group = 1)) +
      geom_ribbon(aes(ymin = CI_Lower, ymax = CI_Upper),
                  fill = "#f59e0b", alpha = 0.15) +
      geom_line(colour = "#f59e0b", linewidth = 1.3) +
      geom_point(aes(
        text = paste0("<b>", Period, "</b><br>Physically inactive: ", Value, "%<br>",
                      "95% CI: ", CI_Lower, "% – ", CI_Upper, "%")
      ), colour = "#fbbf24", size = 3) +
      scale_y_continuous(
        expand = expansion(mult = c(0.05, 0.12)),
        labels = function(x) paste0(x, "%")
      ) +
      coord_cartesian(ylim = c(max(0, min(data$CI_Lower, na.rm = TRUE) - 0.5),
                               max(data$CI_Upper, na.rm = TRUE) + 0.5)) +
      labs(x = "Financial Year", y = "Physically Inactive Adults (%)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text.x      = element_text(colour = "#94a3b8", angle = 35, hjust = 1, size = 9),
        axis.text.y      = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p, tooltip = "text") %>% plotly_theme()
  })
  
  output$active_plot <- renderPlotly({
    data <- active_data()
    p <- ggplot(data, aes(x = Period, y = Value, group = 1)) +
      geom_ribbon(aes(ymin = CI_Lower, ymax = CI_Upper),
                  fill = "#22c55e", alpha = 0.15) +
      geom_line(colour = "#22c55e", linewidth = 1.3) +
      geom_point(aes(
        text = paste0("<b>", Period, "</b><br>Physically active: ", Value, "%<br>",
                      "95% CI: ", CI_Lower, "% – ", CI_Upper, "%")
      ), colour = "#4ade80", size = 3) +
      scale_y_continuous(
        expand = expansion(mult = c(0.05, 0.12)),
        labels = function(x) paste0(x, "%")
      ) +
      coord_cartesian(ylim = c(max(0, min(data$CI_Lower, na.rm = TRUE) - 0.5),
                               max(data$CI_Upper, na.rm = TRUE) + 0.5)) +
      labs(x = "Financial Year", y = "Physically Active Adults (%)") +
      theme_minimal(base_size = 11) +
      theme(
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        panel.grid       = element_line(colour = "#1e2d47", linewidth = 0.4),
        axis.text.x      = element_text(colour = "#94a3b8", angle = 35, hjust = 1, size = 9),
        axis.text.y      = element_text(colour = "#94a3b8"),
        axis.title       = element_text(colour = "#cbd5e1")
      )
    ggplotly(p, tooltip = "text") %>% plotly_theme()
  })
  
  # ── Smoking value boxes ───────────────────────────────────────────────────
  
  output$smoking_prevalence_latest_box <- renderValueBox({
    data <- smoking_prevalence_data()
    val  <- tail(data$Value, 1)
    yr   <- tail(data$Period, 1)
    valueBox(paste0(val, "%"),
             paste0("Smoking Prevalence, Persons 18+ (", yr, ")"),
             icon = icon("smoking"), color = "yellow")
  })
  
  output$smoking_deaths_latest_box <- renderValueBox({
    data <- smoking_deaths_data()
    val  <- tail(data$Value, 1)
    per  <- tail(data$Period, 1)
    valueBox(paste0(val),
             paste0("Deaths Attr. to Smoking, Persons 35+ (", per, ")"),
             icon = icon("skull-crossbones"), color = "red")
  })
  
  output$smoking_admissions_latest_box <- renderValueBox({
    data <- smoking_admissions_data()
    val  <- formatC(tail(data$Value, 1), format = "f", digits = 0, big.mark = ",")
    per  <- tail(data$Period, 1)
    valueBox(val,
             paste0("Admissions Attr. to Smoking, Persons 35+ (", per, ")"),
             icon = icon("hospital"), color = "light-blue")
  })
  
  # ── Obesity value boxes ───────────────────────────────────────────────────
  
  output$obesity_latest_box <- renderValueBox({
    data <- obesity_data()
    val  <- tail(data$Value, 1)
    yr   <- tail(data$Period, 1)
    valueBox(paste0(val, "%"),
             paste0("Obesity in Adults, Persons 16+ (", yr, ")"),
             icon = icon("weight"), color = "red")
  })
  
  output$inactive_latest_box <- renderValueBox({
    data <- inactive_data()
    val  <- tail(data$Value, 1)
    per  <- tail(data$Period, 1)
    valueBox(paste0(val, "%"),
             paste0("Physically Inactive, Persons 19+ (", per, ")"),
             icon = icon("couch"), color = "yellow")
  })
  
  output$active_latest_box <- renderValueBox({
    data <- active_data()
    val  <- tail(data$Value, 1)
    per  <- tail(data$Period, 1)
    valueBox(paste0(val, "%"),
             paste0("Physically Active, Persons 19+ (", per, ")"),
             icon = icon("running"), color = "green")
  })
  
  # ── Value boxes (population / fertility / life exp / aged65 / infant / maternity) ──
  
  output$total_pop_box <- renderValueBox({
    total <- sum(pyramid_data()$M) + sum(pyramid_data()$F)
    valueBox(format(total, big.mark = ","), "Total Population", icon = icon("users"), color = "blue")
  })
  output$male_pop_box <- renderValueBox({
    valueBox(format(sum(pyramid_data()$M), big.mark = ","), "Male Population", icon = icon("male"), color = "light-blue")
  })
  output$female_pop_box <- renderValueBox({
    valueBox(format(sum(pyramid_data()$F), big.mark = ","), "Female Population", icon = icon("female"), color = "purple")
  })
  
  output$current_fertility_box <- renderValueBox({
    valueBox(round(tail(fertility_data()$Fertility_rate, 1), 2), "Current Fertility Rate", icon = icon("baby"), color = "green")
  })
  output$max_fertility_box <- renderValueBox({
    valueBox(round(max(filtered_fertility()$Fertility_rate, na.rm = TRUE), 2), "Period Maximum", icon = icon("arrow-up"), color = "yellow")
  })
  output$min_fertility_box <- renderValueBox({
    valueBox(round(min(filtered_fertility()$Fertility_rate, na.rm = TRUE), 2), "Period Minimum", icon = icon("arrow-down"), color = "red")
  })
  
  output$current_life_exp_box <- renderValueBox({
    valueBox(round(tail(life_expectancy_data()$Life_expectancy_at_Birth, 1), 1), "Current Life Expectancy", icon = icon("heartbeat"), color = "green")
  })
  output$max_life_exp_box <- renderValueBox({
    valueBox(round(max(filtered_life_expectancy()$Life_expectancy_at_Birth, na.rm = TRUE), 1), "Period Maximum", icon = icon("arrow-up"), color = "aqua")
  })
  output$min_life_exp_box <- renderValueBox({
    valueBox(round(min(filtered_life_expectancy()$Life_expectancy_at_Birth, na.rm = TRUE), 1), "Period Minimum", icon = icon("arrow-down"), color = "orange")
  })
  
  output$current_aged65_box <- renderValueBox({
    valueBox(paste0(round(tail(aged65_data()$Percentage, 1), 1), "%"),
             "Current % Aged 65+", icon = icon("user-clock"), color = "light-blue")
  })
  output$max_aged65_box <- renderValueBox({
    valueBox(paste0(round(max(filtered_aged65()$Percentage, na.rm = TRUE), 1), "%"),
             "Period Maximum", icon = icon("arrow-up"), color = "aqua")
  })
  output$min_aged65_box <- renderValueBox({
    valueBox(paste0(round(min(filtered_aged65()$Percentage, na.rm = TRUE), 1), "%"),
             "Period Minimum", icon = icon("arrow-down"), color = "blue")
  })
  
  output$infant_current_box <- renderValueBox({
    val <- round(tail(infant_data()$`Rate per 1000 live births`, 1), 1)
    valueBox(val, "Latest Infant Mortality Rate", icon = icon("baby"), color = "purple")
  })
  output$infant_max_box <- renderValueBox({
    val <- round(max(filtered_infant()$`Rate per 1000 live births`, na.rm = TRUE), 1)
    valueBox(val, "Period Maximum", icon = icon("arrow-up"), color = "red")
  })
  output$infant_min_box <- renderValueBox({
    val <- round(min(filtered_infant()$`Rate per 1000 live births`, na.rm = TRUE), 1)
    valueBox(val, "Period Minimum", icon = icon("arrow-down"), color = "aqua")
  })
  
  output$maternity_total_periods_box <- renderValueBox({
    n <- n_distinct(maternity_data()$Period)
    valueBox(n, "Time Periods Covered", icon = icon("calendar"), color = "red")
  })
  output$maternity_causes_box <- renderValueBox({
    n <- n_distinct(maternity_data()$Death)
    valueBox(n, "Causes Tracked", icon = icon("list"), color = "orange")
  })
  output$maternity_peak_box <- renderValueBox({
    data     <- maternity_data()
    peak_row <- data[which.max(data$`Rate/100,000`), ]
    valueBox(paste0(round(peak_row$`Rate/100,000`, 2)),
             paste0("Peak Rate — ", peak_row$Death),
             icon = icon("arrow-up"), color = "yellow")
  })
  
  # ── Summary HTML outputs ──────────────────────────────────────────────────
  
  output$summary_stats <- renderUI({
    pyramid    <- pyramid_data()
    deaths     <- death_rate_data()
    fertility  <- fertility_data()
    life_exp   <- life_expectancy_data()
    total_pop  <- sum(pyramid$M) + sum(pyramid$F)
    male_pct   <- (sum(pyramid$M) / total_pop) * 100
    female_pct <- (sum(pyramid$F) / total_pop) * 100
    HTML(paste0(
      "<h4>Key Indicators — United Kingdom</h4>",
      "<p><strong>Total Population:</strong> ", format(total_pop, big.mark = ","), "</p>",
      "<p><strong>Male / Female Split:</strong> ", round(male_pct, 1), "% / ", round(female_pct, 1), "%</p>",
      "<p><strong>Latest Crude Death Rate:</strong> ", round(tail(deaths$`Crude Death Rate`, 1), 2), " per 1,000</p>",
      "<p><strong>Latest Mortality Rate:</strong> ", round(tail(deaths$Mortality_Rate, 1), 2), " per 1,000</p>",
      "<p><strong>Total Fertility Rate:</strong> ", round(tail(fertility$Fertility_rate, 1), 2), " births per woman</p>",
      "<p><strong>Life Expectancy at Birth:</strong> ", round(tail(life_exp$Life_expectancy_at_Birth, 1), 1), " years</p>"
    ))
  })
  
  output$fertility_summary <- renderUI({
    data <- filtered_fertility()
    HTML(paste0(
      "<h4>Fertility Rate — Period Statistics</h4>",
      "<p><strong>Average:</strong> ",  round(mean(data$Fertility_rate, na.rm = TRUE), 2), " births per woman</p>",
      "<p><strong>Median:</strong> ",   round(median(data$Fertility_rate, na.rm = TRUE), 2), " births per woman</p>",
      "<p><strong>Peak:</strong> ",     round(max(data$Fertility_rate, na.rm = TRUE), 2), " in ",
      data$Year[which.max(data$Fertility_rate)], "</p>",
      "<p><strong>Trough:</strong> ",   round(min(data$Fertility_rate, na.rm = TRUE), 2), " in ",
      data$Year[which.min(data$Fertility_rate)], "</p>",
      "<p><strong>Range:</strong> ",    round(max(data$Fertility_rate, na.rm = TRUE) - min(data$Fertility_rate, na.rm = TRUE), 2), "</p>"
    ))
  })
  
  output$life_exp_summary <- renderUI({
    data <- filtered_life_expectancy()
    HTML(paste0(
      "<h4>Life Expectancy — Period Statistics</h4>",
      "<p><strong>Average:</strong> ",  round(mean(data$Life_expectancy_at_Birth, na.rm = TRUE), 1), " years</p>",
      "<p><strong>Median:</strong> ",   round(median(data$Life_expectancy_at_Birth, na.rm = TRUE), 1), " years</p>",
      "<p><strong>Peak:</strong> ",     round(max(data$Life_expectancy_at_Birth, na.rm = TRUE), 1), " years in ",
      data$Year[which.max(data$Life_expectancy_at_Birth)], "</p>",
      "<p><strong>Lowest:</strong> ",   round(min(data$Life_expectancy_at_Birth, na.rm = TRUE), 1), " years in ",
      data$Year[which.min(data$Life_expectancy_at_Birth)], "</p>",
      "<p><strong>Total Gain:</strong> ", round(max(data$Life_expectancy_at_Birth, na.rm = TRUE) -
                                                  min(data$Life_expectancy_at_Birth, na.rm = TRUE), 1), " years</p>"
    ))
  })
  
  output$aged65_summary <- renderUI({
    data     <- filtered_aged65()
    all_data <- aged65_data()
    change   <- tail(data$Percentage, 1) - head(data$Percentage, 1)
    yrs      <- tail(data$Year, 1) - head(data$Year, 1)
    HTML(paste0(
      "<h4>Population Aged 65+ — Period Statistics</h4>",
      "<p><strong>Latest (all data):</strong> ", round(tail(all_data$Percentage, 1), 1), "%</p>",
      "<p><strong>Average in period:</strong> ", round(mean(data$Percentage, na.rm = TRUE), 1), "%</p>",
      "<p><strong>Peak:</strong> ", round(max(data$Percentage, na.rm = TRUE), 1), "% in ",
      data$Year[which.max(data$Percentage)], "</p>",
      "<p><strong>Lowest:</strong> ", round(min(data$Percentage, na.rm = TRUE), 1), "% in ",
      data$Year[which.min(data$Percentage)], "</p>",
      "<p><strong>Total change over period:</strong> ", ifelse(change >= 0, "+", ""), round(change, 1),
      " percentage points over ", yrs, " years</p>"
    ))
  })
  
  output$asfr_summary <- renderUI({
    data <- filtered_asfr()
    if (nrow(data) == 0) return(HTML("<p>No data for selected filters.</p>"))
    summary_by_age <- data %>%
      group_by(Age_group) %>%
      summarise(Mean_Rate = mean(Rate, na.rm = TRUE),
                Max_Rate  = max(Rate,  na.rm = TRUE),
                Min_Rate  = min(Rate,  na.rm = TRUE),
                .groups   = "drop")
    recent_year <- max(data$Year, na.rm = TRUE)
    recent_data <- data %>% filter(Year == recent_year)
    peak_age    <- if (nrow(recent_data) > 0) recent_data$Age_group[which.max(recent_data$Rate)] else "N/A"
    rows <- paste0(
      apply(summary_by_age, 1, function(r)
        paste0("<tr><td>", r["Age_group"], "</td>",
               "<td style='text-align:center'>", round(as.numeric(r["Mean_Rate"]), 1), "</td>",
               "<td style='text-align:center'>", round(as.numeric(r["Max_Rate"]),  1), "</td>",
               "<td style='text-align:center'>", round(as.numeric(r["Min_Rate"]),  1), "</td></tr>")
      ), collapse = "")
    HTML(paste0(
      "<h4>Age-Specific Fertility Rates</h4>",
      "<p><strong>Peak fertility age group (", recent_year, "):</strong> ", peak_age, "</p>",
      "<table style='width:100%;border-collapse:collapse;margin-top:12px'>",
      "<tr><th>Age Group</th><th>Mean</th><th>Max</th><th>Min</th></tr>",
      rows, "</table>"
    ))
  })
  
  output$maternity_summary <- renderUI({
    data <- maternity_data()
    summary_by_cause <- data %>%
      group_by(Death) %>%
      summarise(Mean_Rate = mean(`Rate/100,000`, na.rm = TRUE),
                Max_Rate  = max(`Rate/100,000`,  na.rm = TRUE),
                Min_Rate  = min(`Rate/100,000`,  na.rm = TRUE),
                .groups   = "drop") %>%
      arrange(desc(Mean_Rate))
    rows <- paste0(
      apply(summary_by_cause, 1, function(r)
        paste0("<tr><td>", r["Death"], "</td>",
               "<td style='text-align:center'>", round(as.numeric(r["Mean_Rate"]), 2), "</td>",
               "<td style='text-align:center'>", round(as.numeric(r["Max_Rate"]),  2), "</td>",
               "<td style='text-align:center'>", round(as.numeric(r["Min_Rate"]),  2), "</td></tr>")
      ), collapse = "")
    HTML(paste0(
      "<h4>Maternity Death Rates per 100,000 Maternities</h4>",
      "<p><strong>Time periods covered:</strong> ", n_distinct(data$Period), "</p>",
      "<p><strong>Causes tracked:</strong> ", n_distinct(data$Death), "</p>",
      "<table style='width:100%;border-collapse:collapse;margin-top:12px'>",
      "<tr><th>Cause of Death</th><th>Mean Rate</th><th>Peak Rate</th><th>Min Rate</th></tr>",
      rows, "</table>"
    ))
  })
  
  output$smoking_summary <- renderUI({
    prev <- smoking_prevalence_data()
    dths <- smoking_deaths_data()
    adms <- smoking_admissions_data()
    prev_change <- round(tail(prev$Value, 1) - head(prev$Value, 1), 1)
    dths_change <- round(tail(dths$Value, 1) - head(dths$Value, 1), 1)
    adms_change <- round(tail(adms$Value, 1) - head(adms$Value, 1), 0)
    fmt_arrow <- function(val) ifelse(val < 0,
                                      paste0("<span style='color:#4ade80'>&#9660; ", abs(val), "</span>"),
                                      paste0("<span style='color:#f43f5e'>&#9650; ", abs(val), "</span>"))
    HTML(paste0(
      "<h4>Smoking & Health — England Summary</h4>",
      "<p><strong>Smoking Prevalence</strong>",
      " <span style='font-size:11px; color:#64748b; font-style:italic;'>· Persons · 18 years and over</span></p>",
      "<p>Latest: <strong>", tail(prev$Value, 1), "%</strong> &nbsp;|&nbsp; ",
      "Peak: <strong>", max(prev$Value, na.rm = TRUE), "%</strong> &nbsp;|&nbsp; ",
      "Lowest: <strong>", min(prev$Value, na.rm = TRUE), "%</strong><br>",
      "Change over period: ", fmt_arrow(prev_change), " percentage points</p>",
      "<p><strong>Smoking-Attributable Deaths (per 100,000)</strong>",
      " <span style='font-size:11px; color:#64748b; font-style:italic;'>· Persons · 35 years and over</span></p>",
      "<p>Latest: <strong>", tail(dths$Value, 1), "</strong> &nbsp;|&nbsp; ",
      "Peak: <strong>", max(dths$Value, na.rm = TRUE), "</strong> &nbsp;|&nbsp; ",
      "Lowest: <strong>", min(dths$Value, na.rm = TRUE), "</strong><br>",
      "Change over period: ", fmt_arrow(dths_change), " per 100,000</p>",
      "<p><strong>Smoking-Attributable Hospital Admissions (per 100,000)</strong>",
      " <span style='font-size:11px; color:#64748b; font-style:italic;'>· Persons · 35 years and over</span></p>",
      "<p>Latest: <strong>", formatC(tail(adms$Value, 1), format = "f", digits = 0, big.mark = ","),
      "</strong> &nbsp;|&nbsp; ",
      "Peak: <strong>", formatC(max(adms$Value, na.rm = TRUE), format = "f", digits = 0, big.mark = ","),
      "</strong> &nbsp;|&nbsp; ",
      "Lowest: <strong>", formatC(min(adms$Value, na.rm = TRUE), format = "f", digits = 0, big.mark = ","),
      "</strong><br>",
      "Change over period: ", fmt_arrow(adms_change), " per 100,000</p>",
      "<p style='margin-top:14px; font-size:11px; color:#4b5563;'>",
      "Source: NHS England / Office for Health Improvements and Disparities (OHID). ",
      "All rates are age-standardised where applicable. Ribbons show 95% confidence intervals.",
      "</p>"
    ))
  })
  
  output$obesity_summary <- renderUI({
    ob  <- obesity_data()
    ina <- inactive_data()
    act <- active_data()
    ob_change  <- round(tail(ob$Value,  1) - head(ob$Value,  1), 1)
    ina_change <- round(tail(ina$Value, 1) - head(ina$Value, 1), 1)
    act_change <- round(tail(act$Value, 1) - head(act$Value, 1), 1)
    fmt_arrow <- function(val, higher_is_bad = TRUE) {
      if (higher_is_bad) {
        ifelse(val > 0,
               paste0("<span style='color:#f43f5e'>&#9650; +", abs(val), "</span>"),
               paste0("<span style='color:#4ade80'>&#9660; ", val, "</span>"))
      } else {
        ifelse(val > 0,
               paste0("<span style='color:#4ade80'>&#9650; +", abs(val), "</span>"),
               paste0("<span style='color:#f43f5e'>&#9660; ", val, "</span>"))
      }
    }
    HTML(paste0(
      "<h4>Obesity & Physical Activity — England Summary</h4>",
      "<p><strong>Adult Obesity Prevalence</strong>",
      " <span style='font-size:11px; color:#64748b; font-style:italic;'>· Persons · 16 years and over</span></p>",
      "<p>Latest: <strong>", tail(ob$Value, 1), "%</strong> &nbsp;|&nbsp; ",
      "Peak: <strong>", max(ob$Value, na.rm = TRUE), "%</strong> &nbsp;|&nbsp; ",
      "Lowest recorded: <strong>", min(ob$Value, na.rm = TRUE), "%</strong><br>",
      "Change over full period (", head(ob$Period, 1), " – ", tail(ob$Period, 1), "): ",
      fmt_arrow(ob_change, higher_is_bad = TRUE), " percentage points</p>",
      "<p><strong>Physically Inactive Adults</strong>",
      " <span style='font-size:11px; color:#64748b; font-style:italic;'>· Persons · 19 years and over</span></p>",
      "<p>Latest: <strong>", tail(ina$Value, 1), "%</strong> &nbsp;|&nbsp; ",
      "Peak: <strong>", max(ina$Value, na.rm = TRUE), "%</strong> &nbsp;|&nbsp; ",
      "Lowest: <strong>", min(ina$Value, na.rm = TRUE), "%</strong><br>",
      "Change over period: ",
      fmt_arrow(ina_change, higher_is_bad = TRUE), " percentage points</p>",
      "<p><strong>Physically Active Adults</strong>",
      " <span style='font-size:11px; color:#64748b; font-style:italic;'>· Persons · 19 years and over</span></p>",
      "<p>Latest: <strong>", tail(act$Value, 1), "%</strong> &nbsp;|&nbsp; ",
      "Peak: <strong>", max(act$Value, na.rm = TRUE), "%</strong> &nbsp;|&nbsp; ",
      "Lowest: <strong>", min(act$Value, na.rm = TRUE), "%</strong><br>",
      "Change over period: ",
      fmt_arrow(act_change, higher_is_bad = FALSE), " percentage points</p>",
      "<p style='margin-top:14px; font-size:11px; color:#4b5563;'>",
      "Source: NHS England / Office for Health Improvements and Disparities (OHID). ",
      "Obesity data from Health Survey for England; activity data from Sport England Active Lives Survey. ",
      "Ribbons show 95% confidence intervals where available.",
      "</p>"
    ))
  })
  
  # ── Data Tables ───────────────────────────────────────────────────────────
  dt_options <- list(
    pageLength   = 12,
    scrollX      = TRUE,
    dom          = "Bfrtip",
    initComplete = JS(
      "function(settings, json) {",
      "  $(this.api().table().header()).css({'background-color':'#111827','color':'#f59e0b'});",
      "}"
    )
  )
  
  output$population_table <- renderDT({
    filtered_pyramid() %>%
      select(Age, M, F, Male_pct, Female_pct) %>%
      rename("Age Group" = Age, "Male Pop" = M, "Female Pop" = F,
             "Male %" = Male_pct, "Female %" = Female_pct) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("Male %", "Female %"), digits = 2) %>%
      formatStyle("Male Pop",   color = "#38bdf8") %>%
      formatStyle("Female Pop", color = "#f472b6")
  })
  
  output$death_rate_table <- renderDT({
    death_rate_data() %>%
      rename("Year"             = Year,
             "Crude Death Rate" = `Crude Death Rate`,
             "Mortality Rate"   = Mortality_Rate) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("Crude Death Rate", "Mortality Rate"), digits = 2) %>%
      formatStyle("Crude Death Rate", color = "#f59e0b") %>%
      formatStyle("Mortality Rate",   color = "#f43f5e")
  })
  
  output$infant_table <- renderDT({
    infant_data() %>%
      rename("Year" = Year,
             "Rate per 1,000 Live Births" = `Rate per 1000 live births`) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = "Rate per 1,000 Live Births", digits = 2) %>%
      formatStyle("Rate per 1,000 Live Births", color = "#a78bfa")
  })
  
  output$fertility_table <- renderDT({
    fertility_data() %>%
      rename("Year" = Year,
             "Fertility Rate (births per woman)" = Fertility_rate) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = "Fertility Rate (births per woman)", digits = 3) %>%
      formatStyle("Fertility Rate (births per woman)", color = "#5eead4")
  })
  
  output$asfr_table <- renderDT({
    asfr_data() %>%
      rename("Year" = Year, "Age Group" = Age_group, "Rate" = Rate) %>%
      arrange(Year, `Age Group`) %>%
      datatable(options = dt_options, class = "compact hover", filter = "top") %>%
      formatRound(columns = "Rate", digits = 2) %>%
      formatStyle("Age Group", color = "#f59e0b") %>%
      formatStyle("Rate",      color = "#e2e8f0")
  })
  
  output$life_exp_table <- renderDT({
    life_expectancy_data() %>%
      rename("Year" = Year,
             "Life Expectancy at Birth (years)" = Life_expectancy_at_Birth) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = "Life Expectancy at Birth (years)", digits = 2) %>%
      formatStyle("Life Expectancy at Birth (years)", color = "#4ade80")
  })
  
  output$aged65_table <- renderDT({
    aged65_data() %>%
      rename("Year" = Year, "Population Aged 65+ (%)" = Percentage) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = "Population Aged 65+ (%)", digits = 2) %>%
      formatStyle("Population Aged 65+ (%)", color = "#7dd3fc")
  })
  
  output$maternity_table <- renderDT({
    maternity_data() %>%
      rename("Period"                         = Period,
             "Cause of Death"                 = Death,
             "Rate per 100,000 Maternities"   = `Rate/100,000`) %>%
      arrange(Period, `Cause of Death`) %>%
      datatable(options = dt_options, class = "compact hover", filter = "top") %>%
      formatRound(columns = "Rate per 100,000 Maternities", digits = 3) %>%
      formatStyle("Cause of Death",               color = "#f59e0b") %>%
      formatStyle("Rate per 100,000 Maternities", color = "#fb7185")
  })
  
  output$lead_causes_table <- renderDT({
    lead_causes_data() %>%
      select(`Leading Cause(Male)`, Percentage_M,
             `Leading Cause(Female)`, Percentage_F) %>%
      rename("Leading Cause (Male)"   = `Leading Cause(Male)`,
             "% Male Deaths"          = Percentage_M,
             "Leading Cause (Female)" = `Leading Cause(Female)`,
             "% Female Deaths"        = Percentage_F) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("% Male Deaths", "% Female Deaths"), digits = 2) %>%
      formatStyle("% Male Deaths",   color = "#38bdf8") %>%
      formatStyle("% Female Deaths", color = "#4ade80")
  })
  
  output$smoking_prev_table <- renderDT({
    smoking_prevalence_data() %>%
      select(Period, Value, CI_Lower, CI_Upper) %>%
      rename("Year"             = Period,
             "Prevalence (%)"   = Value,
             "95% CI Lower (%)" = CI_Lower,
             "95% CI Upper (%)" = CI_Upper) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("Prevalence (%)", "95% CI Lower (%)", "95% CI Upper (%)"), digits = 1) %>%
      formatStyle("Prevalence (%)", color = "#fbbf24")
  })
  
  output$smoking_deaths_table <- renderDT({
    smoking_deaths_data() %>%
      select(Period, Value, CI_Lower, CI_Upper) %>%
      rename("Period"                     = Period,
             "Deaths per 100,000"         = Value,
             "95% CI Lower (per 100,000)" = CI_Lower,
             "95% CI Upper (per 100,000)" = CI_Upper) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("Deaths per 100,000",
                              "95% CI Lower (per 100,000)",
                              "95% CI Upper (per 100,000)"), digits = 1) %>%
      formatStyle("Deaths per 100,000", color = "#fb7185")
  })
  
  output$smoking_admissions_table <- renderDT({
    smoking_admissions_data() %>%
      select(Period, Value, CI_Lower, CI_Upper) %>%
      rename("Financial Year"             = Period,
             "Admissions per 100,000"     = Value,
             "95% CI Lower (per 100,000)" = CI_Lower,
             "95% CI Upper (per 100,000)" = CI_Upper) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("Admissions per 100,000",
                              "95% CI Lower (per 100,000)",
                              "95% CI Upper (per 100,000)"), digits = 0) %>%
      formatStyle("Admissions per 100,000", color = "#7dd3fc")
  })
  
  output$obesity_table <- renderDT({
    obesity_data() %>%
      select(Period, Value, CI_Lower, CI_Upper) %>%
      rename("Year"             = Period,
             "Obesity (%)"      = Value,
             "95% CI Lower (%)" = CI_Lower,
             "95% CI Upper (%)" = CI_Upper) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("Obesity (%)", "95% CI Lower (%)", "95% CI Upper (%)"), digits = 1) %>%
      formatStyle("Obesity (%)", color = "#fb7185")
  })
  
  output$inactive_table <- renderDT({
    inactive_data() %>%
      select(Period, Value, CI_Lower, CI_Upper) %>%
      rename("Financial Year"      = Period,
             "Inactive Adults (%)" = Value,
             "95% CI Lower (%)"    = CI_Lower,
             "95% CI Upper (%)"    = CI_Upper) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("Inactive Adults (%)", "95% CI Lower (%)", "95% CI Upper (%)"), digits = 1) %>%
      formatStyle("Inactive Adults (%)", color = "#fbbf24")
  })
  
  output$active_table <- renderDT({
    active_data() %>%
      select(Period, Value, CI_Lower, CI_Upper) %>%
      rename("Financial Year"     = Period,
             "Active Adults (%)"  = Value,
             "95% CI Lower (%)"   = CI_Lower,
             "95% CI Upper (%)"   = CI_Upper) %>%
      datatable(options = dt_options, class = "compact hover") %>%
      formatRound(columns = c("Active Adults (%)", "95% CI Lower (%)", "95% CI Upper (%)"), digits = 1) %>%
      formatStyle("Active Adults (%)", color = "#4ade80")
  })
  
}

shinyApp(ui = ui, server = server)