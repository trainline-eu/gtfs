require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Source do
  let(:valid_local_source) do
    File.expand_path(File.dirname(__FILE__) + '/../fixtures/valid_gtfs.zip')
  end

  let(:source_missing_required_files) do 
    File.expand_path(File.dirname(__FILE__) + '/../fixtures/missing_files.zip')
  end

  describe '#build' do
    let(:opts) {{}}
    let(:data_source) {valid_local_source}
    subject {GTFS::Source.build(data_source, opts)}

    context 'with a url as a data root', :vcr do
      let(:data_source) {'https://raw.githubusercontent.com/google/transit/master/gtfs/spec/en/examples/sample-feed-1.zip'}

      it { should be_instance_of GTFS::URLSource }
      it { expect(subject.options).to eq GTFS::Source::DEFAULT_OPTIONS }
    end

    context 'with a file path as a data root' do
      let(:data_source) {valid_local_source}

      it {should be_instance_of GTFS::LocalSource}
      it { expect(subject.options).to eq GTFS::Source::DEFAULT_OPTIONS }
    end

    context 'with a file object as a data root' do
      let(:data_source) {File.open(valid_local_source)}

      it {should be_instance_of GTFS::LocalSource}
      it { expect(subject.options).to eq GTFS::Source::DEFAULT_OPTIONS }
    end

    context 'with options to disable strict checks' do
      let(:opts) {{strict: false}}

      it { expect(subject.options).to eq GTFS::Source::DEFAULT_OPTIONS.merge({strict: false}) }
    end

    context 'with options to specify a working directory' do
      let(:data_source) {valid_local_source}
      let(:opts) {{workingDirectory: FileUtils.mkdir_p("#{File.dirname(valid_local_source)}/tmp").first}}

      it { expect(subject.options).to eq GTFS::Source::DEFAULT_OPTIONS.merge({workingDirectory: "#{File.dirname(valid_local_source)}/tmp"}) }
    end
  end

  describe '#new(source)' do
    it 'should not allow a base GTFS::Source to be initialized' do
      expect { GTFS::Source.new(valid_local_source) }.to raise_exception('Cannot directly instantiate base GTFS::Source')
    end
  end

  describe '#agencies' do
    subject {source.agencies}

    context 'when the source has agencies' do
      let(:source) {GTFS::Source.build(valid_local_source)}

      it {should_not be_empty}
      it { expect(subject.first).to be_an_instance_of(GTFS::Agency) }
    end
  end

  describe '#stops' do
  end

  describe '#routes' do
    context 'when the source is missing routes' do
      let(:source) { GTFS::Source.build source_missing_required_files }

      it do
        expect { source.routes }.to raise_exception GTFS::InvalidSourceException
      end
    end
  end

  describe '#trips' do
  end

  describe '#stop_times' do
  end
end
