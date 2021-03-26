require "rails_helper"

RSpec.describe FieldGroup, type: :component do
  it "renders a group of fields with the default FieldGroup column layout" do
    rendered_field_group = render_inline(described_class.new) do
      "Example text"
    end

    expect(rendered_field_group.css("div").to_html).to include("class=\"FieldGroup FieldGroup--3Columns\"")
  end

  context "with columns parameter" do
    it "renders a group of fields with the correct class" do
      rendered_field_group = render_inline(described_class.new(columns: 1)) do
        "Example text"
      end

      expect(rendered_field_group.css("div").to_html).to include("class=\"FieldGroup FieldGroup--1Columns\"")
    end
  end
end
