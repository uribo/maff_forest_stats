#####################################
# 林野庁 森林資源の現況
# 2007年, 2012年, 2017年
# 樹種別齢級別面積 データダウンロード
#####################################
if (length(fs::dir_ls(here::here("data-raw"), regexp = "genkyo_[0-9]{4}.xls")) != 3L) {

  library(rvest)
  library(ensurer)
  library(assertr)
  library(purrr)
  # library(stringr)
  library(conflicted)
  conflict_prefer("pluck", winner = "purrr")

  # 1/2 ダウンロードするファイルURLを得る -------------------------
  site_url <-
    "http://www.rinya.maff.go.jp/"

  target_url <-
    glue::glue(site_url, "j/keikaku/genkyou/index1.html")

  year_links <-
    read_html(target_url) %>%
    html_nodes(css = '#main_content > h3 > a') %>% # nolint
    html_attr("href") %>%
    # 3ヶ年が選ばれているか
    ensure(length(.) == 3L) %>%
    map_chr(
      ~ read_html(.x) %>%
        html_nodes('#main_content > h3 > a') %>%
        # 樹種別齢級別面積のリンク先のURLを得る
        keep(
          ~ stringr::str_detect(html_text(.x), "樹種別齢級別面積")) %>%
        html_attr(name = "href")) %>%
    ensure(length(.) == 3L) %>%
    # データの公開年をファイル名に使うため
    set_names(
      stringr::str_extract(., "h[1-2]{1}[0-9]{1}"))

  dl_links <-
    year_links %>%
    map_chr(
      ~ read_html(.x) %>%
        html_nodes(css = '#main_content > p > a') %>% # nolint
        keep(
          ~ stringr::str_detect(html_text(.x), "全データダウンロード")) %>%
        html_attr("href") %>%
        xml2::url_absolute(.x)) %>%
    ensure(length(.) == 3L)

  # 2/2 data-rawフォルダにダウンロード ------------------------------
  dl_links %>%
    walk2(
      .y = names(dl_links),
      .f = ~
        curl::curl_download(.x,
                            destfile = glue::glue("data-raw/genkyo_{year}.",
                                                  # ファイル形式を取得 hoge.xls --> xls
                                                  tools::file_ext(.x),
                                                  # 和暦から西暦へ H29 --> 2017
                                                  year = odkitchen::convert_jyr(.y))))
}
