# frozen_string_literal: true

class CategoryComponent < ViewComponent::Base
  def initialize(category:)
    @category = category
  end

end
