#!/usr/bin/env ruby

require 'rmagick'

class Combiner
    include Magick

    def self.combine
        # this will be the final image
        big_image = ImageList.new
        max_y = 25
        max_x = 38
        (0..max_y).each do |y|
            # this is an image containing row of images
            row = ImageList.new
            (0..max_x).each do |x|
                file_name = "y#{y}x#{x}.png"
                row.push(Image.read("tiles/#{file_name}").first)
            end
            # adding first row to big image and specify that we want images in row to be appended in a single image on the same row.
            # argument false on append does that
            big_image.push(row.append(false))
        end
        # now we are saving the final image that is composed from row images,
        # by sepcify append with argument true, meaning that each image will be on a separate row
        big_image.append(true).write('westeros.png')
        puts 'complete'
    end

end

Combiner.combine
