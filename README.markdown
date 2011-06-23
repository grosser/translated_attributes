Rails plugin/ActiveRecord gem that creates 'virtual' attributes, which can be added on the fly without overhead or migrations, while storing all the data in a never-changing translations table.
This keeps the attatched model light and allows to add/remove fields on the fly without migrations.

Validations work like normal with current field (e.g. title) or any translation (e.g. title_in_en)

Usage
=====
 - As Rails plugin  `rails plugin install git://github.com/grosser/translated_attributes.git`
 - As gem `gem install translated_attributes`
 - generate migrations: `rails generate translated_attributes`(Rails2: [do it by hand](http://github.com/grosser/translated_attributes/blob/master/lib/generators/translated_attributes/templates/migration.rb))
 - `rake db:migrate`

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
    :table_name => 'user_translations', # default is translations
    :nil_to_blank => true, # return unfound translations as blank strings ('') instead of nil (default false),
    :translatable_name => 'translated' # name of the associated translatable (Product has_many :translations a Translation belongs_to XXX), default is :translatable
    :attribute_column => 'attribute' # switch to the old Rails 2 default (default: translated_attribute)

Author
======

###Contributors
 - [Stefano Diem Benatti](http://github.com/teonimesic)

[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...
