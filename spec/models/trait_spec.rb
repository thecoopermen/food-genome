require 'spec_helper'

describe Trait do
  it { should have_many(:genes) }
  it { should have_many(:foods).through(:genes) }
end
