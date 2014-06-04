# Include all our built in middlewares
Dir[File.expand_path(File.dirname(__FILE__) + '/**/*.rb')].each do |f|
  require f
end
