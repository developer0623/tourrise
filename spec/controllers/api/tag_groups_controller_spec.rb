require 'rails_helper'

describe Api::TagGroupsController, type: :controller do
  login_user

  describe '[GET] index' do
    let(:context) { double(:context, success?: true, tag_groups: tag_groups) }
    let(:tag_groups) { [tag_group] }
    let(:tag_group) { TagGroup.new }

    before do
      allow(TagGroups::ListTagGroups).to receive(:call) { context }

      allow(tag_group).to receive(:id) { 'tag_group_id' }
      allow(tag_group).to receive(:name) { 'tag_group_name' }
    end

    context 'success' do
      it 'has the response status 200' do
        get :index, params: { locale: :en }

        expect(response.status).to be(200)
      end

      it 'returns jsonapi compliant json' do
        get :index, params: { locale: :en }

        response_body = JSON.parse(response.body)

        expect(response_body["jsonapi"]).to eq("version" => "1.0")
      end

      it 'renders the tag groups with the jsonapi renderer' do
        get :index, params: { locale: :en }

        response_body = JSON.parse(response.body)

        expect(response_body["data"]).to eq(
          [
            "id" => "tag_group_id",
            "type" => "tag_groups",
            "links" => { "self" => "#" },
            "attributes" => {
              "id" => "tag_group_id",
              "name" => "tag_group_name"
            }
          ]
        )
      end
    end

    context 'error' do
      let(:context) { double(:context, success?: false, message: "error_message") }

      it 'has the response status 400 (bad request)' do
        get :index, params: { locale: :en }

        expect(response.status).to be(400)
      end

      it 'renders the error as json' do
        get :index, params: { locale: :en }

        response_body = JSON.parse(response.body)

        expect(response_body["error"]).to eq("error_message")
      end
    end

  end
end
