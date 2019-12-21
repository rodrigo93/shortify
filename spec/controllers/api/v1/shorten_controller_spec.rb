require 'rails_helper'

RSpec.describe Api::V1::ShortenController, type: :controller do
  shared_context 'returning json content-type' do
    it 'should return a request with header Content-Type: "application/json"' do
      subject

      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  shared_context 'returning not found status' do
    it 'should return status 404 (not found)' do
      subject

      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe '#POST create' do
    context 'when everything is ok' do
      subject { post :create, params: params }

      context 'with the "shortcode"' do
        let(:sample_shortcode) { 'example' }
        let(:params) do
          {
              shortcode: sample_shortcode,
              url: 'example.com'
          }
        end

        it_should_behave_like 'returning json content-type'

        it 'should return status 201 (created)' do
          subject

          expect(response).to have_http_status(:created)
        end

        it 'should create a new Shorten' do
          expect { subject }.to change { Shorten.count }.by(1)
        end

        it 'should return the generated "shortcode"' do
          subject

          expect(response.body).to eq({shortcode: sample_shortcode}.to_json)
        end
      end

      context 'without the "shortcode"' do
        let(:params) { {url: 'example.com'} }

        it_should_behave_like 'returning json content-type'

        it 'should return status 201 (created)' do
          subject

          expect(response).to have_http_status(:created)
        end

        it 'should create a new Shorten' do
          expect { subject }.to change { Shorten.count }.by(1)
        end

        it 'should return the generated "shortcode"' do
          subject

          expect(JSON.parse(response.body)['shortcode']).to match(/\A^[0-9a-zA-Z_]{6}$\z/)
        end
      end
    end

    context 'when the "shortcode" is already in use' do
      subject { post :create, params: params }

      let(:used_shortcode) { 'ImInUse' }
      let(:some_url) { 'someurl.com' }

      let(:params) do
        {
            url: some_url,
            shortcode: used_shortcode
        }
      end

      before { Shorten.create!(shortcode: used_shortcode, url: 'example.com') }

      it_should_behave_like 'returning json content-type'

      it 'should return status 409 (conflict)' do
        subject

        expect(response).to have_http_status(:conflict)
      end

      it 'should return an intuitive error message' do
        subject

        expect(response.body).to eq({error: 'Shortcode has already been taken'}.to_json)
      end
    end

    context 'when the "shortcode" does not match the regexp' do
      subject { post :create, params: params }

      let(:params) do
        {
            url: 'magic.com',
            shortcode: invalid_shortcode
        }
      end

      ['', ' ', '    ', 'inv', 'no_', '__', '****', '?????'].each do |invalid_short|
        let(:invalid_shortcode) { invalid_short }

        it_should_behave_like 'returning json content-type'

        it "should return status 422 (unprocessable entity) for '#{invalid_short}' shortcode" do
          subject

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return 'The 'shortcode' must have only numbers and letters, with at least 4 characters' error message for '#{invalid_short}' shortcode" do
          subject

          expect(response.body).to eq({shortcode: ['The "shortcode" must have only numbers and letters, with at least 4 characters']}.to_json)
        end
      end
    end

    context 'when validating the "url"' do
      shared_context 'returning a bad request' do
        it 'should return error 400 (bad request)' do
          subject

          expect(response).to have_http_status(:bad_request)
        end
      end

      subject { post :create, params: params }

      context "and it's not present" do
        let(:params) { {shortcode: 'some-random-code'} }

        it_should_behave_like 'returning json content-type'

        it_should_behave_like 'returning a bad request'

        it 'should return error "URL can\'t be blank" message' do
          subject

          expect(response.body).to eq({url: "can't be blank"}.to_json)
        end
      end
    end
  end

  describe '#GET show' do
    subject { get :show, params: { shortcode: some_shortcode } }

    context 'when the Shorten exists' do
      let!(:shorten) { Shorten.create!(url: expected_url, shortcode: some_shortcode) }
      let(:expected_url) { 'findtheinvisiblecow.com' }
      let(:some_shortcode) { 'cowcow' }

      it_should_behave_like 'returning json content-type'

      it 'should return status 302 (found)' do
        subject

        expect(response).to have_http_status(:found)
      end

      it 'should return the Shorten "Location" (url)' do
        subject

        expect(JSON.parse(response.body)['Location']).to eq expected_url
      end

      it "should increase the Shorten's redirectCount" do
        expect(shorten.redirectCount).to eq 0

        subject

        expect(shorten.reload.redirectCount).to eq 1
      end

      it "should update the Shorten's lastSeenDate" do
        expect(shorten.lastSeenDate).to be_nil

        subject

        expect(shorten.reload.lastSeenDate).not_to be_nil
      end
    end

    context 'when the Shorten does not exist' do
      let(:some_shortcode) { 'imaginary_shortcode' }

      it_should_behave_like 'returning json content-type'

      it_should_behave_like 'returning not found status'
    end
  end

  describe '#GET stats' do
    subject { get :stats, params: { shortcode: a_shortcode } }

    context 'when the Shorten exists' do
      let(:start_date) { 2.days.ago }
      let(:last_seen_date) { Time.zone.now.change(usec: 0) }
      let(:redirect_count) { 123 }
      let(:a_shortcode) { 'example' }

      let!(:shorten) { Shorten.create!(url: 'example.com', shortcode: a_shortcode, lastSeenDate: last_seen_date, redirectCount: redirect_count) }

      it 'should return a response with status 200 (ok)' do
        subject

        expect(response).to have_http_status(:ok)
      end

      it 'should return the "startDate" in ISO8601 format' do
        subject

        expect(JSON.parse(response.body)['startDate']).to eq shorten.startDate.iso8601(5)
      end

      it 'should return the "lastSeenDate"' do
        subject

        expect(JSON.parse(response.body)['lastSeenDate']).to eq last_seen_date
      end

      it 'should return the "redirectCount"' do
        subject

        expect(JSON.parse(response.body)['lastSeenDate']).to eq redirect_count
      end
    end

    context 'when the Shorten does not exist' do
      let(:a_shortcode) { 'hello_world' }

      it_should_behave_like 'returning not found status'
    end
  end
end
