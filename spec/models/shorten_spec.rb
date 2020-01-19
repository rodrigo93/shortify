require 'rails_helper'

RSpec.describe Shorten, type: :model do
  subject do
    Shorten.new(
        url: url,
        shortcode: shortcode,
        start_date: start_date,
        last_seen_date: last_seen_date,
        redirect_count: redirect_count
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

    it { is_expected.to validate_presence_of(:url) }

    it { is_expected.to validate_numericality_of(:redirect_count).is_greater_than_or_equal_to(0) }
  end

  describe 'start_date_iso_8601' do
    context 'when it has a "start_date"' do
      let(:start_date)        { expect_date_time }
      let(:expect_date_time)  { "2019-12-16T12:44:54.53970Z" }

      it 'should return the "start_date" in the ISO8601 format with a precision of 5 fractional seconds' do
        expect(subject.start_date_iso_8601).to eq expect_date_time
      end
    end

    context 'when does not have a "start_date"' do
      let(:start_date) { nil }

      it 'should return "nil"' do
        expect(subject.start_date_iso_8601).to be_nil
      end
    end
  end

  describe '#register_redirect!' do
    let(:expected_time) { Time.zone.now.change(usec: 0) }

    before { subject.save }

    it 'should increase "redirect_count" by one' do
      expect(subject.redirect_count).to be_zero

      subject.register_redirect!

      expect(subject.reload.redirect_count).to eq 1
    end

    it 'should update the "last_seen_date"' do
      Timecop.freeze(expected_time) do
        expect(subject.last_seen_date).to be_nil

        subject.register_redirect!

        expect(subject.reload.last_seen_date).to eq expected_time
      end
    end
  end

  describe '#register_redirect' do
    let(:expected_time) { Time.zone.now.change(usec: 0) }

    before { subject.save }

    it 'should increase "redirect_count" by one, but not persist it' do
      expect(subject.redirect_count).to be_zero

      subject.register_redirect

      expect(subject.redirect_count).to eq 1

      expect(subject.reload.redirect_count).to be_zero
    end

    it 'should update the "last_seen_date", but not persist it' do
      Timecop.freeze(expected_time) do
        expect(subject.last_seen_date).to be_nil

        subject.register_redirect

        expect(subject.last_seen_date).to eq expected_time

        expect(subject.reload.last_seen_date).to be_nil
      end
    end
  end
end
