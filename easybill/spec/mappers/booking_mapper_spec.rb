# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::BookingMapper do
  include ActiveSupport::Testing::TimeHelpers

  subject(:mapper) { described_class }

  before do
    I18n.locale = :de
    travel_to Date.new(2020,1,1)
  end

  after do
    I18n.default_locale = :en
    travel_back
  end

  let(:starts_on) { nil }
  let(:ends_on) { nil }
  let(:customer) { instance_double(Customer, id: 2) }
  let(:product) { instance_double('Product', id: 2, name: "Product Name") }
  let(:product_sku) { instance_double('ProductSku', id: 'product_sku_id', name: 'Product Sku Name', product: product) }
  let(:participant1) { double(:participant, first_name: 'foo', last_name: 'bar') }
  let(:participant2) { double(:participant, first_name: 'peter', last_name: 'luschtig') }
  let(:booking) do
    instance_double(Booking,
                    id: 1,
                    customer_id: 2,
                    starts_on: starts_on,
                    ends_on: ends_on,
                    flights: [],
                    assignee: nil,
                    with_date_range?: starts_on.present? && ends_on.present?,
                    product: product,
                    product_sku: product_sku,
                    title: 'booking_title',
                    participants: [participant1, participant2])
  end
  let(:booking_snapshot) { { "title" => "Booking Title" } }
  let(:easybill_customer) { instance_double(Easybill::Customer) }
  let(:document_type) { 'OFFER' }
  let(:booking_resource_sku_groups_snapshot) { [] }
  let(:booking_resource_skus_snapshot) { [] }
  let(:document) do
    double(:document,
      booking: booking,
      payments: payments,
      booking_resource_sku_groups_snapshot: booking_resource_sku_groups_snapshot,
      booking_resource_skus_snapshot: booking_resource_skus_snapshot
    )
  end

  let(:payments) { [payment] }
  let(:payment) { instance_double(Payment, price_cents: 30000, price: Money.new(30000), due_on: 14.days.from_now.to_date) }

  describe '#to_easybill_document' do
    before do
      allow(Easybill::Customer).to receive(:find_by) { easybill_customer }
      allow(easybill_customer).to receive(:external_id).and_return('external_easybill_customer_id')
      allow(document).to receive(:booking_snapshot) { booking_snapshot }
      allow(document).to receive(:booking_credits_snapshot) { [] }
    end

    it 'loads the easybill customer' do
      mapper.to_easybill_document(booking, document, type: document_type)

      expect(Easybill::Customer).to have_received(:find_by).with(customer_id: booking.customer_id)
    end

    it 'maps the booking data to the easybill document format' do
      mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

      text = <<-eof
Falls du Rückfragen hast, melde dich einfach bei uns! Unser Team steht dir jederzeit gerne zur Verfügung.
<br>
Alle Angebote sind vorbehaltlich der tagesaktuellen Verfügbarkeit.
Eine Touristensteuer/Kurtaxe ist vor Ort zu entrichten.
<br>
Zusätzlich empfehlen wir dir den Abschluss entsprechender Reiseversicherungen.
<br>
Wir freuen uns über deine Rückmeldung und hoffen, dich schon bald bei uns begrüßen zu dürfen.
<br>
Mit freundlichen und sportlichen Gr&uuml;&szlig;en,

Dein Team

