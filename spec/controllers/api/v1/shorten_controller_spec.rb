require 'rails_helper'

RSpec.describe Api::V1::ShortenController, type: :controller do
  describe '#POST create' do
    shared_context 'returning json content-type' do
      it 'should return a request with header Content-Type: "application/json"' do
        subject

        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'when everything is ok' do
      subject { post :create, params: params }

      context 'with the "shortcode"' do
        let(:sample_shortcode) { 'example' }
        let(:params) do
          {
              shorten: {
                  shortcode: sample_shortcode,
                  url: 'example.com'
              }
          }
        end

        it_should_behave_like 'returning json content-type'

        it 'should return status 201 (created)' do
          subject

          expect(response).to have_http_status(:created)
        end

        it 'should create a new Shorten' do
          expect{ subject }.to change{ Shorten.count }.by(1)
        end

        it 'should return the generated "shortcode"' do
          subject

          expect(response.body).to eq({ shortcode: sample_shortcode }.to_json)
        end
      end

      context 'without the "shortcode"' do
        let(:params) do
          {
              shorten: {
                  url: 'example.com'
              }
          }
        end

        it_should_behave_like 'returning json content-type'

        it 'should return status 201 (created)' do
          subject

          expect(response).to have_http_status(:created)
        end

        it 'should create a new Shorten' do
          expect{ subject }.to change{ Shorten.count }.by(1)
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
            shorten: {
                url: some_url,
                shortcode: used_shortcode
            }
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

        error_message = 'Shortcode has already been taken'

        expect(response.body).to eq({ error: error_message }.to_json)
      end
    end

    context 'when the "shortcode" does not match the regexp' do
      subject { post :create, params: params }

      let(:params) do
        {
            shorten: {
                url: 'magic.com',
                shortcode: invalid_shortcode
            }
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
        let(:params) do
          {
              shorten: {
                  shortcode: 'some-random-code'
              }
          }
        end

        it_should_behave_like 'returning json content-type'

        it_should_behave_like 'returning a bad request'

        it 'should return error "URL can\'t be blank" message' do
          subject

          expect(response.body).to eq({url: "can't be blank"}.to_json)
        end
      end
    end
  end
end
