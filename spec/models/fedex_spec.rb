require 'rails_helper'

RSpec.describe Fedex, type: :model do
  let(:add_package) do
    described_class.create(status: 'CREATED',
                           tracking_number: '12345')
  end

  before do
    add_package
  end

  subject { Carrier.find_by(track_id: '12345') }

  it { is_expected.not_to be_nil }
end
