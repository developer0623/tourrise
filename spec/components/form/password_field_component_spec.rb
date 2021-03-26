require "rails_helper"

RSpec.describe Form::PasswordFieldComponent, type: :component do
  let(:form_builder) do
    ActionView::Helpers::FormBuilder.new(:user, User.new, ActionView::Base.new(ActionView::LookupContext.new('spec')), {})
  end

  it "renders the label with the correct classes" do
    password_field = render_inline(described_class.new(form_builder, :password))

    expected_html = '<label class="block text-sm font-medium text-gray-700" for="user_password">Passwort</label>'

    expect(password_field.css("label").to_html).to include(expected_html)
  end

  it "renders the input with the correct html" do
    password_field = render_inline(described_class.new(form_builder, :password))

    expected_html = <<-HTML
  <div class="mt-1">
    <input class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" type="password" name="user[password]" id="user_password">
  </div>
HTML

    expect(password_field.css("div").to_html).to include(expected_html)
  end
end
