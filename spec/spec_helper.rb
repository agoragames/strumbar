$:.push File.join(File.dirname(__FILE__), '..', 'lib')

# fake a Rails implementation detail
class Module
  def attr_internal name
    attr_accessor name
  end
end

require 'strumbar'
