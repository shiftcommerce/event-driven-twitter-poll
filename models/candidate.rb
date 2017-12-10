require_relative '../config/active_record'

class Candidate < ActiveRecord::Base
  self.primary_key = 'key'

  def self.increment_vote_for(key)
    connection.execute <<-SQL
      insert into #{quoted_table_name} as c (key, vote_count) values ('#{key}', 1)
      on conflict (key) do
      update set vote_count = c.vote_count + 1 where c.key = EXCLUDED.key
    SQL
  end

  def self.votes_for(key)
    where(key: key).pluck(:vote_count).first || 0
  end
end
