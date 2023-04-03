class Product < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :search_full_text, against: {
        title: 'A',
        description: 'B'
    } # Las letras indican la prioridad en la busqueda

    has_one_attached :photo # Para guardar fotos usamos has_one_attached :nombre_que_queramos

    validates :title, presence: true
    validates :description, presence: true
    validates :price, presence: true

    has_many :favorites, dependent: :destroy

    belongs_to :category # Un producto pertenece a una categoria (claves foraneas)
    belongs_to :user # Un producto pertenece a un usuario (claves foraneas)
end
