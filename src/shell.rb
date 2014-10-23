require 'shell'

class Shell421 < Shell
	DOUBLE_QUOTED_WORD = /"[^"\n[[:cntrl:]]]*"/
	SINGLE_QUOTED_WORD = /'[^'\n[[:cntrl:]]]*'/
	PLAIN_WORD = /[\w\.\/-]+/
	WORD = /#{PLAIN_WORD}|#{DOUBLE_QUOTED_WORD}|#{SINGLE_QUOTED_WORD}/
	VALID_COMMAND = /^ *(#{WORD})(( +#{WORD})*)$/

	def initialize(input_pipe, output_pipe)
		super()
		Thread.new(self) do |shell|
			loop do
				begin
					input = input_pipe.readline.strip
					next if input =~ /^\s*$/
					raise Exception unless input =~ VALID_COMMAND

					command, args = split(input)
					if respond_to?(command)
						puts("#{command}, #{args}")
						output_pipe.write(send(command, *args).to_s + "\n")
					else
						fork {
							exec(command, *args, {:in => input_pipe, :out => output_pipe})
						}
					end
				rescue EOFError
					break
				rescue Exception
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
		return command, args
	end
end

