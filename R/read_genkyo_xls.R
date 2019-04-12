read_genkyo_xls <- function(input, sheet_index = 1, tidy = FALSE) {
  target <-
    readxl::excel_sheets(input) %>%
    purrr::pluck(sheet_index)

  d <-
    readxl::read_excel(input,
                     sheet = sheet_index,
                       range = "C6:V52",
                       col_names = FALSE) %>%
    dplyr::mutate(
      year = readr::parse_number(basename(input)),
      target = target
    ) %>%
    dplyr::select(
      year,
      target,
      tidyselect::everything()
    ) %>%
    purrr::set_names(
      c("year",
        "target",
        "prefecture",
        stringr::str_c("age_", seq.int(1, 18)),
        "age_19over")
    ) %>%
    dplyr::mutate(target = stringr::str_replace(target,
                                                pattern = "\\u30b9\\u30ae\\uff9e",
                                                replacement = "\\u30b9\\u30ae"))

  if (rlang::is_false(tidy))
    d
  else
    d %>%
    tidyr::gather("age", "value", tidyselect::starts_with("age_"))
}
