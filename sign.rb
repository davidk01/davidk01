#!/usr/bin/env ruby
require 'json'
require 'shellwords'

# Sign the links
data = JSON.parse(File.read('data.json'))
data["links"]["links"].map! do |link_info|
  link = case link_info
  when String
    link_info
  when Hash
    link_info["link"]
  else
    raise StandardError, "Unknown link type: #{link.type}"
  end
  {
    "link": link,
    "signature": `keybase sign -m #{Shellwords.escape(link)}`.strip
  }
end
# Write signed data to disk
File.open('data.json', 'w') { |f| f.write(JSON.pretty_generate(data)) }
