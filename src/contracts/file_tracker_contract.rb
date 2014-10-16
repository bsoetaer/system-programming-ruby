require 'test/unit'
require_relative '../file_tracker'

class FileTrackerContract < Test::Unit::TestCase
	include FileTracker
	
	def test_file_watch_creation
		# Setup
		output = []
		duration = 2.5
		file_list = ["testfile1.txt", "testfile1.rb"]
		file_list.each{|f| 
			assert(
				!File.exist?(f), 
				"Environment incorrect for testing file watch creation.\n" \
				"File: #{f} already exists."
			)
		}
		
		# Preconditions
		assert( duration >= 0, "Time Delay in seconds must be greater than 0.")
		assert( file_list.length >= 1, "Must supply at least 1 file in the file list.")
		
		# Function
		FileTracker.FileWatchCreation(duration, file_list) {{|f| output.push(f)}}
		File.new(file_list[0], "r")
		File.new(file_list[1], "w")
		File.delete(file_list[0])
		File.new(file_list[0], "r")
		
		# Postconditions
		assert(output.empty?, "File watch creation not delaying long enough.")
		sleep 3
		assert_equal(
			output, [file_list[0], file_list[1], file_list[0]],
			"Action not properly being called for file watch creation."
		)
		
		# Cleanup
		File.delete(file_list[0], file_list[1])
	end
	
	def test_file_watch_alter
		# Setup
		output = []
		duration = 2.5
		file_list = ["testfile2.txt", "testfile2.rb"]
		file_list.each{|f| 
			assert(
				!File.exist?(f), 
				"Environment incorrect for testing file watch alter.\n" \
				"File: #{f} already exists."
			)
			File.new(f, "w")
		}
		
		# Preconditions
		assert( duration >= 0, "Time Delay in seconds must be greater than 0.")
		assert( file_list.length >= 1, "Must supply at least 1 file in the file list.")
		
		# Function
		FileTracker.FileWatchAlter(duration, file_list) {{|f| output.push(f)}}
		File.open(file_list[0], 'a') do |f|
	        	f.write "test"
		end
		File.open(file_list[1], 'a') do |f|
	        	f.write "test"
		end
		File.open(file_list[0], 'a') do |f|
			f.write "test2"
		end
		
		# Postconditions
		assert(output.empty?, "File watch alter not delaying long enough.")
		sleep 3
		assert_equal(
			output, [file_list[0], file_list[1], file_list[0]],
			"Action not properly being called for file watch alter."
		)
		
		# Cleanup
		File.delete(file_list[0], file_list[1])
		
	end
	
	def test_file_watch_destroy
		# Setup
		output = []
		duration = 2.5
		file_list = ["testfile3.txt", "testfile3.rb"]
		file_list.each{|f| 
			assert(
				!File.exist?(f), 
				"Environment incorrect for testing file watch alter.\n" \
				"File: #{f} already exists."
			)
			File.new(f, "w")
		}
		
		# Preconditions
		assert( duration >= 0, "Time Delay in seconds must be greater than 0.")
		assert( file_list.length >= 1, "Must supply at least 1 file in the file list.")
		
		# Function
		FileTracker.FileWatchDestroy(duration, file_list) {{|f| output.push(f)}}
		File.delete(file_list[0])
		File.delete(file_list[1])
		File.new(file_list[0], "w")
		File.delete(file_list[0])
		
		# Postconditions
		assert(output.empty?, "File watch destroy not delaying long enough.")
		sleep 3
		assert_equal(
			output, [file_list[0], file_list[1], file_list[0]],
			"Action not properly being called for file watch destroy."
		)
		
		# Cleanup
		File.delete(file_list[0], file_list[1])
	end
end
