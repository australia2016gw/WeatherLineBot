namespace :push_line do 
  desc "push_line"
  task push_line_message_morning: :environment do # 以下にpush機能のタスクを書く。
  
    require 'kconv'
    require 'open-uri'
    require 'rexml/document'
    require 'active_support'
    require 'active_support/core_ext'
    require 'date'
  
    # デバッグ用
    #p ENV["LINE_CHANNEL_SECRET"]
    #p ENV["LINE_CHANNEL_TOKEN"]
    #p ENV["LINE_CHANNEL_USER_ID"]
    
    # お天気サイトからxml形式で気象情報を取得してくる
    url= "https://www.drk7.jp/weather/xml/11.xml"
    xml  = open( url ).read.toutf8
    
    # xmlをハッシュに変換
    hash = Hash.from_xml(xml)
    
    # 気象情報を変数に代入
    RAIN_FALL_CHANCE_MORNING = hash["weatherforecast"]["pref"]["area"][1]["info"][0]["rainfallchance"]["period"][1].to_i
    RAIN_FALL_CHANCE_AFTERNOON = hash["weatherforecast"]["pref"]["area"][1]["info"][0]["rainfallchance"]["period"][2].to_i
    RAIN_FALL_CHANCE_NIGHT = hash["weatherforecast"]["pref"]["area"][1]["info"][0]["rainfallchance"]["period"][3].to_i
    MAX_TEMP = hash["weatherforecast"]["pref"]["area"][1]["info"][0]["temperature"]["range"][0].to_i
    MIN_TEMP = hash["weatherforecast"]["pref"]["area"][1]["info"][0]["temperature"]["range"][1].to_i
    WEATHER = hash["weatherforecast"]["pref"]["area"][1]["info"][0]["weather"]
    
    # 変数値確認用
    #p RAIN_FALL_CHANCE_MORNING
    #p RAIN_FALL_CHANCE_AFTERNOON
    #p RAIN_FALL_CHANCE_NIGHT
    #p MAX_TEMP
    #p MIN_TEMP
    #p WEATHER
    
    # PUSH通知文言を作成
    if RAIN_FALL_CHANCE_MORNING >= 70
      rain = "朝から雨が降るでしょう\u{2614}\n傘を持ち歩きましょう。"
      break
    elseif RAIN_FALL_CHANCE_AFTERNOON >= 70
      rain = "昼から雨が降るでしょう\u{2614}\n傘を持ち歩きましょう。"
      break
    elseif RAIN_FALL_CHANCE_NIGHT >= 70
      rain = "夜から雨が降るでしょう\u{2614}\n帰りが遅くなる場合は傘を持ち歩きましょう。"
      break
    else
      rain = "雨は降らないでしょう\u{1F324}\n傘は不要です。"
    end
    
    #d = Date.today
    date = Date.today.strftime("%Y年%m月%d日")
    #p date
    push = "===  #{date}  ===\n\n【気象情報】\n天気\u{1F300}：#{WEATHER}\n気温\u{1F321}：#{MAX_TEMP}℃/#{MIN_TEMP}℃\n\n【ひとこと】\n#{rain}"
    
    # LINEに通知するメッセージを作成
    message =[{
      type: 'text',
      text: push ,
#      emojis:[
#      {
#        "index": 66,
#        "productId": "5ac1bfd5040ab15980c9b435",
#        "emojiId": "002"
#      }]
    },{
      type: "sticker",
      packageId: "8515",
      stickerId: "16581260"
    }]
    
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    
    # LINEにPUSH通知を配信
    #response = client.push_message(ENV["LINE_CHANNEL_USER_ID"], message)
    response = client.broadcast(message)
    p response
  end
end