require 'yaml'
require 'active_support/concern'
require 'virtus'
require 'cli_config/version'
require 'cli_config/option'

module CLIConfig
  extend ActiveSupport::Concern

  included do
    include Virtus.model
    extend ClassMethods
    include InstanceMethods
  end

  module ClassMethods
    def load(file)
      new(YAML.load_file(file))
    end

    def option(name, type, options = {})
      attribute(name, Option[type], { strict: true }.merge(options))
    end
  end

  module InstanceMethods
    def override_from_option_parser(option_parser)
      attribute_set.each do |attribute|
        attribute.from_option_parser(option_parser) do |value|
          send(:"#{attribute.name}=", value)
        end
      end
    end
  end
end
