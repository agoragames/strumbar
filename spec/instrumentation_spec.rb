require 'spec_helper'

class Guitar
  def self.load
    
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

        Strumbar.instruments.should include Guitar
      end

      it 'accepts an array of instruments' do
        Strumbar.configure do |config|
          config.instruments.use [Guitar, BassGuitar]
        end

        Strumbar.instruments.should include Guitar
        Strumbar.instruments.should include BassGuitar
      end

      it 'allows deletion of instruments from Strumbar' do
        Strumbar.configure do |config|
          config.instruments.use Guitar
          config.instruments.should include Guitar
          config.instruments.delete Guitar
          config.instruments.should_not include Guitar
        end
      end

      it 'raises an exception when trying to load an Instrument that does not respond to load' do
        Strumbar.configure do |config|
          expect { config.instruments.use Pencil }.to raise_error
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
