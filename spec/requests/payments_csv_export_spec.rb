require "rails_helper"

RSpec.describe "Export Payments CSV", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:booking) { FactoryBot.create(:booking, :public, aasm_state: "booked", product_sku: product_sku) }
  let(:product) { FactoryBot.create(:product) }
  let(:product_sku) { FactoryBot.create(:product_sku, product: product) }
  let(:financial_account) { FactoryBot.create(:financial_account) }
  let(:cost_center) { FactoryBot.create(:cost_center) }

  let(:product_sku_snapshot) do
    {
      "id" => product_sku.id,
      "product_id" => product.id,
      "name" =>"Product Sku"
    }
  end

  let(:booking_resource_sku_snapshot1) do
    {
      "id" =>13,
      "price_cents" =>100000,
      "internal" =>false,
      "financial_account" => {
        "id" => financial_account.id,
        "during_service_year" => financial_account.during_service_year
      },
      "cost_center" => {
        "id" => cost_center.id,
        "value" => cost_center.value
      },
      "allow_partial_payment" => true
    }
  end

  let(:booking_resource_skus_snapshot) { [booking_resource_sku_snapshot1] }
  let(:booking_resource_sku_groups_snapshot) { [] }
  let(:booking_credits_snapshot) { [] }

  let(:first_payment) { Payment.new(price: 200, due_on: Time.zone.yesterday) }
  let(:final_payment) { Payment.new(price: 800, due_on: Time.zone.tomorrow) }
  let(:payments) { [first_payment, final_payment] }

  let(:booking_invoice) do
    FactoryBot.create(
      :booking_invoice,
      :public,
      booking: booking,
      booking_snapshot: booking.attributes,
      product_sku_snapshot: product_sku_snapshot,
      booking_resource_skus_snapshot: booking_resource_skus_snapshot,
      booking_resource_sku_groups_snapshot: booking_resource_sku_groups_snapshot,
      booking_credits_snapshot: booking_credits_snapshot,
      customer_snapshot: booking.customer.attributes,
      payments: payments
    )
  end
  let(:invoice_date) { I18n.l(booking_invoice.created_at.to_date) }

  let(:expected_headers) { [
        Booking.model_name.human,
        I18n.t("settings.accounting_records.table_headers.customer"),
        I18n.t("settings.accounting_records.table_headers.customer_id"),
        I18n.t("settings.accounting_records.table_headers.product"),
        I18n.t("settings.accounting_records.table_headers.product_sku"),
        I18n.t("settings.accounting_records.table_headers.amount"),
        I18n.t("settings.accounting_records.table_headers.booking_starts_on"),
        I18n.t("settings.accounting_records.table_headers.financial_account"),
        I18n.t("settings.accounting_records.table_headers.cost_center"),
        I18n.t("settings.accounting_records.table_headers.payment_due_on"),
        I18n.t("settings.accounting_records.table_headers.invoice_number"),
        I18n.t("settings.accounting_records.table_headers.invoice_date")
      ] }

  before do
    travel_to Date.new(2020,10,30)

    booking_invoice

    sign_in(user)

    I18n.locale = :en
  end

  after do
    travel_back

    I18n.locale = I18n.default_locale
  end

  it "generates a .csv file" do
    get payments_path(format: :csv, locale: I18n.locale, filter: {})

    expect(response.media_type).to eq("text/csv")
  end

  it "sends the payments data to the csv file" do
    get payments_path(format: :csv, locale: I18n.locale)

    expect(response.successful?).to be(true)

    csv = CSV.parse(response.body)

    expected_csv = [
      [expected_headers.join(";")],
      ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"],
      ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;3333;10;2020-10-31;#;#{invoice_date}"]
    ]

    expect(csv).to eq(expected_csv)
  end

  it "has the correct total payment sum" do
    get payments_path(format: :csv, locale: I18n.locale)

    csv = CSV.parse(response.body)

    expected_sum = booking_resource_skus_snapshot.sum { |snapshot| snapshot["price_cents"] } / 100
    documented_sum = csv[1..-1].sum { |line| line[0].split(';')[5].to_r }

    expect(documented_sum).to eq(expected_sum)
  end

  context "with one payment and one cost_center and financial_account" do
    let(:payments) { [first_payment] }

    it "sends the payments data to the csv file" do
      get payments_path(format: :csv, locale: I18n.locale)

      expect(response.successful?).to be(true)

      csv = CSV.parse(response.body)

      expected_csv = [
        [expected_headers.join(";")],
        ["#{booking.id};John Doe;;Product;Product Sku;1000.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"]
      ]

      expect(csv).to eq(expected_csv)
    end
  end

  context "with mixed financial accounts and cost centers" do
    let(:booking_resource_skus_snapshot) { [booking_resource_sku_snapshot1, booking_resource_sku_snapshot2] }

    context "with multiple booking resource skus that are all partially payable" do
      let(:booking_resource_sku_snapshot2) do
        {
          "id"=>14,
          "price_cents"=>100000,
          "internal"=>false,
          "financial_account"=>nil,
          "cost_center"=>nil,
          "allow_partial_payment"=>true
        }
      end
      let(:first_payment) { Payment.new(id: 1, price: 400, due_on: Time.zone.yesterday) }
      let(:final_payment) { Payment.new(id: 2, price: 1600, due_on: Time.zone.tomorrow) }

      it "has the correct csv content" do
        get payments_path(format: :csv, locale: I18n.locale)

        expect(response.successful?).to be(true)

        csv = CSV.parse(response.body)

        expected_csv = [
          [expected_headers.join(";")],
          ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;Not entered;Not entered;2020-10-29;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;3333;10;2020-10-31;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;Not entered;Not entered;2020-10-31;#;#{invoice_date}"]
        ]

        expect(csv).to eq(expected_csv)
      end
    end

    context "with at least one booking resource sku that is not partially payable" do
      let(:booking_resource_sku_snapshot2) do
        {
          "id"=>14,
          "price_cents"=>100000,
          "internal"=>false,
          "financial_account"=>nil,
          "cost_center"=>nil,
          "allow_partial_payment"=>false
        }
      end
      let(:first_payment) { Payment.new(id: 1, price: 1200, due_on: Time.zone.yesterday) }
      let(:final_payment) { Payment.new(id: 2, price: 800, due_on: Time.zone.tomorrow) }

      it "has the correct csv content" do
        get payments_path(format: :csv, locale: I18n.locale)

        expect(response.successful?).to be(true)

        csv = CSV.parse(response.body)

        expected_csv = [
          [expected_headers.join(";")],
          ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;1000.00;2020-11-14;Not entered;Not entered;2020-10-29;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;3333;10;2020-10-31;#;#{invoice_date}"]
        ]

        expect(csv).to eq(expected_csv)
      end
    end

    context "with multiple booking resource skus that are all payed in one payment" do
      let(:booking_resource_sku_snapshot1) do
        {
          "id"=>13,
          "price_cents"=>100000,
          "internal"=>false,
          "financial_account"=>financial_account.attributes,
          "cost_center"=>cost_center.attributes,
          "allow_partial_payment"=>false
        }
      end
      let(:booking_resource_sku_snapshot2) do
        {
          "id"=>14,
          "price_cents"=>100000,
          "internal"=>false,
          "financial_account"=>nil,
          "cost_center"=>nil,
          "allow_partial_payment"=>false
        }
      end
      let(:first_payment) { Payment.new(id: 1, price: 2000, due_on: Time.zone.yesterday) }
      let(:final_payment) { Payment.new(id: 2, price: 0, due_on: Time.zone.tomorrow) }

      it "has the correct csv content" do
        get payments_path(format: :csv, locale: I18n.locale)

        expect(response.successful?).to be(true)

        csv = CSV.parse(response.body)

        expected_csv = [
          [expected_headers.join(";")],
          ["#{booking.id};John Doe;;Product;Product Sku;1000.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;1000.00;2020-11-14;Not entered;Not entered;2020-10-29;#;#{invoice_date}"]
        ]

        expect(csv).to eq(expected_csv)
      end
    end

    context "with a booking resource sku group, i. e. an internal booking resource sku" do
      let(:booking_resource_sku_snapshot2) do
        {
          "id"=>14,
          "price_cents"=>100000,
          "internal"=>true,
          "financial_account"=>nil,
          "cost_center"=>nil,
          "allow_partial_payment"=>false
        }
      end
      let(:booking_resource_sku_group_snapshot1) do
        {
          "id"=>1,
          "price_cents"=>80000,
          "financial_account"=>nil,
          "cost_center"=>nil,
          "allow_partial_payment"=>true
        }
      end
      let(:booking_resource_sku_groups_snapshot) { [booking_resource_sku_group_snapshot1] }

      let(:first_payment) { Payment.new(id: 1, price: 360, due_on: Time.zone.yesterday) }
      let(:final_payment) { Payment.new(id: 2, price: 1440, due_on: Time.zone.tomorrow) }

      it "has the correct csv content" do
        get payments_path(format: :csv, locale: I18n.locale)

        expect(response.successful?).to be(true)

        csv = CSV.parse(response.body)

        expected_csv = [
          [expected_headers.join(";")],
          ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;160.00;2020-11-14;Not entered;Not entered;2020-10-29;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;3333;10;2020-10-31;#;#{invoice_date}"],
          ["#{booking.id};John Doe;;Product;Product Sku;640.00;2020-11-14;Not entered;Not entered;2020-10-31;#;#{invoice_date}"]
        ]

        expect(csv).to eq(expected_csv)
      end
    end
  end

  context "with mixed financial accounts but the same cost center" do
    let(:booking_resource_skus_snapshot) { [booking_resource_sku_snapshot1, booking_resource_sku_snapshot2] }
    let(:booking_resource_sku_snapshot2) do
      {
        "id"=>14,
        "price_cents"=>100000,
        "internal"=>false,
        "financial_account"=>nil,
        "cost_center"=>cost_center.attributes,
        "allow_partial_payment"=>true
      }
    end
    let(:first_payment) { Payment.new(id: 1, price: 400, due_on: Time.zone.yesterday) }
    let(:final_payment) { Payment.new(id: 2, price: 1600, due_on: Time.zone.tomorrow) }

    it "has the correct csv content" do
      get payments_path(format: :csv, locale: I18n.locale)

      expect(response.successful?).to be(true)

      csv = CSV.parse(response.body)

      expected_csv = [
        [expected_headers.join(";")],
        ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;Not entered;10;2020-10-29;#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;3333;10;2020-10-31;#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;Not entered;10;2020-10-31;#;#{invoice_date}"]
      ]

      expect(csv).to eq(expected_csv)
    end
  end

  context "with the same financial accounts but mixed cost centers" do
    let(:booking_resource_skus_snapshot) { [booking_resource_sku_snapshot1, booking_resource_sku_snapshot2] }
    let(:booking_resource_sku_snapshot2) do
      {
        "id"=>14,
        "price_cents"=>100000,
        "internal"=>false,
        "financial_account"=>financial_account.attributes,
        "cost_center"=>nil,
        "allow_partial_payment"=>true
      }
    end
    let(:first_payment) { Payment.new(id: 1, price: 400, due_on: Time.zone.yesterday) }
    let(:final_payment) { Payment.new(id: 2, price: 1600, due_on: Time.zone.tomorrow) }

    it "has the correct csv content" do
      get payments_path(format: :csv, locale: I18n.locale)

      expect(response.successful?).to be(true)

      csv = CSV.parse(response.body)

      expected_csv = [
        [expected_headers.join(";")],
        ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;3333;Not entered;2020-10-29;#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;3333;10;2020-10-31;#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;3333;Not entered;2020-10-31;#;#{invoice_date}"]
      ]

      expect(csv).to eq(expected_csv)
    end
  end

  context "when there are advance invoices and booking credits" do
    let(:booking_credit1) do
      {
        "id"=>1,
        "booking_id"=>1,
        "financial_account" => {
          "id" => financial_account.id,
          "during_service_year" => financial_account.during_service_year
        },
        "cost_center" =>  {
          "id" => cost_center.id,
          "value" => cost_center.value
        },
        "name"=>"Deposit",
        "price_cents"=>70000,
        "price_currency"=>"EUR"
      }
    end
    let(:deposit_snapshot) do
      {
        "price_cents" =>70000,
        "financial_account" => {
          "id" => financial_account.id,
          "during_service_year" => financial_account.during_service_year
        },
        "cost_center" => {
          "id" => cost_center.id,
          "value" => cost_center.value
        },
      }
    end
    let(:booking_credits_snapshot) { [booking_credit1] }
    let(:advance_payment) { Payment.new(id: 3, price: 700, due_on: Time.zone.today - 10.days) }
    let(:advance_invoice) do
      FactoryBot.create(
        :booking_invoice,
        :public,
        booking: booking,
        booking_snapshot: booking.attributes,
        product_sku_snapshot: product_sku_snapshot,
        booking_resource_skus_snapshot: [deposit_snapshot],
        booking_resource_sku_groups_snapshot: [],
        booking_credits_snapshot: [],
        customer_snapshot: booking.customer.attributes,
        payments: [advance_payment]
      )
    end

    before do
      advance_invoice
    end

    it "has the correct csv content" do
      get payments_path(format: :csv, locale: I18n.locale)

      expect(response.successful?).to be(true)

      csv = CSV.parse(response.body)

      expected_csv = [
        [expected_headers.join(";")],
        ["#{booking.id};John Doe;;Product;Product Sku;200.00;2020-11-14;3333;10;2020-10-29;#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;800.00;2020-11-14;3333;10;2020-10-31;#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;-700.00;2020-11-14;3333;10;#{invoice_date};#;#{invoice_date}"],
        ["#{booking.id};John Doe;;Product;Product Sku;700.00;2020-11-14;3333;10;2020-10-20;#;#{invoice_date}"]
      ]

      expect(csv).to eq(expected_csv)
    end

    it "has the correct total payment sum" do
      get payments_path(format: :csv, locale: I18n.locale)

      csv = CSV.parse(response.body)

      expected_sum = booking_resource_skus_snapshot.sum { |snapshot| snapshot["price_cents"] } / 100
      documented_sum = csv[1..-1].sum { |line| line[0].split(';')[5].to_r }

      expect(documented_sum).to eq(expected_sum)
    end
  end
end
