require 'test/unit'
require_relative '../timed_printout'

class TimedPrintoutContract < Test::Unit::TestCase
	include TimedPrintout
	
	def test_print_after
		# Setup
		msg = "Test timed printout."
		time_delay_seconds = 3
		time_delay_nano = 50
		time_before = Time.new
		
		# Preconditions
		assert( time_delay_seconds >= 0, "Time Delay in seconds must be greater than 0.")
		assert( 
			time_delay_nano >= 0 && time_delay_nano <= 999999999,
			"Time Delay in nanoseconds must be in the range of 0 to 999999999"
		)
		
		# Function
		time_before = Time.new
		TimedPrintout.print_after(time_delay_seconds, time_delay_nano, msg)
		time_after = Time.new
		
		# Postconditions
		assert(time_after - time_before < 3.000000050, "Timed printout is blocking.")
		# TODO sleep and find way to check system out
	end
end