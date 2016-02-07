# CLIConfig

## A tiny gem for handling configs for command line apps

CLIConfig provides a dsl heavily based on solnic/virtus for specifying options
that will be filled from yam or command line options via OptionParser.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cli_config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cli_config

## Usage

```ruby
class RPGConfig
  include CLIConfig

  option :name, String, desc: 'your name'
  option :race, Symbol, desc: 'your race (%{default})', default: :human
  option :strength, Integer, desc: 'your strength (%{default})', default: 33
  option :stamina, Integer, desc: 'your stamina (%{default})', default: 33, key: :x
  option :intelligence, Integer, desc: 'your intelligence (%{default})', default: 34
end

config = RPGConfig.new(name: 'test')

# Or read from a yaml file
# config = RPGConfig.load('/some/config.yml')

parser = OptionParser.new
parser.banner = "Usage: #{$0} [options]"
config.override_from_option_parser(parser)

puts parser
```

Output:

```
Usage: rpg [options]
    -n, --name VALUE                 your name
    -r, --race VALUE                 your race (human)
    -s, --strength VALUE             your strength (33)
    -x, --stamina VALUE              your stamina (33)
    -i, --intelligence VALUE         your intelligence (34)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jreinert/cli_config.
