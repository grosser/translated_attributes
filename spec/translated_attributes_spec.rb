require 'spec/spec_helper'

describe 'Translated attributes' do
  before do
    I18n.locale = :en
  end

  describe 'caching' do
    it "is nil when nothing is set" do
      Product.new.title.should == nil
      Product.new.description.should == nil
    end

    it 'can be set' do
      p = Product.new
      p.title = 'abc'
      p.title.should == 'abc'
    end

    it 'can be overwritten' do
      p = Product.new
      p.title = 'abc'
      p.title = 'def'
      p.title.should == 'def'
    end

    it "ca be unset" do
      p = Product.new
      p.title = 'abc'
      p.title = nil
      p.title.should == nil
    end

    it "sets the current language" do
      p = Product.new
      p.title = 'abc'
      p.title_in_en.should == 'abc'
    end

    it "can be set in different languages" do
      p = Product.new
      p.title = 'abc'
      p.title_in_de.should == nil
      I18n.locale = :de
      p.title = 'bcd'
      p.title_in_de.should == 'bcd'
    end

    it "returns current language when current can be found" do
      I18n.locale = :de
      p = Product.new
      p.title_in_de = 'abc'
      p.title_in_en = 'def'
      p.title.should == 'abc'
    end

    it "returns english translation when current cannot be found" do
      I18n.locale = :de
      p = Product.new
      p.title_in_en = 'abc'
      p.title.should == 'abc'
    end

    it "returns any translation when current and english cannot be found" do
      I18n.locale = :fr
      p = Product.new
      p.title_in_de = 'abc'
      p.title.should == 'abc'
    end
  end

  describe 'storing' do
    it "stores nothing when nothing was set" do
      lambda{ Product.create! }.should_not change(Translation, :count)
      Product.last.title.should == nil
    end

    it "stores column as translation on save" do
      lambda{ Product.create!(:title=>'x') }.should change(Translation, :count).by(+1)
    end

    it "stores nothing when blank was set" do
      lambda{ Product.create! :title=>'   ' }.should_not change(Translation, :count)
      Product.last.title.should == nil
    end

    it "creates no translation when validations fail" do
      p = Product.new :title=>'xxx'
      p.should_receive(:valid?).and_return false
      lambda{ p.save }.should_not change(Translation, :count)
    end

    it "is stored after save" do
      p = Product.create!(:title=>'1')
      p.title = '2'
      p.save!
      Product.last.title.should == '2'
    end

    it "does not create unecessary translations on change" do
      p = Product.create!(:title=>'1')
      lambda{
        p.title = '2'
        p.save!
      }.should_not change(Translation, :count)
    end

    it "does not update translations when nothing changed" do
      p = Product.create!(:title=>'xx')
      p.title = 'xx'
      lambda{ p.save }.should_not change{Translation.last.id}
    end

    it "works through update_attribute" do
      p = Product.create!(:title=>'xx', :description=>'dd')
      p.update_attribute(:title, 'yy')
      Product.last.title.should == 'yy'
      Product.last.description.should == 'dd'
    end

    it "works through update_attributes" do
      p = Product.create!(:title=>'xx', :description=>'dd')
      p.update_attributes(:title=>'yy')
      Product.last.title.should == 'yy'
      Product.last.description.should == 'dd'
    end

    it "works through attributes=" do
      p = Product.create!(:title=>'xx', :description=>'dd')
      p.attributes = {:title=>'yy'}
      p.save!
      Product.last.title.should == 'yy'
      Product.last.description.should == 'dd'
    end

    it "loads translations once" do
      Product.create!(:title=>'xx', :description=>'yy')
      p = Product.last
      p.translations.should_receive(:all).and_return []
      p.title.should == nil
      p.description.should == nil
    end

    it "deletes the existing translation when changing to blank" do
      p = Product.create!(:title=>'1')
      lambda{
        p.title = ''
        p.save!
      }.should change(Translation, :count).by(-1)
      Product.last.title.should == nil
    end

    it "can store multiple translations at once" do
      lambda{
        Product.create!(:title_in_de=>'Hallo', :title_in_en=>'Hello')
      }.should change(Translation, :count).by(+2)
      Product.last.title_in_de.should == 'Hallo'
      Product.last.title.should == 'Hello'
    end

    it "deletes translations when translatable is destroyed" do
      Translation.delete_all
      Product.create!(:title=>'t1')
      Product.create!(:title=>'t2',:description=>'d2')
      Translation.count.should == 3

      Product.last.destroy

      Translation.count.should == 1
      Translation.first.text.should == 't1'
    end

    it "is not influenced by reloading" do
      p = Product.create!(:title=>'t1', :description=>'d1')
      p.title = 't2'
      p.reload
      p.description = 'd2'
      p.save!
      Product.last.title.should == 't2'
      Product.last.description.should == 'd2'
    end
  end

  describe 'classes' do
    it "does not define them twice" do
      Translation.instance_variable_set '@test', 1
      class XXX < ActiveRecord::Base
        set_table_name :products
        translated_attributes :name
      end
      Translation.instance_variable_get('@test').should == 1
    end

    it "stores options seperately" do
      Shop.translated_attributes_options[:fields].should_not == Product.translated_attributes_options[:fields]
    end
  end

  describe 'different tables' do
    it "creates the model for each table_name" do
      Translation
      UserTranslation
    end

    it "creates translations in set table" do
      Product.create!(:title=>'yyy')
      Translation.last.text.should == 'yyy'

      User.create!(:name=>'xxx')
      UserTranslation.last.text.should == 'xxx'
    end
  end

  describe 'nil to blank' do
    it "converts all unfound fields to blank" do
      User.new.name.should == ''
    end
  end

  describe :translated_attributes do
    it "is a empty hash when nothing was set" do
      Product.new.translated_attributes.should == {}
    end

    it "can be modified" do
      Product.new.translated_attributes.should_not be_frozen
    end
  end

  describe :translated_attriutes= do
    it "stores all translations" do
      p = Product.create!
      p.translated_attributes = {:de=>{:title=>'de title',:description=>'de descr'}}
      p.title_in_de.should == 'de title'
      p.description_in_de.should == 'de descr'
      p.title_in_en.should == nil
    end

    it "overwrites existing translations" do
      p = Product.create!(:title=>'en title')
      p.translated_attributes = {:de=>{:title=>'de title',:description=>'de descr'}}
      p.title_in_de.should == 'de title'
      p.description_in_de.should == 'de descr'
      p.title_in_en.should == nil
    end

    it "stores and overwrites on save" do
      p = Product.create!(:title=>'en title')
      p.translated_attributes = {:de=>{:title=>'de title',:description=>'de descr'}}
      p.save!
      Product.last.title.should == 'de title'
      Product.last.title_in_de.should == 'de title'
    end

    it "does not store unknown attributes" do
      p = Product.new
      p.translated_attributes = {:de=>{:xxx=>'de title',:description=>'de descr'}}
      lambda{
        p.save!
      }.should change(Translation, :count).by(+1)
    end

    it "does not alter the given hash" do
      p = Product.create!(:title=>'en title')
      hash = {:de=>{:title=>'de title',:description=>'de descr'}}
      p.translated_attributes = hash
      hash['de'].should == nil #not converted to indifferent access
      hash[:de][:title].should == 'de title' #still has all attributes
    end

    it "stores given hash indifferent" do
      p = Product.new
      p.translated_attributes = {'de'=>{'title'=>'title de'}}
      p.translated_attributes[:de][:title].should == 'title de'
    end
  end

  describe :method_missing do
    it "ignores calls without _in_" do
      lambda{Product.new.title_xxx}.should raise_error
    end
    it "ignores calls with a non-supported attribute" do
      lambda{Product.new.foo_in_de}.should raise_error
    end
  end

  describe :respond_to? do
    it "ignores calls without _in_" do
      Product.new.respond_to?(:title_xx_xx).should == false
    end

    it "ignores calls with a non-supported attribute" do
      Product.new.respond_to?(:foo_in_de).should == false
    end

    it "responds to translated column" do
      Product.new.respond_to?(:title_in_en).should == true
    end

    it "responds to normal methods" do
      Product.new.respond_to?(:new_record?).should == true
    end
  end
end