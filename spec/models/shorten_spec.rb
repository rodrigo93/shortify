require 'rails_helper'

RSpec.describe Shorten, type: :model do
  # I could have used FactoryBot for this, but since we only have one class
  # I think that using it would be overkill.
  subject do
    Shorten.new(
        url: url,
        shortcode: shortcode,
        startDate: start_date,
        lastSeenDate: last_seen_date,
        redirectCount: redirect_count
    )
  end

  let(:url)             { 'https://rodrigo-marques.com' }
  let(:shortcode)       { 'marques' }
  let(:start_date)      { '2019-12-12T12:15:00.00000Z' }
  let(:last_seen_date)  { nil }
  let(:redirect_count)  { nil }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:shortcode) }
    it { is_expected.to validate_presence_of(:shortcode) }

    it { is_expected.to validate_presence_of(:url) }

    it { is_expected.to validate_numericality_of(:redirectCount).is_greater_than_or_equal_to(0) }
  end

  describe 'start_date_iso_8601' do
    let(:start_date)        { expect_date_time }
    let(:expect_date_time)  { "2019-12-16T12:44:54.53970Z" }

    it 'should return the "startDate" in the ISO8601 format' do
      expect(subject.start_date_iso_8601).to eq expect_date_time
    end
  end

  describe '#register_redirect!' do
    it 'should increase "redirectCount" by one' do
      expect(subject.redirectCount).to be_nil

      subject.register_redirect

      expect(subject.redirectCount).to eq 1
    end

    it 'should update the "lastSeenDate"' do
      Timecop.freeze(1.second.from_now) do
        expect(subject.lastSeenDate).to be_nil

        subject.register_redirect!

        expect(subject.lastSeenDate).to eq Time.zone.now
      end
    end
  end
end
