class Invoice < ApplicationRecord
  geocoded_by :address_start, latitude: :latitude_start,
    longitude: :longitude_start
  after_validation :custom_reverse_geocode, :custom_geocode, :geocode

  has_many :user_invoices, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :invoice_histories, dependent: :destroy

  belongs_to :user

  enum status: [:init, :waitting, :shipping, :shipped, :finished, :cancel]

  private
  def custom_geocode
    self.latitude_start, self.longitude_start = Geocoder.coordinates address_start
    self.latitude_finish, self.longitude_finish = Geocoder.coordinates address_finish
  end

  def custom_reverse_geocode
    self.address_start = Geocoder.search([latitude_start, longitude_start])
      .first.data["formatted_address"] if
      latitude_start.present? && longitude_start.present?
    self.address_finish = Geocoder.search([latitude_finish, longitude_finish])
      .first.data["formatted_address"] if
      latitude_finish.present? && longitude_finish.present?
  end
end
