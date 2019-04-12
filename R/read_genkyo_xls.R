read_genkyo_xls <- function(input, sheet_index = 1) {
  target <-
    readxl::excel_sheets(input) %>%
    purrr::pluck(sheet_index)

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
    )
}
