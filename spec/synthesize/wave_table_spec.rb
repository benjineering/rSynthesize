RSpec.describe Synthesize::WaveTable do
  describe '.new' do
    it 'sets @pos to 0' do
      expect(Synthesize::WaveTable.new.pos).to eq 0
    end

    context 'when one number is passed' do
      let(:table) { Synthesize::WaveTable.new(2) }
      
      it 'calls the Array superclass with the same args' do
        expect(table).to eq [nil, nil]
      end
    end

    context 'when two numbers are passed' do
      let(:table) { Synthesize::WaveTable.new(3, 5) }
      
      it 'calls the Array superclass with the same args' do
        expect(table).to eq [5, 5, 5]
      end
    end

    context 'when an array is passed' do
      let(:table) { Synthesize::WaveTable.new([1, 2, 3]) }
      
      it 'calls the Array superclass with the same args' do
        expect(table).to eq [1, 2, 3]
      end
    end
  end

  describe '#next' do
    let(:table) { Synthesize::WaveTable.new([1, 2, 3]) }

    context 'when n is 0' do
      it 'returns nil' do
        expect(table.next(0)).to be nil
      end
    end

    context 'when n is -1' do
      it 'returns nil' do
        expect(table.next(-1)).to be nil
      end
    end

    context 'when @pos is not on the last value' do
      context 'when n is 1' do
        it 'returns a single item' do
          expect(table.next(1)).to eq 1
        end
      end
      context 'when n is 2' do
        it 'returns a an array of 2 items' do
          expect(table.next(2)).to eq [1, 2]
        end
      end
    end

    context 'when @pos is on the last value' do
      before(:each) { table.next(table.length - 1) }

      context 'when n is 1' do
        it 'returns a single item' do
          expect(table.next(1)).to eq 3
        end
      end
      context 'when n is 2' do
        it 'returns a an array of 2 items' do
          expect(table.next(2)).to eq [3, 1]
        end
      end
    end
  end

  describe '#next' do
    let(:table) do 
      t = Synthesize::WaveTable.new([1, 2, 3])
      t.next
      t
    end

    it 'sets @pos to 0' do
      expect { table.reset }.to change(table, :pos).from(1).to(0)
    end
  end
end
