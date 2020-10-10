# ruby 1.8.7 compatible
require 'rubygems'
require 'irb/completion'

begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError
  warn "Couldn't load awesome_print"
end

IRB.conf[:PROMPT_MODE] = :SIMPLE

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.local/share/irb/history')

class Object
  def own_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end

  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    system 'ri', method.to_s
  end
end

def cls
  system('clear')
  nil
end
