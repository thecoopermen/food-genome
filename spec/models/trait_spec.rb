require 'spec_helper'

describe Trait do
  it { should have_many(:genes) }
  it { should have_many(:foods).through(:genes) }

  it { should validate_presence_of   :name }
  it { should validate_uniqueness_of :name }
end
