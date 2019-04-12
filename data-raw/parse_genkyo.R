####################################
# 森林現況 樹種別齢級別面積データ(xls) の読み込み
####################################
library(readxl)
library(purrr)
library(assertr)
library(ensurer)
library(conflicted)
source(here::here("R/read_genkyo_xls.R"))

# 1/2 人工林スギ、人工林ヒノキを対象にする --------------------------------------------------
input_xls <-
  fs::dir_ls(here::here("data-raw"), regexp = "genkyo_[0-9]{4}.xls")

target_sheet_index <-
  input_xls %>%
  purrr::map(
    ~ excel_sheets(.x) %>%
      # ref) issue#4
      # 人工林スギ、人工林ヒノキをエスケープ
      stringr:::str_which("\\A\\u4eba\\u5de5\\u6797(\\u30b9\\u30ae\\uff9e|\\u30b9\\u30ae|\\u30d2\\u30ce\\u30ad)\\z") %>%
      ensure(length(.) == 2L)
  ) %>%
  # シート位置が共通なのでユニークにする
  flatten_dbl() %>%
  unique()

# read_genkyo_xls(input_xls[3], sheet_index = target_sheet_index[2]) %>%
#   verify(dim(.) == c(47, 22))


# 2/2 ファイル、シートの組み合わせでデータを読み込む ---------------------------------------------
input_sets <-
  list(
    input_xls,
    target_sheet_index) %>%
  cross()

df_conifer_age <-
  input_sets %>%
  map_dfr(lift(read_genkyo_xls), .id = "index") %>%
  verify(dim(.) == c(47 * length(input_sets), 23))
