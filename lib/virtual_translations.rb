module VirtualTranslations
  module ClassMethods
    def virtual_translations(*args)
      cattr_accessor :virtual_translations_options

      options = args.extract_options! || {}
      self.virtual_translations_options = options.merge(:fields=>args)

      include VirtualTranslations::InstanceMethods
    end
  end

  module InstanceMethods
    def self.included(base)
      fields = base.virtual_translations_options[:fields]
      fields.each do |field|
        eval <<GETTER_AND_SETTER
          def #{field}(locale=nil)
            virtual_translations(locale)[:#{field}]
          end

          def #{field}=(value, locale=nil)
            virtual_translations(locale)[:#{field}] = value
          end
GETTER_AND_SETTER
      end
    end

    def virtual_translations(locale=nil)
      locale ||= I18n.locale
      @virtual_translations ||= {}.with_indifferent_access
      @virtual_translations[locale] ||= {}.with_indifferent_access
      @virtual_translations[locale]
    end

    def method_missing(name, *args)
      return super unless name.to_s =~ /^([a-zA-Z_]+)_in_([a-z]{2})[=]?$/
      field = $1; locale = $2
      fields = self.class.virtual_translations_options[:fields]
      return super unless fields.include? field.sub('=','').to_sym
      
      if field.include? '=' #is setter ?
        send(field, args[0], locale)
      else
        send(field, locale)
      end
    end
  end
end

ActiveRecord::Base.send :extend, VirtualTranslations::ClassMethods