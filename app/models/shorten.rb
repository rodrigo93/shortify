class Shorten < ApplicationRecord

  validates_numericality_of :redirectCount, greater_than_or_equal_to: 0
  validates_presence_of :url, :shortcode
  validates_uniqueness_of :shortcode, case_sensitive: true

  def start_date_iso_8601
    startDate&.iso8601(5)
  end

end
