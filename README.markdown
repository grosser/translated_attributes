Rails plugin/ActiveRecord gem that creates 'virtual' attributes, which can be added on the fly without overhead or migrations, while storing all the data in a never-changing translations table.
This keeps the attatched model light and allows to add/remove fields on the fly without migrations.

Validations work like normal with current field (e.g. title) or any translation (e.g. title_in_en)

Usage
=====
 - As Rails plugin  `script/plugin install git://github.com/grosser/translated_attributes.git`
 - As gem `sudo gem install grosser-translated_attributes --source http://gems.github.com/`
 - execute MIGRATION

Adding attributes:
    class Product < ActiveRecord::Base
      translated_attributes :description, :title, :additional_info
    end

Setting / getting
    #getter
    product.title -> 'Hello' #when I18n.locale is :en
    product.title_in_fr -> 'Bonyour'
    product.title_in_de -> 'Hallo'

    #setter
    product.title = 'Simple setting' #sets title_in_en when I18n.locale == :en
    product.title_in_de = 'Spezifisches speichern'

    #generic setter/getter
    product.set_title('Specific setting', :en)
    product.get_title(:en) -> 'Specific setting'

Usage with saving works exactly like normal saving, e.g. new/create/update_attributes...
    Product.new(:title_in_en=>'Hello').save!
    product.update_attribute(:title, 'Goodbye')

 - Translations are stored on 'save'
 - blank translations are NOT stored
 - translations are accessable via .translations or as hash via .translated_attributes

Options
=======
    translated_attributes :title, :heading,
    :table_name => 'user_translations', #default is translations
    :nil_to_blank => true, #return unfound translations as blank strings ('') instead of nil (default false),
    :translatable_name => 'translated' #name of the associated translatable (Product has_many :translations a Translation belongs_to XXX), default is :translatable
Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...