class Service
  INSTANCE_POOL_SIZE = 100
  @@instance_pool = []

  def self.instance(**kwargs)
    existing_index = @@instance_pool[@@instance_pool.find_index { |instance| yield(instance) }]
    if existing_index
      @@instance_pool.insert(0, @@instance_pool.delete_at(existing_index))
      @@instance_pool[existing_index]
    else
      new_instance = new(**kwargs)
      @@instance_pool.unshift(new_instance)
      @@instance_pool.pop if @@instance_pool.length > INSTANCE_POOL_SIZE
      new_instance
    end
  end

  def initialize(**kwargs); end
end