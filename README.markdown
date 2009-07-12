Problem
=======
Atm there are 2 ways for making a Model translateable:
 - have a copy of this model, where the copy has a language and all fields mirrored
 - have all the translations on the same model
both are not very effective when it comes to huge data ammounts and need frequent updates/migrations, which is hard with large datasets.

Solution
========
Create virtual attributes, that can be added on the fly without overhead or migrations, while storing all the data in a generic translations table that never has to change.
They keep the attatched model light and small.

Validations work like normal, you can validate on the current field (e.g. title) or any translation (e.g. title_en)

Usage
=====
    --STILL ALPHA BEWARE--
    script/plugin install git://github.com/grosser/virtual_translations.git

    class Product < ActiveRecord::Base
      virtual_translations :description, :title, :additional_info
    end

    product.title -> 'Hello' #I18n.locale == :en
    product.title_fr -> 'Bonyour'
    product.title_de -> 'Hallo'

    product.title = 'Simple setting'
    product.title_de = 'Spezifisches speichern'
    --STILL ALPHA BEWARE--

Options
=======
    :table_name => 'virtual_translations' #default is translations

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...