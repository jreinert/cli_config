require 'active_support/core_ext/object/try'

module CLIConfig
  class Option < Virtus::Attribute
    def self.[](type)
      Class.new(self).tap do |klass|
        klass.define_singleton_method(:type) { type }
      end
    end

    def coerce(value)
      Virtus::Attribute.build(
        self.class.type,
        strict: options[:strict]
      ).coerce(value)
    end

    def from_option_parser(parser, &block)
      if boolean?
        parser.on("-#{key}", "--[no-]#{long_key}", description, &block)
      else
        parser.on("-#{key}", "--#{long_key} #{value_name}", description, &block)
      end
    end

    private

    def description
      default = default_value.value
      description = options[:description] || options[:desc]
      return unless description
      description % { default: default }
    end

    def key
      options.fetch(:key, name.to_s[0])
    end

    def long_key
      name.to_s.tr('_', '-')
    end

    def value_name
      options[:value_name].try(:upcase) || 'VALUE'
    end

    def boolean?
      self.class.type == Boolean
    end
  end
end
