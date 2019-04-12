library(purrr)
library(assertr)
library(conflicted)

input_xls <-
  fs::dir_ls(here::here("data-raw"), regexp = "genkyo_[0-9]{4}.xls")

var_names <-
  c("prefecture",
    stringr::str_c("age_", seq.int(1, 18)),
    "age_19over")

input_xls[1] %>%
  readxl::read_excel(sheet = 1,
             range = "C6:V52",
             col_names = FALSE) %>%
  set_names(var_names) %>%
  verify(dim(.) == c(47, 20))
