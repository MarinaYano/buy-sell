class Tag < ApplicationRecord
    has_many :item_tag_relations, dependent: :destroy
    has_many :items, through: :item_tag_relations, dependent: :destroy
end
