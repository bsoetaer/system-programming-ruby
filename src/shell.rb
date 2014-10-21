require 'shell'
require 'thread'
require 'pathname'

class Shell421 < Shell
	DOUBLE_QUOTED_WORD = /"[^"\n[[:cntrl:]]]*"/
	SINGLE_QUOTED_WORD = /'[^'\n[[:cntrl:]]]*'/
	PLAIN_WORD = /[\w-]*/
	WORD = /#{PLAIN_WORD}|#{DOUBLE_QUOTED_WORD}|#{SINGLE_QUOTED_WORD}/
	VALID_COMMAND = /^ *(#{WORD})(( +#{WORD})*)$/

	def initialize(input_pipe, output_pipe)
		super()
		Thread.new(self) do |shell|
			loop do
				begin
					input = input_pipe.readline
					command, args = split(input)
					def_command(command)

					output_pipe.write(Thread.new(shell) { |shell|
						shell.send(command.basename.to_s, *args)
					}.value)
				rescue EOFError
					break
				rescue
					puts "error" # TODO: Error handling
				end
			end
			input_pipe.close
			output_pipe.close
		end
	end

	private
	def split(input)
		command = VALID_COMMAND.match(input)[1]
		input = VALID_COMMAND.match(input)[2]
		args = []
		while input.length > 0
			args << VALID_COMMAND.match(input)[1]
			input = VALID_COMMAND.match(input)[2]
		end
		return Pathname.new(command), args
	end

	def def_command(command)
		begin
			Shell::undef_system_command(command.basename)
		rescue
		end
		begin
		unless respond_to?(command.basename.to_s)
			Shell::def_system_command(command.basename, command)
		end
		rescue => ex
			puts ex
			raise ex
		end
	end
end
