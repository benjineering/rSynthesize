# Synthesize

## This gem generates waveforms

Example:

    g = Synthesize::Generator.new(440, 1, 1) # 440 Hz, Max Amplitude, 1 Second
    g.square

    f = File.new("square.wav", "w")
    f.write(g.to_wav)
    f.close

Thanks to Damien Karras for the algorithms!

http://en.wikibooks.org/wiki/Sound_Synthesis_Theory/Oscillators_and_Wavetables
