class Service
  INSTANCE_POOL_SIZE = 100
  @@instance_pool = []

  def self.instance(**kwargs)
    existing_instance = @@instance_pool.find { |instance| yield(instance, kwargs) }
    if existing_instance
      existing_instance
    else
      new_instance = new(**kwargs)
      @@instance_pool << new_instance
      @@instance_pool.pop if @@instance_pool.length > INSTANCE_POOL_SIZE
      new_instance
    end
  end

  def initialize(**kwargs); end
end