eof
      expected_mapped_document_data = {
        external_id: booking.id,
        customer_id: 'external_easybill_customer_id',
        document_date: '2020-01-01',
        type: 'OFFER',
        title: 'Booking Title',
        items: [],
        text: text,
        pdf_template: 'DE',
        vat_option: 'sStfr'
      }
      expect(mapped_document_data).to eq(expected_mapped_document_data)
    end

    context 'with starts at in the far future' do
      let(:starts_on) { Date.new(2020,3,1) }

      it 'sets the due date 30 days before the booking starts' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expect(mapped_document_data[:due_in_days]).to eq(30)
      end
    end

    context 'with starts at in the near future' do
      let(:starts_on) { Date.new(2020,1,1) }

      it 'sets the due date 30 days before the booking starts' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expect(mapped_document_data[:due_in_days]).to eq(14)
      end
    end

    context 'with employee' do
      let(:user) { instance_double(User, name: "Max Mustermann") }

      before do
        allow(booking).to receive(:assignee) { user }
      end

      it 'sets the greeting to the employee name' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expect(mapped_document_data[:text]).to include("Dein/e Max Mustermann")
      end
    end

    context 'with resource skus booked' do
      let(:booking_resource_skus_snapshot) { [booking_resource_sku_one, booking_resource_sku_two] }
      let(:booking_resource_sku_one) { double(:booking_resource_sku_one, call: 'mapped-item-data-one', id: 1, price: '10', resource_sku_snapshot: { 'id' => 1 }, quantity: 1) }
      let(:booking_resource_sku_two) { double(:booking_resource_sku_two, call: 'mapped-item-data-two', id: 2, price: '20', resource_sku_snapshot: { 'id' => 2 }, quantity: 2) }

      before do
        allow(Easybill::BookingResourceSkuMapper).to receive(:new)
          .with(booking: booking, booking_resource_sku: booking_resource_sku_one)
          .and_return(booking_resource_sku_one)
        allow(Easybill::BookingResourceSkuMapper).to receive(:new)
          .with(booking: booking, booking_resource_sku: booking_resource_sku_two)
          .and_return(booking_resource_sku_two)
        allow(document).to receive(:booking_resource_sku_ids) { [1, 2] }
        allow(booking_resource_sku_one).to receive(:[]).with("internal") { false }
        allow(booking_resource_sku_two).to receive(:[]).with("internal") { false }
      end

      it 'maps the booking resource skus to easybill document items' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expected_mapped_document_items = %w[mapped-item-data-one mapped-item-data-two]
        expect(mapped_document_data[:items]).to eq(expected_mapped_document_items)
      end
    end

    context 'when customer not synced with easybill' do
      before do
        allow(Easybill::Customer).to receive(:find_by).and_return(nil)
      end

      it 'raises an error' do
        expect do
          mapper.to_easybill_document(booking, document, type: document_type)
        end.to raise_error(Easybill::Errors::CustomerNotSyncedError)
      end
    end

    context 'with invoice document type' do
      let(:document_type) { 'INVOICE' }
      let(:text) do
        <<-eos
some_description

Zahlungsbedingungen:

Rechnungsbetrag: &nbsp; &nbsp;300,00 &euro; (f&auml;llig bis zum 15.01.2020)
<br>
Wir bitten, bei allen Zahlungen deine Rechnungsnummer anzugeben.
<br>
Sonderregelung f&uuml;r Reiseb&uuml;ros (&sect;14a Abs.6 USTG).
<br>
Als Anlage erh&auml;ltst du den Reisesicherungsschein. Sonstige Versicherungspolicen erh&auml;ltst du mit den Reiseunterlagen, die wir dir bei fristgerechter Zahlung ca. 10-14 Tage vor deinem Reiseantritt zusenden.
<br>
Du bist selbst f&uuml;r die Kenntnis und Einhaltung der l&auml;nderspezifischen Einreiseformalit&auml;ten (G&uuml;ltigkeit von Reisedokumenten, Erteilung entsprechender Visa etc.) verantwortlich. Weitergehende Infos erh&auml;ltst du hier: http://www.auswaertiges-amt.de
<br>
F&uuml;r eventuelle R&uuml;ckfragen stehen wir dir jederzeit gerne zur Verf&uuml;gung.
<br>
Mit freundlichen und sportlichen Gr&uuml;&szlig;en,

Dein Team

