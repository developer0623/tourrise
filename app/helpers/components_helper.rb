# frozen_string_literal: true

module ComponentsHelper
  def a11y_content(&block)
    content_tag(:span, class: "A11yContent") do
      capture(&block)
    end
  end

  # Accepted html params:
  # - id
  # - class
  def card(action: nil, title: nil, image: nil, html: {}, &block)
    id = html[:id] || nil
    class_name = html[:class] || nil

    if title.is_a?(Hash)
      title_tag = title.keys.join
      heading = title.values.join
    elsif title.is_a?(String)
      title_tag = :h2
      heading = title
    end

    content_tag(:div, id: id, class: "Card #{class_name}") do
      concat content_tag(:div, image, class: "Card-image") if image
      concat content_tag(title_tag, heading, class: "Card-heading") if title
      concat content_tag(:div, capture(&block), class: "Card-section") if block

      if action
        concat(
          content_tag(:div, class: "Card-footer") do
            action
          end
        )
      end
    end
  end

  def card_group(columns: 3, &block)
    content_tag(:div, class: "CardGroup CardGroup--#{columns}Columns") do
      capture(&block)
    end
  end

  # Separator options: :default, :before, :after, :both, :none
  def card_section(tag: :section, separator: :default, &block)
    separator = separator.to_s.capitalize

    content_tag(tag, class: "CardSection CardSection--separator#{separator}") do
      capture(&block)
    end
  end

  def checkbox_group(vertical: true, &block)
    modifier = vertical ? "vertical" : "horizontal"

    content_tag(:div, class: "CheckboxGroup CheckboxGroup--#{modifier}") do
      capture(&block)
    end
  end

  # Generates image_tag with srcset (based on provided sizes) and a fallback
  # image in case an item from a collection has no image in active storage
  def image_on_steroids(image, alt:, sizes: [], square: false, html_class: "")
    srcset = []

    if image.present? && image.variable?
      sizes.each do |size|
        resize_to_fit = [size, (square ? size : nil)]
        srcset << [url_for(image.variant(resize_to_fit: resize_to_fit)), "#{size}w"]
      end
    else
      image = "no-image.jpg"

      sizes.each do |size|
        srcset << [image_url("no-image-#{size}.jpg"), "#{size}w"]
      end
    end

    image_tag image, alt: alt, class: html_class, srcset: srcset
  end

  def featured_image(image, alt:, sizes: [600, 900, 1200, 1980])
    image_on_steroids image, sizes: sizes, alt: alt, html_class: "FeaturedImage"
  end

  # Variants: :small, :medium, :large
  def thumbnail(image, alt:, variant: :medium)
    sizes = [50, 100, 200, 400]

    image_on_steroids image, alt: alt, sizes: sizes, square: true, html_class: "Thumbnail Thumbnail--#{variant}"
  end

  def details(summary: t("components.details.summary"), &block)
    content_tag(:details, class: "Details") do
      concat content_tag(:summary, summary, class: "Details-summary")
      concat capture(&block)
    end
  end

  def datalist(attributes, skip_blank: false)
    content_tag(:dl, class: "Datalist Datalist--multipleColumns") do
      attributes.each do |attribute|
        key = attribute[0]
        raw_value = attribute[1]

        next if skip_blank && raw_value.blank?

        value =
          if raw_value.respond_to?(:strftime)
            time_tag raw_value, l(raw_value)
          else
            raw_value
          end

        dt = content_tag(:dt, key, class: "Datalist-key")
        dd = content_tag(:dt, value, class: "Datalist-value")

        concat content_tag(:div, dt + dd, class: "Datalist-item")
      end
    end
  end

  def magic_datalist(object, attributes, skip_blank: false)
    processed_attributes = []

    attributes.each do |attribute|
      key = object.model.class.human_attribute_name(attribute)
      value = object.public_send(attribute)

      processed_attributes << [key, value]
    end

    datalist processed_attributes, skip_blank: skip_blank
  end

  def table(headers, data, counter: true, stretched: false)
    render "components/table", headers: headers, data: data, include_counter: counter, stretched: stretched
  end

  def magic_table(data, attributes, counter: true)
    headers = []
    processed_data = []

    attributes.each do |attribute|
      headers << data.first.class.human_attribute_name(attribute)
    end

    data.each do |item|
      processed_item = []

      attributes.each do |attribute|
        raw_value = item.public_send(attribute)
        value = raw_value.respond_to?(:strftime) ? l(raw_value) : raw_value

        processed_item << value
      end

      processed_data << processed_item
    end

    table headers, processed_data, counter: counter
  end

  def bill_table(data, header: false)
    render "components/bill_table", data: data, header: header
  end
end
