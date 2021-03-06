# Goal Share!
![logo_orange_base](https://user-images.githubusercontent.com/70130536/100323405-0b752e80-3009-11eb-9bce-9b6582d7bbf6.png)


## URL
https://www.goal-share.xyz/
## 概要
**「ToDo管理×仲間づくり」** で、**目標達成をサポート** するアプリです。

日々のタスク管理はもちろん、コミュニティ機能を通じて目標を掲げるユーザが繋がることが出来ます。<br>
投稿で日々の積み上げをしながら、「いいね」や質問で **「励まし合って高め合える場」**、**「勇気をもらえる場」** を提供します！

## 製作背景
受験・資格試験の勉強、英語、読書、朝活…etc<br>
続けたいけど続けられない…。そんな悩みを解決する、<br>
**「目標に向かって努力を継続できるサービス」** があれば、と考えて制作しました。

私自身、**仲間の存在**に助けられながら目標を達成してきました。<br>
また、**目標達成が次の結果を生み出す**ことを実感しています。
- TOEICで800点を目指そう、と友人を誘う → 進捗を共有し合って、お互いに達成! → 英語を使う仕事を任される！
- 朝活をしよう、と会社の同期を誘う → 毎日SNSで報告して朝活を継続、読書量アップ! → 仕事に還元！

その要因は、次のようなものだったと考えています。
- 宣言したことで「最後までやらなくては」、という良い緊張感が生まれる。
- 困ったところやつまずいたところを教え合ったり、悩みを相談できる。
- 仲間が頑張っている姿に励まされ、やる気を維持できる。
- 次第に、毎日取り組むのが習慣になる。

このアプリは、この状況を **オンラインで、手軽に** 実現しようとするものです。<br>
周囲に仲間を見つけられない、もっと多くの人と分かち合いたい、という人をサポートします。<br>

大変であっても、一歩ずつ進んでいる感覚が自己肯定感につながり、毎日がとても有意義に感じられるようになります。<br>
このアプリを通じて、 **「みんなが励まし合いながら、いきいきと暮らせる社会」を実現したい** と考えています。

## 使用言語
- Ruby 2.6.5
- Ruby on Rails 6.0.3
- HTML/CSS
- JavaScript
## 使用技術
- Git
- MySQL
- RSpec
- AWS (VPC/EC2/RDS/Route53/ALB/S3/ACM)
## ER図
![goal_share! ER](https://user-images.githubusercontent.com/70130536/100323013-6f4b2780-3008-11eb-95b6-2873ece04e1f.png)

## サービス構成図
![Goal Share! インフラ構成図](https://user-images.githubusercontent.com/70130536/100320556-ad464c80-3004-11eb-8a67-c9a4e3f8e8f3.png)

## 機能一覧
### 認証機能(device)
- 新規登録、ログイン、ログアウト
  - なまえ、Eメール、パスワードが必須
- その他、画像等の登録可能
- ゲストログイン
### タスク機能
- CRUD機能
- 完了へ切替が可能
### コミュニティ機能
- CRUD機能
- コミュニティへの登録(参加)が可能
### 質問機能
- CRUD機能(コミュニティに紐付く)
  - 「受付中」と「解決済み」を切替可能
  - 画像の添付が可能
### コメント機能
- 投稿された質問に対しコメント(回答)を投稿
### チャット機能
- テキストを投稿(コミュニティ下のチャットページにて)
### 検索機能
- ユーザー、コミュニティの検索
  - カテゴリ選択、フリーワード
### いいね機能
- タスクに対して：いいね!
- 質問に対して：知りたい!、役に立った!
### フォロー機能
- フォロー・フォロー解除
- フォロー・フォロワー一覧表示
### メッセージ機能
- 特定のユーザーとのチャット
## 今後の実装予定
- 非同期通信の活用
  - タスクの投稿、完了
  - 検索機能
- 双方向通信の活用
  - コミュニティ内、ユーザー間チャット
- レスポンシブ対応
- 使いたくなる仕掛け
  - タスク完了日に色が付くカレンダー
- サクサク使うためのSPA化
