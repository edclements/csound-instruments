#!/usr/bin/ruby

require 'io/wait'
require 'open3'
require 'celluloid'


class Csound
  include Celluloid

  def start
    csd = "/home/ed/csound/fm/fmbell.csd"
    Open3.popen3("csound #{csd}") do |stdin, stdout, stderr, wait_thr|
      @pid = wait_thr[:pid]
      puts stdout.read
      puts stderr.read
    end
  end

  def stop
    Process.kill 'INT', @pid
  end
end

class Reader
  include Celluloid

  def initialize
  end

  def start
    @csound = Csound.new
    @csound.async.start
  end

  def get_input
    input = ''
    while input != 'quit' do
      input = $stdin.readline.strip
      if input == 'stop'
        @csound.terminate
      end
    end
  end
end

# Open3.popen3("csound #{csd}") do |stdin, stdout, stderr, wait_thr|

#   input = ""
#   while input != "quit" do
#     if $stdin.ready?
#       input = $stdin.readline.strip
#       puts "|| #{input} ||"
#     end
#   end
#   puts "quit"
#   unless stderr.eof?
#     Process.kill 'INT', wait_thr.pid
#     exit
#   else
#     puts "EOF"
#   end

# end

# stdin.close  # stdin, stdout and stderr should be closed explicitly in this form.
# stdout.close
# stderr.close
# exit_status = wait_thr.value  # Process::Status object returned.
# csound = IO.popen("csound #{csd}")
# puts csound.gets
# csound.kill
# Process.kill 'INT', pid
