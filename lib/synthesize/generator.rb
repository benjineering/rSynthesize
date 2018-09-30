require 'synthesize/wave_table'

module Synthesize
  class Generator
    TWO_PI = 2 * Math::PI

    attr_accessor :wave_table, :frequency, :amplitude, :duration, :channels, :sample_rate, :bits_per_sample
    
    # Generates a single cycle if duration is nil
    def initialize(frequency, amplitude, duration = nil)
      @frequency = frequency
      @amplitude = amplitude
      @duration = duration
      @channels = 2
      @sample_rate = 44100
      @bits_per_sample = 16 # TODO: handle this

      @sample_count = 
      if @duration.nil?
        @sample_rate / @frequency
      else
        @duration * @sample_rate
      end
    end
    
    def sine
      phase = 0
      step = (TWO_PI * @frequency).fdiv(@sample_rate)
      @wave_table = Array.new(@sample_count)

      @wave_table.each_index do |i|
        @wave_table[i] = @amplitude * Math.sin(phase)        
        phase = phase + step
        phase = phase - TWO_PI if phase > TWO_PI
      end

      @wave_table
    end

    alias_method :sin, :sine
    
    def square
      phase = 0
      step = (TWO_PI * @frequency).fdiv(@sample_rate)
      @wave_table = Array.new(@sample_count)

      @wave_table.each_index do |i|
        @wave_table[i] = phase < Math::PI ? @amplitude : -@amplitude        
        phase = phase + step
        phase = phase - (TWO_PI) if phase > (TWO_PI)
      end

      @wave_table
    end
    
    def sawtooth
      phase = 0
      step = (TWO_PI * @frequency).fdiv(@sample_rate)
      @wave_table = Array.new(@sample_count)

      @wave_table.each_index do |i|
        @wave_table[i] = @amplitude - (@amplitude.fdiv(Math::PI)) * phase        
        phase = phase + step
        phase = phase - (TWO_PI) if phase > (TWO_PI)
      end

      @wave_table
    end
    
    def triangle
      phase = 0
      step = (TWO_PI * @frequency).fdiv(@sample_rate)
      @wave_table = Array.new(@sample_count)

      @wave_table.each_index do |i|
        if phase < Math::PI
          @wave_table[i] = -@amplitude + (2 * @amplitude.fdiv(Math::PI)) * phase
        else
          @wave_table[i] = 3 * @amplitude - (2 * @amplitude.fdiv(Math::PI)) * phase
        end
        
        phase = phase + step
        phase = phase - (TWO_PI) if phase > (TWO_PI)
      end

      @wave_table
    end
    
    def noise
      raise 'Duration required' if duration.nil? # TODO: fix
      @wave_table = Array.new(@duration * @sample_rate)
      @wave_table.each_index do |i|
        wave_table[i] = rand(2) - 1
      end

      @wave_table
    end
    
    def silence
      @wave_table = Array.new(@sample_count)
      @wave_table.each_index do |i|
        wave_table[i] = 0
      end

      @wave_table
    end
    
    def to_wav
      wave_table = Array.new
      
      @wave_table.each do |w|
        value = w * ((2**@bits_per_sample) / 2)
        value = value > 0 ? value - 1 : value + 1

        @channels.times do |c|
          wave_table.push(value)
        end
      end
      
      block_align = (@bits_per_sample / 8) * @channels
      bytes_per_second = block_align * @sample_rate
      
      header = Array[
        "RIFF",                     #Chunk ID
          bytes_per_second * @duration + 44 - 8,  #Chunk Data Size
          "WAVE",                     #RIFF Type
        "fmt ",                     #Chunk ID
          16,                         #Chunk Data Size
          1,                          #Compression Code
          @channels,                  #Number of Channels
          @sample_rate,               #Sample Rate
          bytes_per_second,           #Bytes per Second
          block_align,                #Block Align
          @bits_per_sample,           #Significant Bits per Sample
        "data",                     #Chunk ID
          bytes_per_second * @duration] #Chunk Data Size
        
          
      header_data = header.pack("A4VA4A4VvvVVvvA4V")
      wav_data = wave_table.pack("s*")
      
      return header_data + wav_data
    end
  end
end
