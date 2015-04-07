$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../'))
require 'elementary'

unless RUBY_PLATFORM == 'java'
  begin
    require 'byebug'
  rescue LoadError
    puts "Could not load byebug"
    begin
      # Fall back and try to load the 1.9 debugger
      require 'debugger'
      require 'debugger/pry'
    rescue LoadError
      # Well, no debugger then
    end
  end
end

# Reequire all our generate test protos
Dir[File.expand_path(File.dirname(__FILE__) + '/support/**/*.pb.rb')].each do |f|
  require f
end
