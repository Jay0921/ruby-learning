# Threads are a way to run multiple tasks concurrently within a single process.
# - It is useful for I/O-bound tasks, but not for CPU-bound tasks.
# - Threads share the same memory space
# - Threads are limited by the Global Interpreter Lock (GIL) in Ruby

threads = []

5.times do |i|
  threads << Thread.new do
    "Starting Thread #{i}"
    sleep(rand(1..3)) # Simulate some work by sleeping for 1-3 seconds
    puts "Ending Thread #{i}! Time: #{Time.now}"
  end
end

# Wait for all threads to finish
threads.each(&:join)
puts "All threads completed"
