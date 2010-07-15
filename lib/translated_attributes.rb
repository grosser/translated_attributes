module TranslatedAttributes
  module ClassMethods
    # translated_attributes :title, :description, :table_name=>'my_translations'
    def translated_attributes(*args)
      #store options
      cattr_accessor :translated_attributes_options
      options = args.extract_options! || {}
      self.translated_attributes_options = options.merge(:fields=>args.map(&:to_sym))

      #create translations class
      table_name = options[:table_name] || :translations
      class_name = table_name.to_s.classify

      associated = options[:translatable_name] || :translatable
      begin
        klass = Object.const_get(class_name)
      rescue
        klass = Class.new(ActiveRecord::Base)
        Object.const_set(class_name, klass)
        klass.set_table_name table_name
        klass.belongs_to associated, :polymorphic => true
      end

      #set translations
      has_many :translations, :as => associated, :dependent => :delete_all, :class_name=>klass.name

      #include methods
      include TranslatedAttributes::InstanceMethods
    end
  end

  module InstanceMethods
    def self.included(base)
      fields = base.translated_attributes_options[:fields]
      fields.each do |field|
        base.class_eval <<-GETTER_AND_SETTER
          def get_#{field}(locale=nil)
            get_translated_attribute(locale, :#{field})
          end

          def set_#{field}(value, locale=I18n.locale)
            set_translated_attribute(locale, :#{field}, value)
          end

          #generic aliases (and since e.g. title=(a,b) would not be possible)
          alias #{field} get_#{field}
          alias #{field}= set_#{field}
        GETTER_AND_SETTER
      end

      base.after_save :store_translated_attributes
    end

    def get_translated_attribute(locale, field)
      text = if locale
        translated_attributes_for(locale)[field]
      else
        #try to find anything...
        #current, english, anything else
        found = translated_attributes_for(I18n.locale)[field] || translated_attributes_for(:en)[field]
        if found
          found
        else
          found = translated_attributes.detect{|locale, attributes| not attributes[field].blank?}
          found ? found[1][field] : nil
        end
      end

      if self.class.translated_attributes_options[:nil_to_blank]
        text || ''
      else
        text
      end
    end

    def set_translated_attribute(locale, field, value)
      old_value = translated_attributes_for(locale)[field]
      return if old_value.to_s == value.to_s
      changed_attributes.merge!("#{field}_in_#{locale}" => old_value)
      translated_attributes_for(locale)[field] = value
      @translated_attributes_changed = true
    end

    def translated_attributes
      return @translated_attributes if @translated_attributes
      merge_db_translations_with_instance_variable
      @translated_attributes ||= {}.with_indifferent_access
    end

    def translated_attributes= hash
      @db_translations_merged = true #do not overwrite what we set here
      @translated_attributes_changed = true #store changes we made
      @translated_attributes = hash.with_indifferent_access
    end

    def respond_to?(name, *args)
      return true if parse_translated_attribute_method(name)
      super
    end

    def method_missing(name, *args)
      field, locale = parse_translated_attribute_method(name)
      return super unless field
      if name.to_s.include? '=' #is setter ?
        send("set_#{field}", args[0], locale)
      else
        send("get_#{field}", locale)
      end
    end

    protected

    def store_translated_attributes
      return true unless @translated_attributes_changed
      translations.delete_all
      @translated_attributes.each do |locale, attributes|
        attributes.each do |attribute, value|
          next if value.blank?
          next unless self.class.translated_attributes_options[:fields].include? attribute.to_sym
          translations.create!(:attribute=>attribute, :text=>value, :language=>locale)
        end
      end
      @translated_attributes_changed = false
    end

    private

    def merge_db_translations_with_instance_variable
      return if new_record? or @db_translations_merged
      @db_translations_merged = true
      translations.each do |t|
        translated_attributes_for(t.language)[t.attribute] = t.text
      end
    end

    def parse_translated_attribute_method(name)
      return false if name.to_s !~ /^([a-zA-Z_]+)_in_([a-z]{2})[=]?$/
      field = $1; locale = $2
      return false unless is_translated_attribute?(field)
      return field, locale
    end

    def is_translated_attribute?(method_name)
      fields = self.class.translated_attributes_options[:fields]
      fields.include? method_name.sub('=','').to_sym
    end

    def translated_attributes_for(locale)
      translated_attributes[locale] ||= {}.with_indifferent_access
      translated_attributes[locale]
    end
  end
end

ActiveRecord::Base.send :extend, TranslatedAttributes::ClassMethods
