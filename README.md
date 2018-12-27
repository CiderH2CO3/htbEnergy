htbEnergy
===
HTBエナジーのCSV可視化ツール
![image](https://user-images.githubusercontent.com/14069896/50462141-a05af180-09c6-11e9-8864-211b7ce65921.png)

## 概要
- HTBエナジー (https://htb-energy.co.jp) のマイページからダウンロードできるCSVデータを可視化できます
    - マイページ -> 電力使用量・ご請求 -> 請求書を見る -> 電力使用量の項目のCSVをダウンロード
- 生成できるグラフ
    - 「使用タイミング折れ線」30分ごとで折れ線グラフを生成します
    - 「一番使っている時間は？」１日のうちもっとも使用している時間をヒストグラムで図示します

## 起動方法
1. R (https://www.r-project.org) をPCにインストール
2. Shiny (https://shiny.rstudio.com) をRにインストール
    1. コマンドラインで `r` と入力しRのシェル画面を起動
    2. `install.packages("shiny")` を実行
3. コマンドラインから run.sh を起動
