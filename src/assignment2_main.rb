# Group 4 members: Isaac Supeene, Braeden Soetaert
# Read compile.txt for steps to compile on lab machines.

require_relative "shell" 
require_relative "delayed_action"
require_relative "file_tracker"

#####################
# Exercise 1: Shell #
#####################
shell_input_read, shell_input_write = IO.pipe()
shell_output_read, shell_output_write = IO.pipe()
shell = Shell421.new(shell_input_read, shell_output_write)
shell_input_write.write("echo \"BOBBY\" \n")
sleep 1
# Should output "BOBBY"
puts shell_output_read.readline
shell.close

###########################
# Exercise 2: Timed Print #
###########################
sec = 2
nsec = 500
# Should print "Delayed Message." after 2 sec and 500 nanoseconds.
DelayedAction.delayed_print(sec, nsec, "Delayed Message.")

############################
# Exercise 3: File Tracker #
############################
duration = 3
watch_create = ["demoTest1.rb", "demoTest1.txt"]
watch_alter = ["demoTest2.rb", "demoTest2.txt"]
watch_delete = ["demoTest3.rb", "demoTest3.txt"]
`touch #{watch_alter[0]}`
`touch #{watch_alter[1]}`
`touch #{watch_delete[0]}`
`touch #{watch_delete[1]}`
sleep 1
FileTracker.FileWatchCreation(watch_create, duration) do |f|
	puts "File #{f} was created."
end
FileTracker.FileWatchAlter(watch_alter, duration) do |f|
	puts "File #{f} was alterred."
end
FileTracker.FileWatchDelete(watch_delete, duration) do |f|
	puts "File #{f} was deleted."
end
sleep 1
`touch #{watch_create[0]}` # Trigger creation. Creation message sgould be printed after 3 seconds.
`touch #{watch_alter[0]}` # Trigger alter. Alter message sgould be printed after 3 seconds.
`rm #{watch_delete[0]}` # Trigger delete. Deletion message sgould be printed after 3 seconds.
sleep 5

###########
# Cleanup #
###########
`rm #{watch_delete[1]}`
`rm #{watch_alter[0]}`
`rm #{watch_alter[1]}`
`rm #{watch_create[0]}`