require "rails_helper"

RSpec.describe Form::EmailFieldComponent, type: :component do
  let(:form_builder) do
    ActionView::Helpers::FormBuilder.new(:user, User.new, ActionView::Base.new(ActionView::LookupContext.new('spec')), {})
  end

  it "renders the label with the correct classes" do
    email_field = render_inline(described_class.new(form_builder, :email))


    expected_html = '<label class="block text-sm font-medium text-gray-700" for="user_email">E-Mail</label>'

    expect(email_field.css("label").to_html).to include(expected_html)
  end

  it "renders the input with the correct html" do
    email_field = render_inline(described_class.new(form_builder, :email))

    expected_html = <<-HTML
  <div class="mt-1">
    <input class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" type="email" value="" name="user[email]" id="user_email">
  </div>
HTML

    expect(email_field.css("div").to_html).to include(expected_html)
  end
end
