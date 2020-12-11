require 'rails_helper'

RSpec.describe FedexService, type: :model do
  let(:add_package) do
    described_class.new(status: 'CREATED',
                        tracking_number: '12345').save

  end

  before do
    add_package
  end

  subject { Carrier.find_by(track_id: '12345') }

  it do
    is_expected.not_to be_nil
    expect(subject.type).to eq 'FedexService'
  end
end
