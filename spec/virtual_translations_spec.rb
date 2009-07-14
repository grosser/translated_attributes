require 'spec/spec_helper'

describe 'Virtual Translations' do
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

    it "updates the existing translation on change" do
      p = Product.create!(:title=>'1')
      lambda{
        p.title = '2'
        p.save!
      }.should_not change(Translation, :count)
    end

    it "does not update translations when nothing changed" do
      p = Product.create!(:title=>'xx')
      lambda{ p.save }.should_not change{Translation.last.id}
    end

    it "works through update_attribute" do
      p = Product.create!(:title=>'xx')
      p.update_attribute(:title, 'yy')
      Product.last.title.should == 'yy'
    end

    it "works through update_attributes" do
      p = Product.create!(:title=>'xx')
      p.update_attributes(:title=>'yy')
      Product.last.title.should == 'yy'
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

  describe :virtual_translations do
    it "is a empty hash when nothing was set" do
      Product.new.virtual_translations.should == {}
    end

    it "cannot be modified" do
      Product.new.virtual_translations.should be_frozen
    end

    it "does not freeze the original" do
      p = Product.new
      p.virtual_translations
      p.instance_variable_get('@virtual_translations').should_not be_frozen
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