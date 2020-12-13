require 'rails_helper'

RSpec.describe TrackFedexJob, type: :job do
  fixtures :carriers
  describe 'When track status from fedex api' do
    let(:package) { FedexService.find_by(tracking_number: '111111') }
    subject { package.status }

    before do
      tracking_info = instance_double("TrackingInformation", :status => 'Delivered', :details => details)
      allow_any_instance_of(Fedex::Shipment).to receive(:track).and_return([tracking_info])
    end

    before do
      TrackFedexJob.perform_now(package)
    end

    it 'update status from package' do
      expect(subject).to eq 'DELIVERED'
    end
  end

  def details
    { notification: { severity: 'SUCCESS', source: 'trck', code: '0', message: 'Request was successfully processed.', localized_message: 'Request was successfully processed.' },
      tracking_number: '111111',
      tracking_number_unique_identifier: '12013~111111~FDEG',
      status_code: 'DL',
      status_description: 'Delivered',
      carrier_code: 'FDXG',
      other_identifiers: { value: 'PO#174724', type: 'CUSTOMER_REFERENCE' },
      service_info: 'FedEx Ground',
      service_type: 'FEDEX_GROUND',
      package_weight: { units: 'LB', value: '21.5' },
      package_dimensions: { length: '22', width: '17', height: '10', units: 'IN' },
      packaging: 'Package',
      packaging_type: 'YOUR_PACKAGING',
      package_sequence_number: '1',
      package_count: '1',
      shipper_address: { city: 'POST FALLS', state_or_province_code: 'ID', country_code: 'US', residential: 'false' },
      origin_location_address: { city: 'SPOKANE', state_or_province_code: 'WA', country_code: 'US', residential: 'false' },
      ship_timestamp: '2020-08-15T000000',
      destination_address: { city: 'NORTON', state_or_province_code: 'VA', country_code: 'US', residential: 'false' },
      actual_delivery_timestamp: '2014-01-09T133100-0500',
      actual_delivery_address: { city: 'Norton', state_or_province_code: 'VA', country_code: 'US', residential: 'false' },
      delivery_location_type: 'SHIPPING_RECEIVING',
      delivery_location_description: 'Shipping/Receiving',
      delivery_signature_name: 'ROLLINS',
      signature_proof_of_delivery_available: 'true',
      redirect_to_hold_eligibility: 'INELIGIBLE',
      events: [{ timestamp: '2014-01-09T133100-0500',
                 event_type: 'DL',
                 event_description: 'Delivered',
                 address: { city: 'Norton', state_or_province_code: 'VA', postal_code: '24273', country_code: 'US', residential: 'false' },
                 arrival_location: 'DELIVERY_LOCATION' },
                { timestamp: '2014-01-09T041800-0500',
                  event_type: 'OD',
                  event_description: 'On FedEx vehicle for delivery',
                  address: { city: 'KINGSPORT', state_or_province_code: 'TN', postal_code: '37663', country_code: 'US', residential: 'false' },
                  arrival_location: 'VEHICLE' },
                { timestamp: '2014-01-09T040900-0500',
                  event_type: 'AR',
                  event_description: 'At local FedEx facility',
                  address: { city: 'KINGSPORT', state_or_province_code: 'TN', postal_code: '37663', country_code: 'US', residential: 'false' },
                  arrival_location: 'DESTINATION_FEDEX_FACILITY' },
                { timestamp: '2014-01-08T232600-0500',
                  event_type: 'IT',
                  event_description: 'In transit',
                  address: { city: 'KNOXVILLE', state_or_province_code: 'TN', postal_code: '37921', country_code: 'US', residential: 'false' },
                  arrival_location: 'FEDEX_FACILITY' },
                { timestamp: '2014-01-08T181407-0600',
                  event_type: 'DP',
                  event_description: 'Departed FedEx location',
                  address: { city: 'NASHVILLE', state_or_province_code: 'TN', postal_code: '37207', country_code: 'US', residential: 'false'},
                  arrival_location: 'FEDEX_FACILITY' },
                { timestamp: '2014-01-08T151600-0600',
                  event_type: 'AR',
                  event_description: 'Arrived at FedEx location',
                  address: { city: 'NASHVILLE', state_or_province_code: 'TN', postal_code: '37207', country_code: 'US', residential: 'false'},
                  arrival_location: 'FEDEX_FACILITY' },
                { timestamp: '2014-01-07T002900-0600',
                  event_type: 'AR',
                  event_description: 'Arrived at FedEx location',
                  address: { city: 'CHICAGO', state_or_province_code: 'IL', postal_code: '60638', country_code: 'US', residential: 'false'},
                  arrival_location: 'FEDEX_FACILITY' },
                { timestamp: '2014-01-03T191230-0800',
                  event_type: 'DP',
                  event_description: 'Left FedEx origin facility',
                  address: {city: 'SPOKANE', state_or_province_code: 'WA', postal_code: '99216', country_code: 'US', residential: 'false' },
                  arrival_location: 'ORIGIN_FEDEX_FACILITY' },
                { timestamp: '2014-01-03T183300-0800',
                  event_type: 'AR',
                  event_description: 'Arrived at FedEx location',
                  address: { city: 'SPOKANE', state_or_province_code: 'WA', postal_code: '99216', country_code: 'US', residential: 'false' },
                  arrival_location: 'FEDEX_FACILITY' },
                { timestamp: '2014-01-03T150000-0800',
                  event_type: 'PU',
                  event_description: 'Picked up',
                  address: {city: 'SPOKANE', state_or_province_code: 'WA', postal_code: '99216', country_code: 'US', residential: 'false' },
                  arrival_location: 'PICKUP_LOCATION' },
                { timestamp: '2014-01-03T143100-0800',
                  event_type: 'OC',
                  event_description: 'Shipment information sent to FedEx',
                  address: { postal_code: '83854', country_code: 'US', residential: 'false' },
                  arrival_location: 'CUSTOMER' }]
    }
  end
end
