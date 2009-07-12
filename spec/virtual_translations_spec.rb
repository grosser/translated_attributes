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
    it "is not stored when validations fail"
    it "is stored after save"
  end
end