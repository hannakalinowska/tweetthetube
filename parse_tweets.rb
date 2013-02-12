#! /usr/bin/env ruby

require 'rubygems'
require 'json'

class Tweet
  attr_accessor :id, :created_at, :text

  LINE_NAMES = ["Metropolitan", "Hammersmith & City", "Jubilee", "Circle", "District", "Northern", "Victoria", "Central", "Piccadilly"]
  TYPES = ["Suspended", "Severe delays", "Minor delays"]

  def initialize(opts = {})
    @id = opts['id']
    @created_at = opts['created_at']
    @text = opts['text']
  end

  def line
    LINE_NAMES.find{|line_name| self.text =~ /#{line_name}/i}
  end

  def type
    TYPES.find{|type| self.text =~ /#{type}/i}
  end
end

f = File.open('data/parsed_tweets.csv', 'w')
f.puts %Q(Id,CreatedAt,Line,Type,Text)

(1 .. 21).each do |i|
  tweets = JSON.parse(File.read("data/tweets#{i}.json"))
  tweets.each do |t|
    tweet = Tweet.new(t)
    f.puts %Q(#{tweet.id},"#{tweet.created_at}","#{tweet.line}","#{tweet.type}","#{tweet.text.gsub('"', '\"')}")
  end
end

f.close
