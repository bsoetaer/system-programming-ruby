require_relative "Delay"

# Module to do actions after a set time delay.
module DelayedAction 
	# Execute block after seconds and nanoseconds delay.
	def self.delayed_action(sec, nsec)
		# TODO: Do this without fork somehow.
		child = fork do
			code = Delay.nanodelay(sec,nsec)
			unless code == Errno::NOERROR::Errno
				error_code code
			end
			yield 
		end
		Process.detach(child)
	end
	
	# Print message out after seconds and nanoseconds delay.
	def self.delayed_print(sec, nsec, msg)
		delayed_action(sec, nsec) { 
			puts msg
		}
	end
	
	# Raise appropriate error based on system integer code.
	private
	def self.error_code (code)
		error = Errno.constants.find{|i| Errno.const_get(i)::Errno == code}
		raise Errno.const_get(error)
	end
end
