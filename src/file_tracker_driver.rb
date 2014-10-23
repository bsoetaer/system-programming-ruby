require_relative 'file_tracker'
include FileTracker

puts("files to watch creation of: ")
files = gets.strip.split

puts("delay: ")
delay = gets.to_f

FileWatchCreation(files, delay) { |f|
	puts("#{f} was created")
}

puts("files to watch deletion of: ")
files = gets.strip.split

puts("delay: ")
delay = gets.to_f

FileWatchDestroy(files, delay) { |f|
	puts("#{f} was deleted")
}

puts("files to watch modification of: ")
files = gets.strip.split

puts("delay: ")
delay = gets.to_f

FileWatchAlter(files, delay) { |f|
	puts("#{f} was modified")
}

sleep
