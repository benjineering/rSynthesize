require 'synthesize/generator'
require 'synthesize/wave_table'

module Synthesize
  class << self
    def sine(frequency, amplitude, duration = nil)
      g = Generator.new(frequency, amplitude, duration)
      g.sine
      g
    end

    def square(frequency, amplitude, duration = nil)
      g = Generator.new(frequency, amplitude, duration)
      g.square
      g
    end

    def sawtooth(frequency, amplitude, duration = nil)
      g = Generator.new(frequency, amplitude, duration)
      g.sawtooth
      g
    end

    def triangle(frequency, amplitude, duration = nil)
      g = Generator.new(frequency, amplitude, duration)
      g.triangle
      g
    end
  end
end
