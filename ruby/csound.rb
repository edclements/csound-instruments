#!/usr/bin/ruby

require './ruby_csound'
require 'io/wait'

puts "=== csound new ==="
cs = Csound.new
result = cs.compile()
stop = false
# pid1 = fork do
#   while !stop do
#     cs.performKsmps()
#   end
# end
pid2 = fork do
  input = ""
  while input != "quit" do
    if $stdin.ready?
      input = $stdin.readline.strip
      puts "stdin: #{input}"
      $stdout.flush
    # input = STDIN.gets
    end
  end
  cs.stop()
  # cs.destroy()
end
cs.perform()
Process.wait pid2
# Process.kill 9, pid1
# stop = true
# cs.stop()
# cs.destroy()
