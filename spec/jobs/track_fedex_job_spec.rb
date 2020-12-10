require 'rails_helper'

RSpec.describe TrackFedexJob, type: :job do
  fixtures :carriers
  describe 'When track status from fedex api' do
    subject { Fedex.find_by(tracking_number: '111111') }

    before do
      TrackFedexJob.perform_now(subject)
    end

    it 'update status from package' do
      expect(subject.status).to eq 'DELIVERED'
    end
  end
end
