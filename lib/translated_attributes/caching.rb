# include into your AR models to get caching (expires when models updated_at changes)
module TranslatedAttributes::Caching
  def self.included(base)
    base.class_eval do
      def merge_db_translations_with_instance_variable_with_cache
        key = "translated_attributes_#{cache_key}"
        if cached = Rails.cache.read key
          @translated_attributes = cached
          @db_translations_merged = true
        else
          merge_db_translations_with_instance_variable_without_cache
          Rails.cache.write key, @translated_attributes
        end
      end
      alias_method_chain :merge_db_translations_with_instance_variable, :cache
    end
  end
end
