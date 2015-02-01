require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing Microblogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length < 141
			@client.update(message)
		else
			puts "Your message is too long (140 characters max)."
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' then puts "Goodbye!"
				when 't' then tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join(" "))
				when 'elt' then everyones_last_tweet
				when 's' then shorten(url)
				else
					puts "Sorry, I don't know how to #{command}" 
			end
		end
	end

	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
		if screen_names.include?(target)
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "Sorry, you can only DM your followers."
		end
	end

	def followers_list
		screen_names = []
		@client.followers.each {|follower| screen_names << @client.user(follower).screen_name}
		screen_names
	end

	def spam_my_followers(message)
		followers_list.each {|follower| dm(follower, message)}
	end

	def everyones_last_tweet
		friends = []
		@client.followers.each {|follower| friends << @client.user(follower)}
		friends.sort_by {|friend| friend.screen_name.downcase}
		friends.each do |friend|
			timestamp = friend.status.created_at
			puts "#{friend.screen_name} said this on #{timestamp.strftime("%A, %b %d")}..."
			puts "#{friend.status.text}"
		end
	end

	def shorten(original_url)

		puts "Shortening this URL: #{original_url}"
	end

end

blogger = MicroBlogger.new
blogger.run