require 'spec_helper'

describe Gene do
  it { should belong_to(:food) }
  it { should belong_to(:trait) }
end
