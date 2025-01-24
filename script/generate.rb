#!/usr/bin/env ruby
require 'io/console'
require 'open-uri'
require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

print "Enter your app name (e.g. My Rails App): "
raw_app_name = $stdin.gets.strip
safe_app_name = raw_app_name.gsub(/\s+/, '_').downcase

print "Use AI helper? (y/n): "
scaffold_answer = $stdin.gets.strip.downcase
use_scaffold = (scaffold_answer == 'y' || scaffold_answer == 'yes')

def save_to_file(value, file)
  FileUtils.mkdir_p(File.dirname(file))
  File.write(file, value)
end

def save_api_key(api_key)
  FileUtils.mkdir_p(File.dirname(CONFIG_FILE))
  File.write(CONFIG_FILE, api_key)
end

def load_api_key
  return nil unless File.exist?(CONFIG_FILE)
  File.read(CONFIG_FILE).strip
rescue
  nil
end

if use_scaffold
  CONFIG_FILE = File.join(__dir__, 'config', 'api_key.txt')

  openai_api_key = ENV['ST_OPENAI_API'] || load_api_key
  if openai_api_key.nil? || openai_api_key.strip.empty?
    print "Enter your OpenAI API key: "
    openai_api_key = $stdin.gets.strip
    save_api_key(openai_api_key)
    ENV['ST_OPENAI_API'] = openai_api_key
  else
    puts "\nUsing existing OpenAI API key.\n"
  end

  begin
    print "Prompt: "
    prompt = $stdin.gets.strip

    puts "\nProcessing build steps with OpenAI...\n"

    api_key = ENV['OPENAI_API_KEY'] || openai_api_key
    url = URI("https://api.openai.com/v1/chat/completions")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{api_key}"

    request.body = {
      "model": "gpt-4o-2024-08-06",
      "response_format": {
        "type": "json_schema",
        "json_schema": {
          "name": "rails_app_generator",
          "schema": {
            "type": "object",
            "properties": {
              "scaffolding": { "type": "string" },
              "models": {
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "name": { "type": "string" },
                    "code": { "type": "string" }
                  },
                  "required": ["name", "code"],
                  "additionalProperties": false
                }
              },
              "navigation": {
                "type": "array",
                "items": { "type": "string" }
              }
            },
            "required": ["scaffolding", "models", "navigation"],
            "additionalProperties": false
          },
          "strict": true
        }
      },
      "messages": [
        {
          "role": "system",
          "content": "You are a Ruby on Rails generator assistant. You will take in a prompt and generate the scaffold prompts and edit the model files depending on the request.

          You will respond in the following JSON format:

          {
            'scaffolding': 'scaffold Post title:string body:text; scaffold Comment body:text post:references;',
            'models': [
              {
                'name': 'Post',
                'code': '...'
              },
            ],
            'navigation': ['posts']
          }

          Scaffolding: The scaffold command to generate the models with user reference or other references.

          Models: The model files and the code to be added to the model files. This must contain the entire code for the rails model file. (like belongs_to, has_many, etc.)

          Navigation: The navigation is a array of names for any paths that should be in the header navigation (for any scaffolds, etc)

          You will always provide the scaffolding commands, the models, and views are optional only if you need to make changes that don't happen when scaffold commands are run.

          The code you provide will be used in a rails new command to generate a new Rails app process, so make sure to follow the Rails conventions and best practices. By default all new models should be attached to the users_id field for authentication purposes.
          "
        },
        {
          "role": "user",
          "content": "#{prompt}"
        }
      ],
    }.to_json

    begin
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        content = data['choices'][0]['message']['content']
        content = JSON.parse(content)

        commands = content["scaffolding"].split(";")
        puts "\nScaffolding:"
        commands.each_with_index do |command, index|
          puts "#{index + 1}. #{command.strip}"
        end

        models = content["models"]
        puts "\nModels:"
        models.each_with_index do |model, index|
          puts "#{index + 1}. #{model["name"].strip}"
        end

        print "\nUse AI build steps? (c = request changes) (y/c/n): "
        ai_use = $stdin.gets.strip
        should_use = (ai_use == 'y' || ai_use == 'yes')
        should_change = ai_use == 'c'

        if should_change
          # TODO: request changes (make into function)
        end

        if should_use
          SCAFFOLD_FILE = File.join(__dir__, 'config', 'scaffolding.txt')
          save_to_file(content["scaffolding"], SCAFFOLD_FILE)

          NAV_FILE = File.join(__dir__, 'config', 'navigation.txt')
          save_to_file(content["navigation"], NAV_FILE)

          models.each_with_index do |model, index|
            puts "#{index + 1}. #{model["name"].strip}"
            MODEL_FILE = File.join(__dir__, 'config', "#{model["name"].downcase.strip}-model.txt")
            save_to_file(model["code"], MODEL_FILE)
          end
        end
      else
        puts "Error: #{response.code} - #{response.message}"
        puts response.body
      end
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  rescue => e
    puts "Error fetching OpenAI endpoint: #{e.message}"
  end
end

ENV['ST_OPENAI_USE']        = should_use.to_s
ENV['ST_APP_NAME']          = raw_app_name

TEMPLATE_FILE = File.join(__dir__, 'template.rb')
template = TEMPLATE_FILE
cmd = "rails new #{safe_app_name} -m #{template}"
cmd << " --database=postgresql"

puts "\nRunning: #{cmd}\n"
system(cmd)
