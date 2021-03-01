class Category < ApplicationRecord
  has_many :ideas, dependent: :destroy

  def self.fetch_ideas(name)
    return Idea.eager_load(:category) if name.blank?

    category = find_by(name: name)
    return category.ideas if category.present?

    []
  end
end
