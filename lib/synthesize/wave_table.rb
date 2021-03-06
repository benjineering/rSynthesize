module Synthesize

  # Extends Array to act like a circular buffer when calling #next.
  class WaveTable < Array

    # The index of the next item to read.
    attr_reader :pos

    # Calls #reset.
    def initialize(n = nil, val = nil)
      if n.nil?
        super(0)
      elsif val.nil?
        super(n)
      else
        super(n, val)
      end

      reset
    end

    # Returns the next n items beginning at @pos.
    # If n == 1 it returns a single item, otherwise it returns an array.
    # When @pos goes past the index of the last item, it starts at 0 again.
    def next(n = 1)
      return nil if n < 1

      items = n.times.collect do
        @pos += 1
        @pos = 0 if @pos == length
        self[@pos]
      end

      items.length > 1 ? items : items.first
    end

    # Sets @pos to 0.
    def reset
      @pos = 0
    end
  end
end
