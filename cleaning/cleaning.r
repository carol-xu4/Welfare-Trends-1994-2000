## Preliminaries -----------------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, readxl, data.table, gdata, ipumsr)

# Set working directory ----------------------------------------------------
setwd("C:/Users/CarolXu/OneDrive - Cato Institute/Desktop/Welfare Trends 1994-2000")

# Load data -------------------------------------------------------------
ddi = read_ipums_ddi("data/input/cps_00001.xml")

df = read_ipums_micro(ddi)

# Select & rename relevant variables
df = df %>%
  rename_with(tolower)

data = df %>%
  select(year,
  serial,
  pernum,
  asecwt,
  gq,
  relate,
  age,
  bpl,
  citizen,
  himcaidly,
  hcovany,
  hinsemp)

# rewrite
write_csv(data, "data/output/data.final.csv")
