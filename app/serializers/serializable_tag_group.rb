# frozen_string_literal: true

class SerializableTagGroup < JSONAPI::Serializable::Resource
  type "tag_groups"

  attributes :id,
             :name

  link :self do
    "#"
  end
end
