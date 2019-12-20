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

      let(:params) { nil }

      # it_should_behave_like 'returning json content-type'

      xit 'should return status 201 (created)' do
        
      end

      xit 'should create a new Shorten' do
        
      end

      xit 'should return the generated "shortcode"' do

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

      let(:params) { nil }

      let(:regex) { /^[0-9a-zA-Z_]{4,}$/ }

      # it_should_behave_like 'returning json content-type'

      xit 'should return status 422 (unprocessable entity)' do
        
      end
    end

    context 'when the "url" is not present' do
      subject { post :create, params: params }

      let(:params) { nil }

      # it_should_behave_like 'returning json content-type'

      xit 'should return error 400 (bad request)' do
        
      end
    end
  end
end
