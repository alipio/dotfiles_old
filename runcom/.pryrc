Pry.editor = ENV['EDITOR'] || 'subl -n -w'
Pry.config.pager = false

# shorthands for the stepping commands
if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

Pry.config.history_file = "~/.local/share/pry/history"

# Hit Enter to repeat last command
Pry::Commands.command /^$/, 'repeat last command' do
  pry_instance.run_command Pry.history.to_a.last
end

# Custom prompt
Pry.config.prompt = Pry::Prompt.new(
  'custom',
  'custom prompt',
  [
    proc { |obj, nest_level, _| "(#{Pry.config.prompt_name}) ❯❯ " },
    proc { |obj, nest_level, _| "(#{Pry.config.prompt_name}) *❯ " }
  ]
)

# Listing config
# Better colors - by default the headings for methods are too
# similar to method name colors leading to a "soup"
# These colors are optimized for use with Solarized scheme
# for your terminal
# Pry.config.ls.separator = "\n" # new lines between methods
# Pry.config.ls.heading_color = :magenta
# Pry.config.ls.public_method_color = :green
# Pry.config.ls.protected_method_color = :yellow
# Pry.config.ls.private_method_color = :bright_black

# Defaults for above config
#============================
# heading_color = :bright_blue,
# public_method_color = :default,
# private_method_color = :blue,
# protected_method_color = :blue,
# method_missing_color = :bright_red,
# local_var_color = :yellow,
# pry_var_color = :default, # e.g. _, pry_instance, _file_
# instance_var_color = :blue, # e.g. @foo
# class_var_color = :bright_blue, # e.g. @@foo
# global_var_color = :default, # e.g. $CODERAY_DEBUG, $eventmachine_library
# builtin_global_color = :cyan, # e.g. $stdin, $-w, $PID
# pseudo_global_color = :cyan, # e.g. $~, $1..$9, $LAST_MATCH_INFO
# constant_color = :default, # e.g. VERSION, ARGF
# class_constant_color = :blue, # e.g. Object, Kernel
# exception_constant_color = :magenta, # e.g. Exception, RuntimeError
# unloaded_constant_color = :yellow, # Any constant that is still in .autoload? state
# separator = "  "

# Plugins
# awesome_print gem: great syntax colorized printing
begin
  require 'awesome_print'
  # Enables Awesome Print and auto paging for all Pry output.
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }

  # If you want awesome_print without automatic pagination, use the line below
  # Pry.config.print = proc { |output, value| output.puts value.ai }
rescue LoadError
  puts 'no awesome_print :('
end

# Custom commands
# from: https://gist.github.com/1297510
default_command_set = Pry::CommandSet.new do
  command 'clipcp', 'Copy input to the clipboard. If input is not specified, the default is the last result.' do |input|
    input = input ? target.eval(input) : _pry_.last_result
    IO.popen('pbcopy', 'w') { |f| f << input.to_s }
  end

  command 'cls' do
    system 'clear'
    output.puts "Rails Environment: #{ENV['RAILS_ENV']}" if ENV['RAILS_ENV']
  end

  command 'sql', 'Send SQL over ActiveRecord.' do |query|
    if ENV['RAILS_ENV'] || defined?(Rails)
      pp ActiveRecord::Base.connection.select_all(query)
    else
      pp 'No rails env defined'
    end
  end

  command 'caller-method' do |depth|
    depth = depth.to_i || 1
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth + 1).first
      file = Regexp.last_match[1]
      line = Regexp.last_match[2].to_i
      method = Regexp.last_match[3]
      output.puts [file, line, method]
    end
  end
end

Pry.config.commands.import default_command_set

# Extensions
# Generate populated arrays and hashes.
# https://gist.github.com/807492
class Array
  def self.toy(n=10, &block)
    block_given? ? Array.new(n, &block) : Array.new(n) {|i| i + 1}
  end
end

class Hash
  def self.toy(n=10)
    Hash[Array.toy(n).zip(Array.toy(n) {|c| (96 + ( c + 1)).chr})]
  end
end
