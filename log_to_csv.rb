#!/usr/bin/env ruby

module Enumerable
  def sum
    self.inject(0){|accum, i| accum + i }
  end

  def mean
    self.sum/self.length.to_f
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
end 

if ARGV.length != 1
  puts "usage: #{__FILE__} <data.txt>"
  puts "\toptions:"
  exit
end
filename = ARGV[0]

lines = File.readlines(filename)

# parse each line into an array of floats
accels    = lines.select{ |line| line =~ /^ACCEL /    }.map{ |line| line.gsub(/^[A-Z]* [0-9\.]* /, "").chomp.split(/ /).map{ |x| x.to_f } }
attitudes = lines.select{ |line| line =~ /^ATTITUDE / }.map{ |line| line.gsub(/^[A-Z]* [0-9\.]* /, "").chomp.split(/ /).map{ |x| x.to_f } }
gyros     = lines.select{ |line| line =~ /^GYRO /     }.map{ |line| line.gsub(/^[A-Z]* [0-9\.]* /, "").chomp.split(/ /).map{ |x| x.to_f } }
magnetos  = lines.select{ |line| line =~ /^MAGNETO /  }.map{ |line| line.gsub(/^[A-Z]* [0-9\.]* /, "").chomp.split(/ /).map{ |x| x.to_f } }

# group into rows representing a single millisecond sample, across all 4 sensors
rows = accels.zip(attitudes, gyros, magnetos).map{ |x| x.flatten }

# normalize
cols = rows.transpose
col_means  = cols.map{ |col| col.mean }
col_stdevs = cols.map{ |col| col.standard_deviation }
rows = rows.map{ |row| row.zip(col_means ).map{ |x| x[0] - x[1] } }
rows = rows.map{ |row| row.zip(col_stdevs).map{ |x| x[0] / x[1] } }
rows = rows.each_cons(2).map{ |x| x[0].zip(x[1]).map{ |y| (y[1]-y[0])**2.0 } }

# get rid of the first 0.5 second (it's noisy)
rows = rows[10..-1]

rows.each { |row| puts row.join(", ") }
