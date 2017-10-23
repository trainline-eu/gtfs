require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::URLSource, :vcr do
  context 'with a URI to a valid source zip' do
    let(:source_path) {'https://raw.githubusercontent.com/google/transit/master/gtfs/spec/en/examples/sample-feed-1.zip'}
    it 'should create a new source successfully' do
      expect { GTFS::URLSource.new(source_path, {}) }.not_to raise_error
    end
  end

  context 'with a non-existent URI', :vcr do
    let(:source_path) {'https://raw.githubusercontent.com/google/transit/master/gtfs/spec/en/examples/404.zip'}
    it 'should raise an exception' do
      expect { GTFS::URLSource.new(source_path, {}) }.to raise_error(GTFS::InvalidSourceException)
    end
  end
end
