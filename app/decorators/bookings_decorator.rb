# frozen_string_literal: true

class BookingsDecorator < PaginatingDecorator
  def filter_options(product_id: nil, product_sku_id: nil, status: nil)
    filter_options = [
      states_filter,
      secondary_state_filter(status),
      products_filter,
      users_filter
    ]

    filter_options.insert(3, product_skus_filter(product_id)) if product_id.present?
    filter_options.insert(4, seasons_filter(product_sku_id)) if product_sku_id.present?

    filter_options
  end

  def users_filter
    {
      name: "assignee_id",
      type: "select",
      options: [
        [0, h.t("empty_assignee")],
        [h.current_user.id, h.t("own")]
      ] + User.where.not(id: [h.current_user.id, FrontofficeUser.id]).order(:first_name).map { |user| [user.id, user.name] }
    }
  end

  def products_filter
    {
      name: "product_id",
      type: "select",
      options: Booking.all.includes(:product).map(&:product).uniq.compact.sort_by(&:name).map { |product| [product.id, product.name] }
    }
  end

  def states_filter
    {
      name: "status",
      type: "select",
      options: Booking.aasm.states.map { |state| [state.name.to_sym, h.t("bookings.states.#{state.name}")] }
    }
  end

  def secondary_state_filter(status)
    options = if status == "in_progress" || status.blank?
                Booking::SECONDARY_STATES.map { |secondary_state| [secondary_state.to_sym, h.t("bookings.secondary_state.#{secondary_state}")] }
              else
                []
              end

    {
      name: "secondary_state",
      type: "select",
      options: options
    }
  end

  def product_skus_filter(product_id)
    {
      name: "product_sku_id",
      type: "select",
      options: Product.find(product_id).product_skus.order(:name).map { |product_sku| [product_sku.id, product_sku.name] }
    }
  end

  def seasons_filter(product_sku_id)
    {
      name: "season_id",
      type: "select",
      options: ProductSku.find(product_sku_id).seasons.order(:name).map { |season| [season.id, season.name] }
    }
  end
end
