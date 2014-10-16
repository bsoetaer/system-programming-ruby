require 'test/unit'
require_relative '../shell'

class ShellContract < Test::Unit::TestCase
	# Extremely simple definition of valid command.
	DOUBLE_QUOTED_WORD = /"[^"\n[[:cntrl:]]]*"/
	SINGLE_QUOTED_WORD = /'[^'\n[[:cntrl:]]]*'/
	PLAIN_WORD = /[\w-]*/
	WORD = /#{PLAIN_WORD}|#{DOUBLE_QUOTED_WORD}|#{SINGLE_QUOTED_WORD}/
	VALID_COMMAND = /^ *#{WORD}( +#{WORD})*$/

	def test_execute_command
		# Setup
		shell_input_read, shell_input_write = IO.pipe()
		shell_output_read, shell_output_write = IO.pipe()
		shell = Shell.new(shell_input_read, shell_output_write)

		command = "ls -l"

		# Preconditions
		assert_match(VALID_COMMAND, command, "Command was invalid")

		# Function
		shell_input_write.write(command)
		shell_input_write.close

		# Postconditions
		assert_equal(`#{command}`, shell_output_read.read)

		# Cleanup
		shell_output_read.close
		shell.close
	end
end
