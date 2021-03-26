require "rails_helper"

RSpec.describe BookingTitle do
  describe ".from_product_sku" do
    context "when the product name matches the product sku name" do
      let(:product) { instance_double(Product, name: 'Foo') }
      let(:product_sku) { instance_double(ProductSku, name: 'Foo', product: product) }

      it "returns only the product name" do
        title = described_class.from_product_sku(product_sku)

        expect(title).to eq("Foo")
      end
    end

    context "when the product name is different from the product sku name" do
      let(:product) { instance_double(Product, name: 'Foo') }
      let(:product_sku) { instance_double(ProductSku, name: 'Bar', product: product) }

      it "concatenates the product sku name to the product name" do
        title = described_class.from_product_sku(product_sku)

        expect(title).to eq("Foo Bar")
      end
    end
  end
end