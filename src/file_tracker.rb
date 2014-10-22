require 'pathname'

module FileTracker
	class Tracker
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

		def trigger
			Thread.new {
				sleep(@timeout) # TODO: Use precise sleep from part 2.
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

	def FileWatchCreation(*args, &block)
		FileWatch(CreationTracker, *args, &block)
	end

	def FileWatchAlter(*args, &block)
		FileWatch(ModificationTracker, *args, &block)
	end

	def FileWatchDestroy(*args, &block)
		FileWatch(DeletionTracker, *args, &block)
	end

	private
	def FileWatch(type, filenames, duration=0, &block)
		@@mutex.synchronize {
			filenames.each{ |f| @@trackers << type.new(Pathname.new(f), duration, &block) }
		}
	end

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

