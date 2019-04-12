library(drake)
library(conflicted)
conflict_prefer("filter", winner = "dplyr")
source(here::here("data-raw/parse_genkyo.R"))

my_plan <-
  drake_plan(
    cross_data_counts =
      df_conifer_age %>%
      count(year, target, prefecture),
  missing_counts =
    df_conifer_age %>%
    summarise_all(list(~ sum(is.na(.)))),
  plot1 =
    df_conifer_age %>%
    filter(year == 2007, target == "人工林スギ") %>%
    ggplot(aes(age, value)) +
    geom_bar(stat = "identity") +
    facet_wrap(~ prefecture))
drake::make(my_plan,
            log_progress = FALSE,
            cache_log_file = TRUE,
            session_info = TRUE,
            packages = c("ggplot2", "dplyr"))
drake::loadd(list = my_plan %>%
               purrr::pluck("target"))

cross_data_counts
missing_counts

plot1
