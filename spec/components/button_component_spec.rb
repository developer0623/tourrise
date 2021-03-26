require "rails_helper"

RSpec.describe ButtonComponent, type: :component do
  button_text = "Click me"

  it "renders a button with base styles" do
    rendered_component = render_inline(described_class.new) do
      button_text
    end

    expect(rendered_component).to have_selector(
      ".w-full.flex.justify-center.py-2.px-4.border.border-transparent.rounded-md.shadow-sm.text-sm.font-medium.focus\\:outline-none.focus\\:ring-2.focus\\:ring-offset-2.focus\\:ring-indigo-500",
      text: button_text
    )
  end

  it "renders a button with default styles" do
    rendered_component = render_inline(described_class.new) do
      button_text
    end

    expect(rendered_component).to have_selector(
      ".text-white.bg-indigo-600.hover\\:bg-indigo-700",
      text: button_text
    )
  end

  context "with color parameter" do
    it "renders an indigo button" do
      rendered_component = render_inline(described_class.new(color: "indigo")) do
        button_text
      end

      expect(rendered_component).to have_selector(
        ".text-white.bg-indigo-600.hover\\:bg-indigo-700",
        text: button_text
      )
    end

    it "renders a white button" do
      rendered_component = render_inline(described_class.new(color: "white")) do
        button_text
      end

      expect(rendered_component).to have_selector(
        ".border-gray-300.bg-white.text-gray-700.hover\\:bg-gray-50",
        text: button_text
      )
    end
  end
end
