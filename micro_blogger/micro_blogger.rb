require 'jumpstart_auth'
require 'bitly'

class MicroBlogger

  attr_reader :client

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
  end

  def run
    puts "Welcome to the JSL Twitter Client!"
    input = ""
    until input == "q"
      printf "Enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
      when 't'
        tweet(parts[1..-1].join(" "))
      when 'dm'
        dm(parts[1], parts[2..-1].join(" "))
      when 'spam'
        spam_my_followers(parts[1..-1].join(" "))
      when 'elt'
        everyones_last_tweet
      when 'turl'
        tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
      when 'q'
        puts "Goodbye!"
      else
        puts "Sorry, I don't know how to #{command}."
      end
    end
  end

  def tweet(message)
    if message.length <= 140
      @client.update(message)
      puts "Success!"
    else
      puts "Error: This tweet exceeds the 140-character limit!"
    end
  end

  def dm(target, message)
    puts "Trying to send #{target} this direct message:"
    puts message
    screen_names = followers_list
    if screen_names.include?(target)
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "Error: You can only DM people who follow you!"
    end
  end

  def followers_list
    screen_names = []
    @client.followers.each { |follower| screen_names << @client.user(follower).screen_name }
    screen_names
  end

  def spam_my_followers(message)
    followers_list.each { |follower| dm(follower, message) }
  end

  def everyones_last_tweet
    friends = @client.friends.sort_by {|friend| @client.user(friend).screen_name.downcase}
    friends.each do |friend|
      friend = @client.user(friend)
      last_message = friend.status.text
      timestamp = friend.status.created_at
      puts "This is #{friend.screen_name}'s last tweet from #{timestamp.strftime("%A, %b %d, %Y")}:"
      puts last_message
      puts ""
    end
  end

  def shorten(original_url)
    puts "Shortening this URL: #{original_url}"
    Bitly.use_api_version_3
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    bitly.shorten(original_url).short_url
  end

end

blogger = MicroBlogger.new
blogger.run