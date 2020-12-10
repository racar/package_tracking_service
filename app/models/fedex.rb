class Fedex < Carrier
  alias_attribute :tracking_number, :track_id
end
