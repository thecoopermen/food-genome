require 'spec_helper'

describe Gene do
  it { should belong_to(:food) }
  it { should belong_to(:trait) }

  it { should validate_presence_of :food }
  it { should validate_presence_of :trait }
end
