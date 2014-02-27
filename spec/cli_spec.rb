require 'rspec'
require 'pebble_x'

describe 'CLI' do

  describe 'xcode' do

    it 'calls create_project' do
      xcode = double 'Xcode'
      expect(xcode).to receive(:create_project)

      c = PebbleX::CLI.new
      expect(c).to receive(:command_helper).with(PebbleX::Xcode).and_return(xcode)
      c.xcode
    end
  end


  describe 'build' do
    it 'delegates to pebble build' do
      pebble = double 'pebble'
      expect(pebble).to receive(:build).and_return 23

      c = PebbleX::CLI.new
      expect(c).to receive(:command_helper).with(PebbleX::Pebble).and_return(pebble)
      expect(c).to receive(:exit).with(23)
      c.build
    end
  end

  describe 'build' do
    it 'delegates to pebble debug' do
      pebble = double 'pebble'
      expect(pebble).to receive(:debug).and_return 23

      c = PebbleX::CLI.new
      expect(c).to receive(:command_helper).with(PebbleX::Pebble).and_return(pebble)
      expect(c).to receive(:exit).with(23)
      c.debug
    end
  end

  describe 'pebble_cmd' do

    it 'derives pebble location from pebble_sdk_dir' do
      c = PebbleX::CLI.new
      expect(c).to receive(:pebble_sdk_dir).and_return "/path/to/sdk"
      expect(File).to receive(:exists?).and_return true
      expect(c.pebble_cmd).to eq "/path/to/sdk/bin/pebble"
    end

    it 'verifies existence of pebble binary' do
      c = PebbleX::CLI.new
      expect(c).to receive(:pebble_sdk_dir).and_return "/path/to/sdk"
      expect(File).to receive(:exists?).and_return false
      expect{c.pebble_cmd}.to raise_error
    end

  end


  describe 'pebble_sdk_dir' do
    it 'uses `which pebble` to determine sdk path' do
      c = PebbleX::CLI.new
      expect(c).to receive(:sys_call).with('which pebble').and_return '/path/to/sdk/bin/pebble'
      expect(c.pebble_sdk_dir).to eq '/path/to/sdk'
    end

    it 'uses option pebble_sdk if provided' do
      c = PebbleX::CLI.new
      expect(c).to_not receive(:sys_call)
      expect(c).to receive(:options).and_return({:pebble_sdk => "/path/to/sdk"})
      expect(c.pebble_sdk_dir).to eq '/path/to/sdk'
    end
  end



end