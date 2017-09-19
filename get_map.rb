#!/usr/bin/env ruby
require 'net/http'

full = 'http://viewers-guide.hbo.com/mapimages/8/y25x38.png'
max_y = 25
max_x = 38
domain = 'viewers-guide.hbo.com'

Net::HTTP.start(domain) do |http|
    (0..max_y).each do |y|
        (0..max_x).each do |x|
        	file_name = "y#{y}x#{x}.png"
            url = "/mapimages/8/#{file_name}"
            response = http.get(url)
            open("tiles/#{file_name}", 'wb') do |file|
                file.write(response.body)
            end
        end
    end	
end
puts 'complete'
