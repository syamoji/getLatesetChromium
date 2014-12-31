# coding: utf-8
require 'openssl'
require 'open-uri'

latest_ver = 0
downloadUrl = "https://storage.googleapis.com/chromium-browser-continuous/"#+os_platform+"/"+latest_ver+"/chrome-win32.zip"
if os_platform = ARGV[0]
  if os_platform != 'Mac' && os_platform != 'Win'
    puts 'Usage: ruby getLatestChromium.rb [Mac|Win]'
    exit
  end
else
  puts 'Usage: ruby getLatestChromium.rb [Mac|Win]'
  exit
end

# 最新バージョンの取得
open(downloadUrl+""+os_platform+"/LAST_CHANGE") { |f|
  latest_ver = f.read
}
# 最新バージョンの表示
puts latest_ver

file_size = 0

# 保存ファイルの指定
open(os_platform+"-"+latest_ver+"-chromium.zip", "wb") {|saved_file|
  # ダウンロードアドレスの指定
  if os_platform == 'Win'
    downloadUrl = downloadUrl+""+os_platform+"/"+latest_ver+"/chrome-win32.zip"
  else
    downloadUrl = downloadUrl+""+os_platform+"/"+latest_ver+"/chrome-mac.zip"
  end
  open(downloadUrl,
       # ファイルサイズ取得オプション
       :content_length_proc => lambda {|content_length|
         file_size = content_length
       },
       # ダウンロードしたブロックごとのサイズ取得オプション
       :progress_proc => lambda {|size|
         print "downloaded: "+(size*100/file_size).to_s+"%\t"+size.to_s+"/"+file_size.to_s+"\r"
       }
      ) {|download_file|
    puts "Download"
    # ファイルを保存
    saved_file.write(download_file.read)
  }
}


