# Group 4 members: Isaac Supeene, Braeden Soetaert

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
puts shell_output_read.readline
shell.close

###########################
# Exercise 2: Timed Print #
###########################
sec = 2
nsec = 500
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
`touch #{watch_create[0]}` # Trigger creation
`touch #{watch_alter[0]}` # Trigger alter
`rm #{watch_delete[0]}` # Trigger delete
sleep 5