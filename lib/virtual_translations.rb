module VirtualTranslations
  module ClassMethods
    def virtual_translations(*args)
      #store options
      cattr_accessor :virtual_translations_options
      options = args.extract_options! || {}
      self.virtual_translations_options = options.merge(:fields=>args)

      #create translations class
      table_name = options[:table_name] || :translations

      klass = Class.new(ActiveRecord::Base)
      Object.const_set(table_name.to_s.classify, klass)
      klass.set_table_name table_name
      klass.belongs_to :translateable, :polymorphic => true

      #set translations
      has_many :translations, :as => :translateable, :dependent => :delete_all, :class_name=>klass.name

      #include methods
      include VirtualTranslations::InstanceMethods
    end
  end

  module InstanceMethods
    def self.included(base)
      fields = base.virtual_translations_options[:fields]
      fields.each do |field|
        eval <<GETTER_AND_SETTER
          def #{field}(locale=I18n.locale)
            get_virtual_translation(locale, :#{field})
          end

          def #{field}=(value, locale=I18n.locale)
            set_virtual_translation locale, :#{field}, value
          end
GETTER_AND_SETTER
      end

      base.after_save :store_virtual_translations
    end

    def get_virtual_translation(locale, field)
      merge_db_translations_with_virtual
      virtual_translations_for(locale)[field]
    end

    def set_virtual_translation(locale, field, value)
      merge_db_translations_with_virtual
      return if virtual_translations_for(locale)[field] == value
      virtual_translations_for(locale)[field] = value
      @virtual_translations_changed = true
    end

    def virtual_translations
      merge_db_translations_with_virtual
      (@virtual_translations||{}).dup.freeze
    end

    def respond_to?(name, *args)
      return true if parse_virtual_tranlation_method(name)
      super
    end

    def method_missing(name, *args)
      field, locale = parse_virtual_tranlation_method(name)
      return super unless field
      if name.to_s.include? '=' #is setter ?
        send("#{field}=", args[0], locale)
      else
        send(field, locale)
      end
    end

    protected

    def store_virtual_translations
      return true unless @virtual_translations_changed
      translations.delete_all
      @virtual_translations.each do |locale, attributes|
        attributes.each do |attribute, value|
          next if value.blank?
          translations.create!(:attribute=>attribute, :text=>value, :language=>locale)
        end
      end
      @virtual_translations_changed = false
    end

    private

    def merge_db_translations_with_virtual
      return if new_record? or @db_translations_merged
      @db_translations_merged = true
      translations.all.each do |t|
        virtual_translations_for(t.language)[t.attribute] = t.text
      end
    end

    def parse_virtual_tranlation_method(name)
      return false if name.to_s !~ /^([a-zA-Z_]+)_in_([a-z]{2})[=]?$/
      field = $1; locale = $2
      fields = self.class.virtual_translations_options[:fields]
      return false unless fields.include? field.sub('=','').to_sym
      return field, locale
    end

    def virtual_translations_for(locale)
      @virtual_translations ||= {}.with_indifferent_access
      @virtual_translations[locale] ||= {}.with_indifferent_access
      @virtual_translations[locale]
    end
  end
end

ActiveRecord::Base.send :extend, VirtualTranslations::ClassMethods