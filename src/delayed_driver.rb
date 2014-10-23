require_relative "delayed_action"

puts "Time delay before printout message:"
delay = gets.to_f
sec, nsec = delay.divmod 1
nsec = (nsec * 10**9).to_i
puts "Message to print out:"
msg = gets.strip
DelayedAction.delayed_print sec, nsec, msg