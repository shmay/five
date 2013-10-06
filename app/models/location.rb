require 'geokit'

class Location < ActiveRecord::Base
  acts_as_mappable

  after_save :geocode_address
  belongs_to :user
  belongs_to :group
  belongs_to :event

  def map_address
    "#{self.address}, #{self.city}, #{self.state}"
  end

  def profile_address
    "#{city}, #{zip} #{state}, #{country}"
  end

  def geocode_address
    if self.zip and self.zip.length > 0 and not self.lat
      a = Geokit::Geocoders::Google3Geocoder.geocode self.zip.to_s

      if a.success
        self.lat = a.lat
        self.lng = a.lng
        self.country = a.country
        self.state = a.state
        self.city = a.city
        self.save
      end
    end
  end

  def slugged_city
    city.downcase.gsub(/\s/, '_')
  end

end
