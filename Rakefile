# ENV["DB"] is used by standalone migrations during rake tasks. This is
# a way of allowing us to just specify environment once in APP_ENV.
ENV['DB'] = ENV.fetch('RACK_ENV', 'development')

unless ENV['DB'] == 'production'
  require 'dotenv/load'
end

require 'standalone_migrations'
require_relative 'config/active_record'

StandaloneMigrations::Tasks.load_tasks

desc "Replay the stream"
task :replay do

  require_relative 'models/candidate'
  require_relative 'models/archived_message'
  require_relative 'lib/consumer/message_archiver'
  require_relative 'lib/event_stream'

  # reset the candidates
  Candidate.delete_all

  # don't re-archive messages
  EventStream.exclude(Consumer::MessageArchiver)
  EventStream.replaying = true

  # load 50 messages to be processed at a time
  batch_size = 50

  # find all the topics
  ArchivedMessage.pluck('distinct topic').each do |topic|
    # find all the partitions within this topic
    ArchivedMessage.where(topic: topic).pluck('distinct partition').each do |partition|
      last_offset = -1
      while true do
        # find our batch
        results = ArchivedMessage.where(topic: topic, partition: partition).
                    where("#{ArchivedMessage.quoted_table_name}.offset > ?", last_offset + 1).
                    order("#{ArchivedMessage.quoted_table_name}.offset asc").limit(batch_size)
        # if none exist, this is the end of the stream for this topic/partition combo
        break if results.empty?
        # loop through each message
        results.each do |message|
          puts "Replaying message #{topic}/#{partition}/#{message.offset}: #{message.value}"
          # execute the message
          EventStream.execute(message)
          # store the offset of this message
          last_offset = message.offset
          sleep(0.5)
        end
      end
    end
  end

end

desc 'Reset votes'
task :reset_votes do
  require_relative 'models/candidate'

  # reset the candidates
  Candidate.delete_all
end
