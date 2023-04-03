class Category < ApplicationRecord
    has_many :products, dependent: :restrict_with_exception # Una categoria tiene varios productos (claves foraneas)

    validates :name, presence: true # El nombre tiene que ser obligatorio, sino podriamos crear categorias sin nombre
end
