require_relative "shell"

# Use ctrl-D to send an EOF to close the shell.
Shell421.new(STDIN, STDOUT).join

