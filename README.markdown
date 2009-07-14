Problem
=======
Atm there are 2 ways for making a Model translateable that I know of:
 - have a copy of a model, where the copy has a language and all fields mirrored
 - have all the translations on the same model
both are not very effective when it comes to huge data ammounts and need frequent updates/migrations, which is hard with large datasets.

Solution
========
Create 'virtual' attributes, that can be added on the fly without overhead or migrations, while storing all the data in a generic translations table that never has to change.
They keep the attatched model light and small.

Validations work like normal, you can validate on the current field (e.g. title) or any translation (e.g. title_en)

Usage
=====
Setup
    script/plugin install git://github.com/grosser/translated_attributes.git

    class Product < ActiveRecord::Base
      translated_attributes :description, :title, :additional_info
    end

Setting / getting values (without persisting them)
    product.title -> 'Hello' #when I18n.locale is :en
    product.title_in_fr -> 'Bonyour'
    product.title_in_de -> 'Hallo'

    product.title = 'Simple setting'
    product.title_in_de = 'Spezifisches speichern'

    product.title=('Specific setting', :en)
    product.title(:en) -> 'Specific setting'

Usage with saving works exactly like normal saving, e.g. new/create/update_attributes...

Options
=======
    :table_name => 'user_translations' #default is translations

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...