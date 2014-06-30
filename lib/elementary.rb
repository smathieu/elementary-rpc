module Elementary

  def self.disable_concurrency!
    @synchronous = true
  end

  def self.enable_concurrency!
    @synchronous = false
  end

  def self.synchronous?
    !!@synchronous
  end

  def self.middleware
    @middleware ||= []
  end

  def self.use(klass, opts={})
    if klass.nil?
      raise ArgumentError, "Cannot add a nil middleware"
    end
    self.middleware << [klass, opts]
    return true
  end

  def self.flush_middleware
    @middleware = []
  end
end

require 'elementary/version'
require 'elementary/connection'
require 'elementary/middleware'
