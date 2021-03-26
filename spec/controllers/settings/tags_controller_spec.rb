require "rails_helper"

RSpec.describe Settings::TagsController, type: :controller do
  login_user

  describe "[GET] index" do
    let(:context) { double(:context, success?: true, tags: tags) }
    let(:tags) { class_double(Tag) }

    before do
      allow(Tags::ListTags).to receive(:call) { context }
      allow(tags).to receive(:decorate) { tags }
    end

    it 'loads all tags' do
      get :index, params: { locale: I18n.locale }

      expect(Tags::ListTags).to have_received(:call).with(no_args)
    end

    it 'decorates all tags' do
      get :index, params: { locale: I18n.locale }

      expect(tags).to have_received(:decorate).with(no_args)
    end
  end

  describe "[GET] new" do
    let(:tag) { instance_double(Tag) }

    before do
      allow(Tag).to receive(:new) { tag }
    end

    it 'initializes a new tag' do
      get :new, params: { locale: I18n.locale }

      expect(Tag).to have_received(:new).with(no_args)
    end
  end

  describe "[POST] create" do
    let(:post_params) do
      {
        "locale" => I18n.default_locale,
        "tag" => {
          "name" => "a_name",
          "handle" => "a_handle"
        }
      }
    end
    let(:context) { double(:context, success?: true) }

    before do
      allow(Tags::CreateTag).to receive(:call) { context }
    end
    
    it 'calls the create interactor'  do
      post :create, params: post_params

      expect(Tags::CreateTag).to have_received(:call).with(params: {
        "name" => "a_name", "handle" => "a_handle"
      })
    end

    it 'renders the success flash message' do
      post :create, params: post_params

      expect(flash[:success]).to eq(I18n.t("settings.tags.create.success"))
    end

    context 'when something goes wrong' do
      let(:context) { double(:context, success?: false, message: 'an_error', tag: 'tag') }

      it 'sets the error flash message' do
        post :create, params: post_params

        expect(flash[:error]).to eq("an_error")
      end

      it 'renders the new view' do
        post :create, params: post_params

        expect(response).to render_template("new")
      end
    end
  end

  describe "[GET] edit" do
    let(:tag) { instance_double(Tag) }

    before do
      allow(Tag).to receive(:find) { tag }
    end

    it 'loads the tag' do
      get :edit, params: { locale: I18n.locale, id: 'tag_id' }

      expect(Tag).to have_received(:find).with('tag_id')
    end
  end

  describe "[POST] update" do
    let(:update_params) do
      {
        "locale" => I18n.default_locale,
        "id" => "tag_id",
        "tag" => {
          "name" => "a_name",
          "handle" => "a_handle"
        }
      }
    end
    let(:context) { double(:context, success?: true) }

    before do
      allow(Tags::UpdateTag).to receive(:call) { context }
    end
    
    it 'calls the update interactor'  do
      put :update, params: update_params

      expect(Tags::UpdateTag).to have_received(:call).with(
        tag_id: "tag_id",
        params: {
          "name" => "a_name", "handle" => "a_handle"
        }
      )
    end

    it 'renders the success flash message' do
      put :update, params: update_params

      expect(flash[:success]).to eq(I18n.t("settings.tags.update.success"))
    end

    context 'when something goes wrong' do
      let(:context) { double(:context, success?: false, message: 'an_error', tag: 'tag') }

      it 'sets the error flash message' do
        put :update, params: update_params

        expect(flash[:error]).to eq("an_error")
      end

      it 'renders the new view' do
        put :update, params: update_params

        expect(response).to render_template("edit")
      end
    end
  end
end