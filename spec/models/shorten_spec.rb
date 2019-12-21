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
  let(:redirect_count)  { 0 }

  describe 'validations' do
    it { is_expected.not_to allow_value('', '    ', 'a', 'aa', 'aaa').for(:shortcode).with_message('The "shortcode" must have only numbers and letters, with at least 4 characters')}
    it { is_expected.to allow_value('exam', 'exam_ple', '3x4_mpl3', 'e_x_4_m_p_l_3', '____').for(:shortcode).with_message('The "shortcode" must have only numbers and letters, with at least 4 characters')}
    it { is_expected.to validate_presence_of(:shortcode) }
    it { is_expected.to validate_uniqueness_of(:shortcode) }

    it { is_expected.to validate_presence_of(:url) }

    it { is_expected.to validate_numericality_of(:redirectCount).is_greater_than_or_equal_to(0) }
  end

  describe 'start_date_iso_8601' do
    context 'when it has a "startDate"' do
      let(:start_date)        { expect_date_time }
      let(:expect_date_time)  { "2019-12-16T12:44:54.53970Z" }

      it 'should return the "startDate" in the ISO8601 format with a precision of 5 fractional seconds' do
        expect(subject.start_date_iso_8601).to eq expect_date_time
      end
    end

    context 'when does not have a "startDate"' do
      let(:start_date) { nil }

      it 'should return "nil"' do
        expect(subject.start_date_iso_8601).to be_nil
      end
    end
  end

  describe '#register_redirect!' do
    let(:expected_time) { Time.zone.now.change(usec: 0) }

    before { subject.save }

    it 'should increase "redirectCount" by one' do
      expect(subject.redirectCount).to be_zero

      subject.register_redirect!

      expect(subject.reload.redirectCount).to eq 1
    end

    it 'should update the "lastSeenDate"' do
      Timecop.freeze(expected_time) do
        expect(subject.lastSeenDate).to be_nil

        subject.register_redirect!

        expect(subject.reload.lastSeenDate).to eq expected_time
      end
    end
  end

  describe '#register_redirect' do
    let(:expected_time) { Time.zone.now.change(usec: 0) }

    before { subject.save }

    it 'should increase "redirectCount" by one, but not persist it' do
      expect(subject.redirectCount).to be_zero

      subject.register_redirect

      expect(subject.redirectCount).to eq 1

      expect(subject.reload.redirectCount).to be_zero
    end

    it 'should update the "lastSeenDate", but not persist it' do
      Timecop.freeze(expected_time) do
        expect(subject.lastSeenDate).to be_nil

        subject.register_redirect

        expect(subject.lastSeenDate).to eq expected_time

        expect(subject.reload.lastSeenDate).to be_nil
      end
    end
  end
end
