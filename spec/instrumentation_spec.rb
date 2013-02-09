require 'spec_helper'

class Guitar
  def self.load options = {}
    
  end
end

class BassGuitar < Guitar ; end
class Pencil ; end

describe Strumbar::Instrumentation do
  describe '#load' do
    context 'configuration block' do
      it 'accepts an instrument that responds to #load' do
        Strumbar.configure do |config|
          config.instruments.use Guitar
        end

        Strumbar.instruments.should include [Guitar, { rate: 1.0}]
      end

      it 'accepts an array of instruments' do
        Strumbar.configure do |config|
          config.instruments.use [Guitar, BassGuitar]
        end

        Strumbar.instruments.should include [Guitar, {rate: 1.0}]
        Strumbar.instruments.should include [BassGuitar, {rate: 1.0}]
      end

      it 'allows deletion of instruments from Strumbar' do
        Strumbar.configure do |config|
          config.instruments.use Guitar
          config.instruments.should include [Guitar, {}]
          config.instruments.delete Guitar
          config.instruments.should_not include [Guitar, {}]
        end
      end

      it 'raises an exception when trying to load an Instrument that does not respond to load' do
        Strumbar.configure do |config|
          expect { config.instruments.use Pencil }.to raise_error
        end
      end

      it 'accepts a hash of options' do
        Guitar.should_receive(:load).with(rate: 1.2)
        Strumbar.configure do |config|
          config.instruments.use Guitar, rate: 1.2
        end
      end

      it 'passes the default rate to an instrument if no hash is specified' do
        Guitar.should_receive(:load).with(rate: 1.0)
        Strumbar.configure do |config|
          config.instruments.use Guitar
        end
      end

      it 'passes the same hash to an array of instruments' do
        Guitar.should_receive(:load).with(rate: 1.5)
        BassGuitar.should_receive(:load).with(rate: 1.5)

        Strumbar.configure do |config|
          config.instruments.use [Guitar, BassGuitar], rate: 1.5
        end
      end

      it 'passes the default rate to to an array of instruments' do
        Guitar.should_receive(:load).with(rate: 1.0)
        BassGuitar.should_receive(:load).with(rate: 1.0)

        Strumbar.configure do |config|
          config.instruments.use [Guitar, BassGuitar]
        end
      end

      it 'loads no default instruments unless specified' do
        Strumbar.configure do
          # NOPE
        end
        Strumbar.instruments.should be_empty
        Strumbar::Instrumentation::Redis.should_not_receive :load
      end

      it 'sends the load message to all instruments in Strumbar' do
        Guitar.should_receive :load
        BassGuitar.should_receive :load

        Strumbar.configure do |config|
          config.instruments.use [Guitar, BassGuitar]
        end
      end
    end
  end
end
