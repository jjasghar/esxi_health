#
# Author:: JJ Asghar (<jjasghar@gmail.com>)
# License:: Apache License, Version 2.0
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


require 'rbvmomi'
require 'optparse'

options = { :host => nil, :insecure => true , :name => nil, :percent => nil, :password => nil, :user => nil}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: esxi_memory_stats.rb [options]"

  opts.on("-H host", "--hostname host", "ESXi host [Required]") do |host|
    options[:host] = host
  end

  opts.on("-i insecure", "--insecure insecure", "Connect via insecure") do |insecure|
    options[:insecure] = insecure
  end

  opts.on("-n name", "--name name", "Name of ESXi machine [Required]") do |name|
    options[:name] = name
  end

  opts.on("-p percent", "--percent percent", "High Percentage of Memory") do |percent|
    options[:percent] = percent.to_f
  end

  opts.on("-P password", "--password password", "Password for User to connect [Required]") do |password|
    options[:password] = password
  end

  opts.on("-u user", "--user user", "User to connect [Required]") do |user|
    options[:user] = user
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end

end

parser.parse!

vim = RbVmomi::VIM.connect host: options[:host], user: options[:user], password: options[:password], insecure: options[:insecure]
stats = vim.serviceInstance.find_datacenter.find_compute_resource(options[:name]).stats
cpu_percentage = ((stats[:usedCPU]/stats[:totalCPU].to_f)*100).round(1)


case
when options[:percent] >= cpu_percentage
  puts "OK: ESXi is under the max cpu usage using #{cpu_percentage}%"
  exit 0
when options[:percent] < cpu_percentage
  puts "Critical: ESXi has a higher than ideal cpu usage at #{cpu_percentage}%"
  exit 2
else
  puts "Unknown: something isn't working correctly"
  exit 3
end
