require 'spec_helper'

describe Food do

  subject { build(:food) }

  it { should have_many(:genes) }
  it { should have_many(:traits).through(:genes) }

  it { should validate_presence_of :name }

  describe "#trait_names" do

    it "should return an array of trait name words" do
      subject.traits << create(:trait, name: 'salty')
      subject.traits << create(:trait, name: 'sweet')
      subject.save

      subject.trait_names.sort.should == %w( salty sweet )
    end
  end

  describe "#trait_names=" do

    it "should reuse existing traits" do
      create(:trait, name: 'salty')
      expect { subject.trait_names = %w( salty ); subject.save }.to_not change { Trait.count }
      subject.traits.first.name.should == 'salty'
    end

    it "should create new trait names if necessary" do
      expect { subject.trait_names = %w( salty ); subject.save }.to change { Trait.count }.by(1)
      subject.traits.first.name.should == 'salty'
    end

    it "should downcase trait names that it creates" do
      subject.trait_names = %w( SaLtY )
      subject.traits.first.name.should == 'salty'
    end
  end
end
