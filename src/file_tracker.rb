require 'pathname'

module FileTracker
	class Tracker
		# Sets up the state of the tracked files.
		def initialize(filename, timeout, &block)
			@filename = filename
			@timeout = timeout
			@block = block

			@exist_now = @exist_before = filename.exist?
			begin
				@mod_time_now = @mod_time_before = filename.mtime
			rescue
				@mod_time_now = @mod_time_before = 0
			end
		end

		# Updates the known state of the tracked files.
		def update
			@exist_before = @exist_now
			@exist_now = filename.exist?

			begin
				@mod_time_before = @mod_time_now
				@mod_time_now = filename.mtime
			rescue
				@mod_time_now = @mod_time_before = 0
			end
		end

		# Triggers this trackers' action.
		def trigger
			Thread.new {
				# NOTE: Not using precise sleep from part 2,
				# due to ruby threading issues.
				sleep(@timeout)
				@block.call(@filename.to_s)
			}
		end

		attr_reader :filename
		attr_reader :timeout

		private
		attr_reader :exist_before
		attr_reader :exist_now
		attr_reader :mod_time_before
		attr_reader :mod_time_now
	end

	# Subclasses of tracker with specialized trigger criteria.
	class CreationTracker < Tracker
		def trigger?
			!exist_before && exist_now
		end
	end

	class ModificationTracker < Tracker
		def trigger?
			exist_before && exist_now && mod_time_before < mod_time_now
		end
	end

	class DeletionTracker < Tracker
		def trigger?
			exist_before && !exist_now
		end
	end

	@@trackers = []
	@@mutex = Mutex.new

	# Sets up a creation tracker for the specified files,
	# with the specified action and delay.
	def FileWatchCreation(*args, &block)
		FileWatch(CreationTracker, *args, &block)
	end

	# Sets up a modification tracker for the specified files,
	# with the specified action and delay.
	def FileWatchAlter(*args, &block)
		FileWatch(ModificationTracker, *args, &block)
	end

	# Sets up a deletion tracker for the specified files,
	# with the specified action and delay.
	def FileWatchDestroy(*args, &block)
		FileWatch(DeletionTracker, *args, &block)
	end

	private
	# Common file watch implementation.
	def FileWatch(type, filenames, duration=0, &block)
		@@mutex.synchronize {
			filenames.each{ |f| @@trackers << type.new(Pathname.new(f), duration, &block) }
		}
	end

	# Set up a new thread to poll all the files and update the trackers.
	Thread.new {
		loop do
			sleep(1)
			@@mutex.synchronize {
				@@trackers.each{ |t| t.update }
				@@trackers.select{ |t| t.trigger? }.each{ |t| t.trigger }
			}
		end
	}
end

