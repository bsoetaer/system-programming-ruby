require_relative "delayed_action"

puts "Time delay before printout message:"
delay = gets.to_f
unless delay.is_a?(Numeric)
	puts "#{delay} is not a valid time delay."
end
sec, nsec = delay.divmod 1
nsec = (nsec * 10**9).to_i
puts "Message to print out:"
msg = gets.strip
DelayedAction.delayed_print sec, nsec, msg