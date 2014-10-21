require 'test/unit'
require_relative '../shell'

class ShellContract < Test::Unit::TestCase
	def test_execute_command
		# Setup
		shell_input_read, shell_input_write = IO.pipe()
		shell_output_read, shell_output_write = IO.pipe()
		shell = Shell421.new(shell_input_read, shell_output_write)

		command = "ls -l"

		# Preconditions
		assert_match(Shell421::VALID_COMMAND, command, "Command was invalid")

		# Function
		shell_input_write.write(command)
		shell_input_write.close

		# Postconditions
		assert_equal(`#{command}`, shell_output_read.readlines.join(""))

		# Cleanup
		shell_output_read.close
	end
end
