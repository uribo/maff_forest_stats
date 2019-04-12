林野庁森林資源現況
===============================

このリポジトリは [Tokyo.R#77](https://tokyor.connpass.com/event/125793/) での発表のためのサンプルリポジトリです。

## このリポジトリの構築手順

```r
packageVersion("usethis") # 1.5.0


# プロジェクトの作成 ---------------------------------------------------------------
usethis::create_project(path = "~/Documents/projects2019/maff_forest_stats",
               open = TRUE)
# プロジェクトの画面が立ち上がる

# プロジェクトの設定 ---------------------------------------------------------------
library(usethis)
use_git() # Initial commitを行うか、RStudioを立ち上げ直しても良いかの確認（Gitパネルが有効になる）

# # RからGitHubリポジトリを作成する場合
# token <- browse_github_token()
# use_github(private = FALSE, auth_token = token)

# ウェブ上で作成したリポジトリを紐付ける場合
# GitHubで表示された内容をTerminalで実行 (Cmd + Shift + return)

# git remote add origin git@github.com:uribo/maff_forest_stats.git
# git push -u origin master

# Docker環境を用意する -----------------------------------------------------------
# docker pull rocker/geospatial:3.5.3
use_git_ignore(".env")
```
