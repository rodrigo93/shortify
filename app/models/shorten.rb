class Shorten < ApplicationRecord
  before_validation :generate_random_unique_shortcode, if: -> { self.shortcode.nil? }

  before_save :set_start_date

  validates_format_of :shortcode,
                      with: /\A^[0-9a-zA-Z_]{4,}$\z/,
                      message: 'The "shortcode" must have only numbers and letters, with at least 4 characters'
  validates_numericality_of :redirect_count, greater_than_or_equal_to: 0
  validates_presence_of :url

  def register_redirect!
    count_incremented = redirect_count + 1

    update_attributes(redirect_count: count_incremented, last_seen_date: Time.zone.now)
  end

  def register_redirect
    self.redirect_count = redirect_count + 1
    self.last_seen_date = Time.zone.now
  end

  def start_date_iso_8601
    start_date&.iso8601(5)
  end

  private

  def generate_random_unique_shortcode
    self.shortcode = loop do
      random_short = SecureRandom.hex(3)
      break random_short unless self.class.exists?(shortcode: random_short)
    end
  end

  def set_start_date
    self.start_date = Time.zone.now
  end
end
