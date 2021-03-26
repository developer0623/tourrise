# frozen_string_literal: true

module Easybill
  module TableHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    def table
      content_tag(:table, style: "width: 100%;") do
        yield
      end
    end

    def thead
      content_tag(:thead) do
        yield
      end
    end

    def tbody
      content_tag(:tbody) do
        yield
      end
    end

    def tr
      content_tag(:tr) do
        yield
      end
    end

    def th(content, width: "auto")
      content_tag(:th, content, style: "width: #{width}")
    end

    def td(content)
      content_tag(:td, content)
    end
  end
end
