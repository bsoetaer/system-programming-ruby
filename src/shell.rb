require 'shell'

class Array
	def self.unfold_from(seed, &block)
		value, seed = yield seed
		return seed ? [value, *unfold_from(seed, &block)] : [value]
	end
end

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

					command, *args = split(input)
					if respond_to?(command)
						output_pipe.write(public_send(command, *args).to_s + "\n")
					else
						Shell.undef_system_command("temp_command") if respond_to?("temp_command")
						Shell.def_system_command("temp_command", command)
						output_pipe.write(temp_command(*args))
					end
				rescue EOFError
					break
				rescue Exception => e
					puts e
					puts "error" # TODO: Error handling
				end
			end
			input_pipe.close
			output_pipe.close
		end
	end

	private
	def split(input)
		Array.unfold_from(input) { |seed|
			VALID_COMMAND.match(seed)[1..2].select{ |x| x !~ /^\s*$/ }
		}
	end
end

