require 'test/unit'
require_relative '../file_tracker'

class FileTrackerContract < Test::Unit::TestCase
	include FileTracker

	def test_file_watch_creation
		# Setup
		output = []
		duration = 3
		file_list = ["testfile1.txt", "testfile1.rb"]
		file_list.each{ |f| File.delete(f) if File.exist?(f) }
		sleep 1
		
		# Preconditions
		assert( duration >= 0, "Time Delay in seconds must be greater than 0.")
		assert( file_list.length >= 1, "Must supply at least 1 file in the file list.")
		
		# Function
		FileWatchCreation(file_list, duration){ |f| output.push(f) }
		`touch #{file_list[0]}`
		`touch #{file_list[1]}`
		sleep 1
		`rm #{file_list[0]}`
		sleep 1
		`touch #{file_list[0]}`
		
		# Postconditions
		assert(output.empty?, "File watch creation not delaying long enough.")
		sleep 4
		assert_equal(
			[file_list[0], file_list[1], file_list[0]], output,
			"Action not properly being called for file watch creation."
		)
		
		# Cleanup
		file_list.each{ |f| File.delete(f) if File.exist?(f) }
	end
	
	def test_file_watch_alter
		# Setup
		output = []
		duration = 3
		file_list = ["testfile2.txt", "testfile2.rb"]
		file_list.each{ |f| File.delete(f) if File.exist?(f) }
		sleep 1

		# Preconditions
		assert( duration >= 0, "Time Delay in seconds must be greater than 0.")
		assert( file_list.length >= 1, "Must supply at least 1 file in the file list.")
		
		# Function
		FileWatchAlter(file_list, duration) {|f| output.push(f)}
		`touch #{file_list[0]}`
		`touch #{file_list[1]}`
		sleep 1
		`touch #{file_list[0]}`
		`touch #{file_list[1]}`
		sleep 1
		`touch #{file_list[0]}`
		
		# Postconditions
		assert(output.empty?, "File watch alter not delaying long enough.")
		sleep 4
		assert_equal(
			[file_list[0], file_list[1], file_list[0]], output,
			"Action not properly being called for file watch alter."
		)
		
		# Cleanup
		file_list.each{ |f| File.delete(f) if File.exist?(f) }
	end
	
	def test_file_watch_destroy
		# Setup
		output = []
		duration = 3
		file_list = ["testfile3.txt", "testfile3.rb"]
		file_list.each{ |f| File.new(f, "w") }
		sleep 1
		
		# Preconditions
		assert( duration >= 0, "Time Delay in seconds must be greater than 0.")
		assert( file_list.length >= 1, "Must supply at least 1 file in the file list.")
		
		# Function
		FileWatchDestroy(file_list, duration) {|f| output.push(f)}
		File.delete(file_list[0])
		File.delete(file_list[1])
		sleep 1
		File.new(file_list[0], "w")
		sleep 1
		File.delete(file_list[0])
		
		# Postconditions
		assert(output.empty?, "File watch destroy not delaying long enough.")
		sleep 4
		assert_equal(
			[file_list[0], file_list[1], file_list[0]], output,
			"Action not properly being called for file watch destroy."
		)
		
		# Cleanup
		file_list.each{ |f| File.delete(f) if File.exist?(f) }
	end
end
