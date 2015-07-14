#!/usr/bin/env ruby

require 'optparse'
require 'RMagick'
include Magick

class CustomArgsParser

  def self.parse(args)
    options = {}
    
    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: puzzler.rb [options]"
      opts.separator ""
      opts.separator "Mandatory options:"
      opts.on("-f f", "--file=file", "Path to the picture file") do |file|
        options['file'] = file
      end
      opts.separator ""
      opts.separator "Common options:"
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end
    
    begin
      opt_parser.parse!(args)
      mandatory = ['file']
      missing = mandatory.select{ |param| options[param].nil? }
      if not missing.empty?
        puts "Missing options: #{missing.join(', ')}"
        puts opt_parser
        exit
      end
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts $!.to_s
      puts opt_parser
      exit
    end
    
    return options
  end
end


class Puzzle
  
  def self.landscape_mask
    { :puz_01_01 => {:x => 0,     :y => 0},
      :puz_01_02 => {:x => 66,    :y => 0},
      :puz_01_03 => {:x => 197,   :y => 0},
      :puz_01_04 => {:x => 268,   :y => 0},
      :puz_01_05 => {:x => 394,   :y => 0},
      :puz_01_06 => {:x => 470,   :y => 0},
      :puz_01_07 => {:x => 591,   :y => 0},
      :puz_01_08 => {:x => 668,   :y => 0},
      
      :puz_02_01 => {:x => 0,     :y => 87},
      :puz_02_02 => {:x => 90,    :y => 62},
      :puz_02_03 => {:x => 165,   :y => 88},
      :puz_02_04 => {:x => 292,   :y => 66},
      :puz_02_05 => {:x => 370,   :y => 87},
      :puz_02_06 => {:x => 491,   :y => 64},
      :puz_02_07 => {:x => 567,   :y => 84},
      :puz_02_08 => {:x => 698,   :y => 61},
      
      :puz_03_01 => {:x => 0,     :y => 154},
      :puz_03_02 => {:x => 66,    :y => 178},
      :puz_03_03 => {:x => 192,   :y => 153},
      :puz_03_04 => {:x => 271,   :y => 152},
      :puz_03_05 => {:x => 394,   :y => 170},
      :puz_03_06 => {:x => 469,   :y => 170},
      :puz_03_07 => {:x => 591,   :y => 149},
      :puz_03_08 => {:x => 669,   :y => 173},
      
      :puz_04_01 => {:x => 0,     :y => 271},
      :puz_04_02 => {:x => 90,    :y => 242},
      :puz_04_03 => {:x => 165,   :y => 267},
      :puz_04_04 => {:x => 293,   :y => 241},
      :puz_04_05 => {:x => 370,   :y => 266},
      :puz_04_06 => {:x => 494,   :y => 239},
      :puz_04_07 => {:x => 567,   :y => 266},
      :puz_04_08 => {:x => 696,   :y => 234},
      
      :puz_05_01 => {:x => 0,     :y => 332},
      :puz_05_02 => {:x => 65,    :y => 359},
      :puz_05_03 => {:x => 193,   :y => 335},
      :puz_05_04 => {:x => 270,   :y => 359},
      :puz_05_05 => {:x => 396,   :y => 335},
      :puz_05_06 => {:x => 467,   :y => 356},
      :puz_05_07 => {:x => 596,   :y => 330},
      :puz_05_08 => {:x => 673,   :y => 354},
      
      :puz_06_01 => {:x => 0,     :y => 448},
      :puz_06_02 => {:x => 89,    :y => 423},
      :puz_06_03 => {:x => 161,   :y => 420},
      :puz_06_04 => {:x => 295,   :y => 446},
      :puz_06_05 => {:x => 369,   :y => 448},
      :puz_06_06 => {:x => 495,   :y => 421},
      :puz_06_07 => {:x => 568,   :y => 444},
      :puz_06_08 => {:x => 700,   :y => 420}}
  end
  
  def self.portrait_mask
    { :puz_01_01 => {:x => 0,    :y => 0},
      :puz_01_02 => {:x => 52,   :y => 0},
      :puz_01_03 => {:x => 167,  :y => 0},
      :puz_01_04 => {:x => 227,  :y => 0},
      :puz_01_05 => {:x => 348,  :y => 0},
      :puz_01_06 => {:x => 413,  :y => 0},

      :puz_02_01 => {:x => 0,    :y => 89},
      :puz_02_02 => {:x => 77,   :y => 65},
      :puz_02_03 => {:x => 141,  :y => 90},
      :puz_02_04 => {:x => 258,  :y => 66},
      :puz_02_05 => {:x => 323,  :y => 90},
      :puz_02_06 => {:x => 438,  :y => 66},

      :puz_03_01 => {:x => 0,    :y => 161},
      :puz_03_02 => {:x => 81,   :y => 193},
      :puz_03_03 => {:x => 167,  :y => 165},
      :puz_03_04 => {:x => 234,  :y => 192},
      :puz_03_05 => {:x => 348,  :y => 165},
      :puz_03_06 => {:x => 410,  :y => 197},

      :puz_04_01 => {:x => 0,    :y => 295},
      :puz_04_02 => {:x => 54,   :y => 270},
      :puz_04_03 => {:x => 141,  :y => 293},
      :puz_04_04 => {:x => 262,  :y => 271},
      :puz_04_05 => {:x => 349,  :y => 292},
      :puz_04_06 => {:x => 435,  :y => 268},

      :puz_05_01 => {:x => 0,    :y => 369},
      :puz_05_02 => {:x => 52,   :y => 396},
      :puz_05_03 => {:x => 166,  :y => 370},
      :puz_05_04 => {:x => 234,  :y => 394},
      :puz_05_05 => {:x => 327,  :y => 370},
      :puz_05_06 => {:x => 412,  :y => 394},

      :puz_06_01 => {:x => 0,    :y => 495},
      :puz_06_02 => {:x => 79,   :y => 467},
      :puz_06_03 => {:x => 143,  :y => 494},
      :puz_06_04 => {:x => 260,  :y => 469},
      :puz_06_05 => {:x => 328,  :y => 491},
      :puz_06_06 => {:x => 438,  :y => 470},

      :puz_07_01 => {:x => 0,    :y => 568},
      :puz_07_02 => {:x => 57,   :y => 596},
      :puz_07_03 => {:x => 172,  :y => 567},
      :puz_07_04 => {:x => 234,  :y => 591},
      :puz_07_05 => {:x => 354,  :y => 567},
      :puz_07_06 => {:x => 417,  :y => 591},

      :puz_08_01 => {:x => 0,    :y => 700},
      :puz_08_02 => {:x => 82,   :y => 673},
      :puz_08_03 => {:x => 146,  :y => 696},
      :puz_08_04 => {:x => 263,  :y => 669},
      :puz_08_05 => {:x => 328,  :y => 698},
      :puz_08_06 => {:x => 440,  :y => 668}}
  end

  def initialize(file_path)
    @file_path      = file_path
    @puzzle_width   = 796
    @puzzle_height  = 528
  end
  
  def create
    results_dir = Time.now.strftime('%d-%B-%Y_%k-%M-%S-%L')
    Dir.mkdir(results_dir)
    origin = ImageList.new(@file_path).first
    if origin.columns > origin.rows
      orientation = 'landscape'
      cropped = origin.crop_resized(@puzzle_width, @puzzle_height)
      mask_matrix = Puzzle.landscape_mask
    else
      orientation = 'portrait'
      cropped = origin.crop_resized(@puzzle_height, @puzzle_width)
      mask_matrix = Puzzle.portrait_mask
    end
    mask_matrix.each do |mask_key, dimensions|
      mask  = ImageList.new("./mask/#{orientation}/#{mask_key.to_s}.png").first
      bg    = Image.new(mask.columns, mask.rows){self.background_color = "#00FF00"}
      slice = cropped.crop(dimensions[:x], dimensions[:y], mask.columns, mask.rows)
      slice.add_compose_mask(mask)
      puzzle = slice.composite(bg, CenterGravity, OverCompositeOp).transparent("#00FF00")
      puzzle.write("./#{results_dir}/#{mask_key.to_s}.png")
    end
  end
  
end


options = CustomArgsParser.parse(ARGV)
current_dir = File.expand_path(File.dirname(__FILE__))
picture_file_path = File.expand_path(options['file'])
puzzle = Puzzle.new(picture_file_path)
puzzle.create
exit


