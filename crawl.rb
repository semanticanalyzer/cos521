require 'twitter'
require 'pp'
require 'json'

$lang = "en"

def storeTweets(tweets, suffix)
 open($lang + "_" + suffix + ".json", "a") do |f|
 	tweets.each do |tweet|
		json = JSON.dump tweet.to_h
		puts json
 		f.puts(json)
 	end
 end
end

def initClient()

 client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "<consumer_key"
  config.consumer_secret     = "<consumer_secret>"
  config.access_token        = "<optional_access_token>"
  config.access_token_secret = "<optional_access_token_secret>"
 end

 client
end

def crawlAndStore(client, twitterQuery)
 tweets = client.search(twitterQuery, lang: $lang)
 suffix = twitterQuery.gsub(" ", "_")
 storeTweets(tweets, suffix)

 10.times do
   #pp tweets.attrs[:search_metadata].inspect
   #pp tweets.inspect

   since_id = tweets.attrs[:search_metadata][:refresh_url].scan(/since_id=\d+/).first.gsub("since_id=", "")
   puts since_id.to_s

   tweets = client.search(twitterQuery, lang: $lang, since_id: since_id)
   storeTweets(tweets, suffix)
 end
end

if ARGV.length == 0
   puts 'Usage: ruby crawl.rb <keyword>'
   exit
end


client = initClient()
crawlAndStore(client, ARGV[0])
