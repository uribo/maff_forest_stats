library(drake)
library(conflicted)
conflict_prefer("filter", winner = "dplyr")
source(here::here("data-raw/parse_genkyo.R"))

my_plan <-
  drake_plan(
    conflict_prefer("filter", winner = "dplyr"),
    cross_data_counts =
      df_conifer_age %>%
      count(year, target, prefecture),
    missing_counts =
      df_conifer_age %>%
      summarise_all(list(~ sum(is.na(.)))),
    plot1 =
      df_conifer_age %>%
      filter(year == 2017,
             prefecture %in% c("東京都", "神奈川県", "茨城県")) %>%
      mutate(age = stringr::str_pad(stringr::str_remove_all( age, "age_"), width = 2, pad = "0")) %>%
      ggplot(aes(age, value, fill = target)) +
      geom_bar(stat = "identity") +
      theme_gray(base_family = "IPAPGothic") +
      gghighlight::gghighlight() +
      facet_grid(prefecture ~ target) +
      guides(fill = FALSE) +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "齢階級",
           y = "ha",
           title = "2017年 スギ・ヒノキ人口林における齢級別面積",
           subtitle = "各県での値をハイライト。3県の合計をグレーで表示。",
           caption = "Data: 林野庁 森林資源の現況 (平成29年)\nhttp://www.rinya.maff.go.jp/j/keikaku/genkyou/h29/index.html"))
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
