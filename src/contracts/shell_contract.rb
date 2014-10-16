require 'test/unit'
require_relative '../shell'

class ShellContract < Test::Unit::TestCase
	def test_execute_command
		# Setup
		shell_input_read, shell_input_write = IO.pipe()
		shell_output_read, shell_output_write = IO.pipe()
		shell = Shell.new(shell_input_read, shell_output_write)

		command = "ls -l"

		# Preconditions
		assert_match("", command, "Command was invalid") # TODO

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
