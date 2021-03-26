require 'rails_helper'

RSpec.describe ResourceSkuDecorator do
  let(:resource) { instance_double(Resource, handle: '') }
  let(:resource_sku) { instance_double(ResourceSku, resource: resource, handle: 'a_simple_handle') }

  subject(:decorator) { ResourceSkuDecorator.new(resource_sku) }

  describe "#complete_handle" do
    context "when the resource has no handle" do
      it "returns the handle without a prefix" do
        handle = decorator.complete_handle

        expect(handle).to eq('a_simple_handle')
      end
    end

    context "when the resource has a handle" do
      let(:resource) { instance_double(Resource, handle: 'a-prefix') }

      it "returns the handle with a prefix" do
        handle = decorator.complete_handle

        expect(handle).to eq('a-prefix-a_simple_handle')
      end
    end
  end
end
