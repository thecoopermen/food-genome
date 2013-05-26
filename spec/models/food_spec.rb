require 'spec_helper'

describe Food do
  it { should have_many(:genes) }
  it { should have_many(:traits).through(:genes) }
end
