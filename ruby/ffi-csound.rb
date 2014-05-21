#!/usr/bin/env ruby
require 'rubygems'
require 'ffi'
require 'io/console'


module CsoundAPI
  extend FFI::Library
  ffi_lib '/usr/lib/libcsound64.so.6.0'
  typedef :pointer, :myflt
  # attach_function :csoundInitialize, [:int, :string, :int], :int
  attach_function :csoundCreate, [:pointer], :pointer
  attach_function :csoundCompile, [:pointer, :int, :pointer], :int
  attach_function :csoundPerform, [:pointer], :int, :blocking => true
  attach_function :csoundDestroy, [:pointer], :void
  attach_function :csoundCreateThread, [:pointer, :pointer], :void
  attach_function :csoundPerformKsmps, [:pointer],  :int, :blocking => true
  attach_function :csoundStart, [:pointer], :int
  attach_function :csoundStop, [:pointer], :int
  attach_function :csoundGetControlChannel, [:pointer, :pointer, :int], :double
  attach_function :csoundSetControlChannel, [:pointer, :pointer, :double], :void
  attach_function :csoundDestroyMessageBuffer, [:pointer], :void
  callback :message_callback, [:string], :void
  attach_function :csoundSetMessageCallback, [:pointer, :message_callback], :void
  attach_function :csoundGetScoreTime, [:pointer], :double
  # class MyFloat < FFI::Struct
  #   layout :
  # end
  # class UserData < FFI::Struct
  #   layout :result, :int,
  #          :csound, :pointer,
  #          :perf_status, :int
  # end
end

# module CsoundPerfThread
#   extend FFI::Library
#   ffi_lib './libcsndperf.so'
#   attach_function :csoundStartPerformance, [:pointer], :pointer 
#   attach_function :csoundEndPerformance, [:pointer], :int
# end

class Csound
  def initialize
    @csnd = CsoundAPI.csoundCreate(nil)
  end

  def csd=(csd_path)
    compile({:csd => csd_path})
  end

  def compile(options = {})
    args = []
    args << FFI::MemoryPointer.from_string('csound')
    if options[:csd]
      # args << FFI::MemoryPointer.from_string('/home/ed/csound/fm/fmbell.csd')
      args << FFI::MemoryPointer.from_string(options[:csd])
    end
    args << nil
    argv = FFI::MemoryPointer.new(:pointer, args.length)
    args.each_with_index do |p, i|
      argv[i].put_pointer(0, p)
    end
    CsoundAPI.csoundCompile(@csnd, 2, argv)
  end

  def start
    CsoundAPI.csoundStart(@csnd)
  end

  def stop
    CsoundAPI.csoundStop(@csnd)
  end

  def perform
    CsoundAPI.csoundPerform(@csnd)
  end

  def performKsmps
    CsoundAPI.csoundPerformKsmps(@csnd)
  end

  def destroy
    CsoundAPI.csoundDestroy(@csnd)
    @csnd = nil
  end

  def createThread
    # userData = CsoundAPI::UserData.new data
    CsoundAPI.csoundCreateThread(ThreadCallback, nil)
  end

  def setControlChannel name, val
    CsoundAPI.csoundSetControlChannel(@csnd, name, val)
  end

  def destroyMessageBuffer
    CsoundAPI.csoundDestroyMessageBuffer(@csnd)
  end

  def setMessageCallback
    CsoundAPI.csoundSetMessageCallback(@csnd, MessageCallback)
  end

  def getScoreTime
    CsoundAPI.csoundGetScoreTime(@csnd)
  end

  ThreadCallback = Proc.new do
    while @perf && CsoundAPI.csoundPerformKsmps(@csnd) != 0 do
      p 'x'
    end
  # until CsoundAPI.csoundPerformKsmps(@csnd) == 0 || STDIN.getch == ?q
  #   p '---- performing -----'
  # end
    CsoundAPI.csoundDestroy(@csnd)
  end

  MessageCallback = Proc.new do |message|
    # p ">>"+message
  end
end

$stdin = nil
csnd = Csound.new
csnd.setMessageCallback
r = csnd.compile({:csd => '/home/ed/csound/fm/fmbell.csd'})
if r == 0
  csnd.setControlChannel "my_channel", 6.14
  thread = Thread.new { csnd.perform }
  # sleep 5
  puts "======"
  csnd.setControlChannel "my_channel", 3.14
  while STDIN.getch != ?q do
    puts csnd.getScoreTime
  end
end
csnd.stop
csnd.destroy

