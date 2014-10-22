require_relative "Delay"

module DelayedAction 
	def self.delayed_action(sec, nsec, *args)
		# TODO: Do this without fork somehow.
		child = fork do
			code = Delay.nanodelay(sec,nsec)
			unless code == Errno::NOERROR::Errno
				error_code code
			end
			yield *args
		end
		Process.detach(child)
	end
	
	def self.delayed_print(sec, nsec, msg)
		delayed_action(sec, nsec, msg) { |m|
			puts m
		}
	end
	
	private
	def self.error_code (code)
		# TODO: Figure out how to change a number into an Errno class
		#Errno.constants.select{|i| Errno::i::Errno == code}.each{|i| puts i}
	end
end
