## Preliminaries -----------------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, readxl, data.table, gdata, ipumsr)

# Set working directory -----------------------------------------------------
setwd("C:/Users/CarolXu/OneDrive - Cato Institute/Desktop/Welfare Trends 1994-2000")

# Load data
data = fread("data/output/data.final.csv")

# Recreate Borjas immigration-status groups ----------------------------------

# Restrict to under age 65 and persons who do not reside in group quarters
data = data %>%
  filter(age < 65, gq == 1)

# Borjas identifies samples by household head 
heads = data %>%
    filter(relate == 0101) %>%
    select(year, serial, bpl, citizen)

heads = heads %>%
    rename(head_bpl = bpl,
    head_citizen = citizen) 

data = left_join(data, heads, by = c("year", "serial"))

# immigration groups
data = data %>%
    mutate(immigration_status = case_when(
        head_bpl == 9900 ~ "Native",
        head_citizen == 5 ~ "Non-citizen",
        TRUE ~ "Naturalized citizen"))

# remove ESI NAs
data = data %>%
    mutate( 
        any_insurance = hcovany == 2,
        medicaid = himcaidly == 2,
        esi = ifelse(is.na(hinsemp), FALSE, hinsemp == 2))

# Trends in Welfare Participation and Health Insurance Coverage
table1 = data %>%
  group_by(year, immigration_status) %>%
  summarise(
    medicaid = weighted.mean(medicaid, asecwt, na.rm = TRUE) * 100,
    insured = weighted.mean(any_insurance, asecwt, na.rm = TRUE) * 100,
    esi = weighted.mean(esi, asecwt, na.rm = TRUE) * 100,
    .groups = "drop")
