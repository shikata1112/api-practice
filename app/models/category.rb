class Category < ApplicationRecord
  has_many :ideas, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  def self.fetch_ideas(name)
    return Idea.eager_load(:category) if name.blank?

    category = find_by(name: name)
    return category.ideas if category.present?

    []
  end

  def self.create_ideas!(name, body)
    category = find_by(name: name)
    if category.present?
      category.ideas.create!(body: body)
    else
      create_category_and_ideas(name, body)
    end
  end

  private

  def self.create_category_and_ideas(name, body)
    new_category = new(name: name)
    new_category.ideas.build(body: body)
    new_category.save!
  end
end