eos
      end

      before do
        allow(document).to receive(:description) { 'some_description' }
      end

      it 'maps the booking data to the easybill document format' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expected_mapped_document_data = {
          external_id: booking.id,
          customer_id: 'external_easybill_customer_id',
          document_date: '2020-01-01',
          type: 'INVOICE',
          items: [],
          title: 'Booking Title',
          text: text,
          pdf_template: 'DE',
          vat_option: 'sStfr'
        }
        expect(mapped_document_data).to eq(expected_mapped_document_data)
      end

      context 'gets data about resource sku groups and resource skus from snapshots' do
        let(:booking_resource_sku_groups_snapshot) { [group1, group2] }
        let(:booking_resource_skus_snapshot) { [sku1, sku2] }
        let(:group1) { double(:booking_resource_sku_group1, call: 'mapped-item-group-one') }
        let(:group2) { double(:booking_resource_sku_group2, call: 'mapped-item-group-two') }
        let(:sku1) { double(:booking_resource_sku_one, call: 'mapped-item-sku-one', id: 1, price: '10', resource_sku_snapshot: { 'id' => 1 }, quantity: 1) }
        let(:sku2) { double(:booking_resource_sku_one, call: 'mapped-item-sku-two', id: 2, price: '20', resource_sku_snapshot: { 'id' => 1 }, quantity: 1) }

        before do
          allow(::Easybill::BookingResourceSkuGroupMapper).to receive(:new).with(booking: booking, booking_resource_sku_group: group1, document: document) { group1 }
          allow(::Easybill::BookingResourceSkuGroupMapper).to receive(:new).with(booking: booking, booking_resource_sku_group: group2, document: document) { group2 }

          allow(Easybill::BookingResourceSkuMapper).to receive(:new)
            .with(booking: booking, booking_resource_sku: sku1)
            .and_return(sku1)
          allow(Easybill::BookingResourceSkuMapper).to receive(:new)
            .with(booking: booking, booking_resource_sku: sku2)
            .and_return(sku2)

          allow(document).to receive(:booking_resource_sku_ids) { [1, 2] }
        end

        context 'from snapshots' do
          before do
            allow(sku1).to receive(:[]).with("internal") { false }
            allow(sku2).to receive(:[]).with("internal") { false }
          end

          it do
            mapped_document_items = mapper.to_easybill_document(booking, document, type: document_type)[:items]

            expected_items = %w[mapped-item-group-one mapped-item-group-two mapped-item-sku-one mapped-item-sku-two]

            expect(mapped_document_items).to eq(expected_items)
          end
        end
      end

      context 'with advance_invoice type' do
        let(:document_type) { 'ADVANCE_INVOICE' }

        before do
          allow(document).to receive(:description) { 'some_description' }
        end

        it 'assigns the deposit snapshot as items' do
          mapped_document_items = mapper.to_easybill_document(booking, document, type: document_type)[:items]

          advance_payment_snapshot = [{
            "number" => "-",
            "description" => I18n.t("booking_credits.advance_booking_invoice.title"),
            "quantity" => 1,
            "vat_percent" => 0.0,
            "single_price_net" => 30000.00
          }]

          expect(mapped_document_items).to eq(advance_payment_snapshot)
        end
      end

      context 'when the booking has booking credits' do
        let(:credit1) { double(:booking_credit, call: 'mapped-item-credit-one', id: 1, price_cents: '10000', quantity: 1) }

        before do
          allow(document).to receive(:booking_credits_snapshot) { [credit1] }
          allow(::Easybill::BookingCreditMapper).to receive(:new).with(booking: booking, booking_credit: credit1) { credit1 }
        end

        it 'gets the data from the booking_credits_snapshot' do
          mapped_document_items = mapper.to_easybill_document(booking, document, type: document_type)[:items]

        expect(mapped_document_items).to eq(['mapped-item-credit-one'])
        end
      end
    end

    context 'with invoice template configured' do
      let(:document_type) { 'INVOICE' }
      let(:product_configuration) { Easybill::ProductConfiguration.new(invoice_template: "FOOBAR") }

      before do
        allow(Easybill::ProductConfiguration).to receive(:find_by) { product_configuration }
        allow(document).to receive(:description)
      end

      it 'maps the booking data to the easybill document format' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expect(mapped_document_data[:pdf_template]).to eq("FOOBAR")
      end
    end

    context 'with unknown document type' do
      let(:document_type) { 'unknown' }

      it 'raises an error' do
        expect {
          mapper.to_easybill_document(booking, document, type: document_type)
        }.to raise_error('invalid type: unknown. Choose one of ["OFFER", "INVOICE", "ADVANCE_INVOICE"]')
      end
    end

    context 'with start date for invoice' do
      let(:document_type) { 'INVOICE' }
      let(:starts_on) { Date.new(2020,4,1) }

      before do
        allow(document).to receive(:description) { 'some_description' }
      end

      it 'maps the booking data to the easybill document format' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expected_service_date = {
          type: 'SERVICE',
          date: '2020-04-01'
        }
        expect(mapped_document_data[:service_date]).to eq(expected_service_date)
      end
    end

    context 'with start and end date for invoice' do
      let(:document_type) { 'INVOICE' }
      let(:starts_on) { Date.new(2020, 1, 1) }
      let(:ends_on) { starts_on + 14.days }

      before do
        allow(document).to receive(:description) { 'some_description' }
      end

      it 'maps the booking data to the easybill document format' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expected_service_date = {
          type: 'SERVICE',
          date_from: '2020-01-01',
          date_to: '2020-01-15'
        }
        expect(mapped_document_data[:service_date]).to eq(expected_service_date)
        expect(mapped_document_data[:title]).to eq('Booking Title (01.01.2020 - 15.01.2020)')
      end
    end

    context "with flights" do
      before do
        allow(booking).to receive(:flights) { [:many] }
      end

      it 'adds the flights section to the text' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expect(mapped_document_data[:text]).to include("Bitte beachte auch, dass es seitens der Airline zu Flugzeiten- und Routingänderungen kommen kann!")
      end
    end

    context "with internal booking resource skus" do
      let(:internal_booking_resource_sku_snapshot) do
        {
          'id' => 'id',
          'internal' => true
        }
      end

      let(:booking_resource_skus_snapshot) { [internal_booking_resource_sku_snapshot] }

      before do
        allow(::Easybill::BookingResourceSkuMapper).to receive(:new)
      end

      it 'does not map the skus' do
        mapped_document_data = mapper.to_easybill_document(booking, document, type: document_type)

        expect(::Easybill::BookingResourceSkuMapper).not_to receive(:new).with(any_args)
      end
    end
  end
end
