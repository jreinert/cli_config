require 'spec_helper'
require 'optparse'

describe CLIConfig do
  it 'has a version number' do
    expect(CLIConfig::VERSION).not_to be nil
  end

  class StringTestConfig
    include CLIConfig
    option(:test, String, desc: 'A String option')
  end

  class CoercingTestConfig
    include CLIConfig
    option(:test, Integer, desc: 'A Integer option')
  end

  class DefaultsTestConfig
    include CLIConfig

    option(
      :test, Integer,
      desc: 'A defaults test (%{default})',
      default: 1337
    )
  end

  class BooleanTestConfig
    include CLIConfig
    option(:test, Boolean, desc: 'A boolean test')
  end

  class KeysTestConfig
    include CLIConfig
    option(:a_test, String, strict: false)
    option(:another_test, Boolean, key: :'2', strict: false)
  end

  class ValueNameTestConfig
    include CLIConfig
    option(:a_test, String, strict: false)
    option(:another_test, String, key: :'2', value_name: :TEST, strict: false)
  end

  describe '.load' do
    it 'parses a yaml file and assigns the values to a new config instance' do
      config = StringTestConfig.load('spec/fixtures/test.yml')
      expect(config.test).to eq('passed')
    end
  end

  describe '.new' do
    it 'fails on unset options without defaults' do
      expect { StringTestConfig.new }.to raise_error(Virtus::CoercionError)
    end

    it 'coerces options correctly' do
      config = CoercingTestConfig.new(test: '1337')
      expect(config.test).to eq(1337)
    end

    it 'assigns defaults if unset' do
      config = DefaultsTestConfig.new
      expect(config.test).to eq(1337)
    end
  end

  describe '.override_from_option_parser' do
    let(:option_parser) { OptionParser.new }

    it 'handles normal options correctly' do
      config = StringTestConfig.new(test: 'failed')
      stub_const('ARGV', ['--test', 'passed'])
      config.override_from_option_parser(option_parser)
      option_parser.parse!

      expect(config.test).to eq('passed')
    end

    it 'handles boolean options correctly' do
      config = BooleanTestConfig.new(test: false)
      stub_const('ARGV', ['--test'])
      config.override_from_option_parser(option_parser)
      option_parser.parse!

      expect(config.test).to be true
    end

    it 'replaces %{defaults} in desc with default value' do
      config = DefaultsTestConfig.new
      config.override_from_option_parser(option_parser)
      expect(option_parser.to_s).to match(/A defaults test \(1337\)/)
    end

    it 'sets key and long_key correctly' do
      config = KeysTestConfig.new
      config.override_from_option_parser(option_parser)
      expect(option_parser.to_s).to match(/-a, --a-test/)
      expect(option_parser.to_s).to match(/-2, --\[no-\]another-test/)
    end

    it 'sets the value name correctly' do
      config = ValueNameTestConfig.new
      config.override_from_option_parser(option_parser)
      expect(option_parser.to_s).to match(/--a-test VALUE/)
      expect(option_parser.to_s).to match(/--another-test TEST/)
    end
  end
end
