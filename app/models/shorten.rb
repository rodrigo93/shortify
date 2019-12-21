class Shorten < ApplicationRecord
  validates_format_of :shortcode,
                      with: /\A^[0-9a-zA-Z_]{4,}$\z/,
                      message: 'The "shortcode" must have only numbers and letters, with at least 4 characters'
  validates_numericality_of :redirectCount, greater_than_or_equal_to: 0
  validates_presence_of :url, :shortcode
  validates_uniqueness_of :shortcode, case_sensitive: true

  def register_redirect!
    count_incremented = redirectCount + 1

    update_attributes(redirectCount: count_incremented, lastSeenDate: Time.zone.now)
  end

  def register_redirect
    self.redirectCount = redirectCount + 1
    self.lastSeenDate = Time.zone.now
  end

  def start_date_iso_8601
    startDate&.iso8601(5)
  end
end
