# Ractor is a new feature in Ruby 3.0 that allows you to write concurrent code.
# - Bypassing the GIL, Ractors can run CPU-bound tasks concurrently.
# - Ractors do not share memory space, so you need to communicate between them using messages.
# - Run within the same process, so they are not as heavy as processes.
# - Minimal Impact on Memory Usage for Read-Only Tasks

ractors = []

# Create Ractors to perform tasks concurrently
5.times do |i|
  ractors << Ractor.new(i) do |i|
    "Starting Ractor #{i}"
    sleep(rand(1..3)) # Simulate some work by sleeping for 1-3 seconds
    "Ending Ractor #{i}! Time: #{Time.now}"
  end
end

# Collect results from each Ractor
results = ractors.map(&:take)

# Output the results
puts results

