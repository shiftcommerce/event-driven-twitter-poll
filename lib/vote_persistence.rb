require 'dalli'

module VotePersistence
  # increment vote count
  def self.increment(key)
    client.incr(key, 1, nil, 0)
  end

  # reads the count of votes for a given key
  def self.read(key)
    Integer(client.get(key) || 0)
  end

  def self.client
    @client ||= Dalli::Client.new(ENV.fetch('MEMCACHEDCLOUD_SERVERS'))
  rescue KeyError => ex
    raise RuntimeError, 'ERROR: MEMCACHEDCLOUD_SERVERS is missing, Memcache is not configured.'
  end
end
