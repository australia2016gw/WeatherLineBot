# gemのインストール
　bundle install

＃環境変数
　■環境変数の設定方法
　　https://qiita.com/yuichir43705457/items/7cfcae6546876086b849
 
　■設定パラメータ
　　export LINE_CHANNEL_USER_ID='自身で作成したLINEアカウントのユーザID'
　　export LINE_CHANNEL_SECRET='自身で作成したLINEアカウントのシークレットキー'
　　export LINE_CHANNEL_TOKEN='自身で作成したLINEアカウントのトークンキー'

# PUSH配信タスクの実行
　rake push_line:push_line_message_morning
