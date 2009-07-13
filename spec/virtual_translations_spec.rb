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
end