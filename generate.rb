#!/usr/bin/env ruby
require 'io/console'

print "Enter your app name (e.g. My Cool App): "
raw_app_name = $stdin.gets.strip
safe_app_name = raw_app_name.gsub(/\s+/, '_').downcase

print "Use Rails API mode? (y/n): "
api_answer = $stdin.gets.strip.downcase
use_api = (api_answer == 'y' || api_answer == 'yes')

print "Generate a starter scaffold? (y/n): "
scaffold_answer = $stdin.gets.strip.downcase
use_scaffold = (scaffold_answer == 'y' || scaffold_answer == 'yes')

scaffold_name = ""
scaffold_fields = ""

if use_scaffold
  print "Enter the scaffold name (e.g. Post): "
  scaffold_name = $stdin.gets.strip

  print "Enter the fields (e.g. 'title:string body:text'): "
  scaffold_fields = $stdin.gets.strip
end

ENV['APP_NAME']          = raw_app_name
ENV['USE_API']           = use_api.to_s
ENV['USE_SCAFFOLD']      = use_scaffold.to_s
ENV['SCAFFOLD_NAME']     = scaffold_name
ENV['SCAFFOLD_FIELDS']   = scaffold_fields

template = "https://raw.githubusercontent.com/aFightClub/Rails-Framework/main/template.rb"
cmd = "rails new #{safe_app_name} -m #{template}"
cmd << " --api" if use_api
cmd << " --database=postgresql"

puts "\nRunning: #{cmd}\n"
system(cmd)
