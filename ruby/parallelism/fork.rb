pids = []

5.times do |i|
  pids << fork do
    puts "Starting Fork #{i}"
    # Each process can perform a CPU-bound task independently
    sleep(rand(1..3)) # Simulate some work by sleeping for 1-3 seconds
    puts "Ending Fork #{i}! Time: #{Time.now}"
    exit # Make sure to exit to prevent child processes from continuing to run the parent's code
  end
end

# Parent waits for all child processes to finish
pids.each do |pid|
  Process.wait(pid)
end

puts "All processes completed"
# Ractors