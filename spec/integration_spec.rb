require 'spec/spec_helper'

describe 'Integration' do
  before do
    Translation.delete_all
    UserTranslation.delete_all
  end

  it "manages different translations appropriatly" do
    User.create(:name_in_en=>'User1NameEn', :name_in_de=>'User1NameDe')
    User.create(:name_in_en=>'User2NameEn', :name_in_fr=>'User2NameFr')
    Product.create(:title=>'Product1TitleEn', :title_in_de=>'Product1TitleDe')

    User.first.translated_attributes = {}
    u = User.last
    u.translated_attributes = {:fr=>{:name=>'User1NameFr'}}
    u.save!

    UserTranslation.count.should == 3
    Translation.count.should == 2
    User.last.name.should == 'User1NameFr'
  end

  it "cleans up translations" do
    User.create!(:name=>'u1')
    Product.create!(:title=>'p1',:description=>'d1')
    Product.create!(:title=>'p2')

    Translation.count.should == 3
    UserTranslation.count.should == 1

    Product.destroy_all

    Translation.count.should == 0
    UserTranslation.count.should == 1

    User.destroy_all

    Translation.count.should == 0
    UserTranslation.count.should == 0
  end
end