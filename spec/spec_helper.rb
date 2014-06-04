$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../'))
require 'elementary'


# Reequire all our generate test protos
Dir[File.expand_path(File.dirname(__FILE__) + '/support/**/*.pb.rb')].each do |f|
  require f
end
