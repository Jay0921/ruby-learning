require 'benchmark'
require 'json'

module Task
  def io_intensive_task
    sleep(3)  # Simulate IO delay
  end

  def cpu_intensive_task
    (1..50_000_000).reduce(:+)  # Simulate CPU work
  end
end

class AService
  extend Task

  def self.call
    io_intensive_task
    return [1, 2, 3]
  end
end

class BService
  extend Task

  def self.call
    io_intensive_task
    return [4, 5, 6]
  end
end

class CService
  extend Task

  def self.call
    io_intensive_task
    return [7, 8, 9]
  end
end

class DService
  extend Task

  def self.call
    io_intensive_task
    return [10, 11, 12]
  end
end

thread_result = []
threads = []

# Measure execution time
time_taken = Benchmark.measure do
  [AService, BService, CService, DService].each do |service|
    threads << Thread.new do
      thread_result << service.call
    end
  end

  threads.each(&:join)
end

p thread_result
puts "Time taken(Thread): #{time_taken.real} seconds"

fork_result = []
time_taken = Benchmark.measure do
  [AService, BService, CService, DService].each do |service|
    read_pipe, write_pipe = IO.pipe

    fork do
      read_pipe.close
      value = service.call
      write_pipe.puts(value.to_json)
      write_pipe.close
    end

    write_pipe.close
    fork_result << read_pipe
  end

  Process.waitall

  fork_result.map! do |read_pipe|
    value = JSON.parse(read_pipe.gets)  # Read and parse the result
    read_pipe.close
    value
  end
end

p fork_result
puts "Time taken(Fork): #{time_taken.real} seconds"


ractor_result = []
ractors = []

time_taken = Benchmark.measure do
  [AService, BService, CService, DService].each do |service|
    ractors << Ractor.new(service) do |service|
      service.call
    end
  end

  ractor_result = ractors.map(&:take)
end

p ractor_result
puts "Time taken(Ractor): #{time_taken.real} seconds"
