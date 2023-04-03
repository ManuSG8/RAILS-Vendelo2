class FavoritesController < ApplicationController
    def index

    end

    def create
        # Favorite.create(product: product, user: Current.user)
        product.favorites.create(user: Current.user) # Equivalente a la linea superior
        redirect_to product_path(product)
    end

    def destroy
        product.favorites.find_by(user: Current.user).destroy
        redirect_to product_path(product), status: :see_other
    end

    private
    def product
        @product ||= Product.find(params[:product_id]) # Asi catcheamos el producto para no llamarlo de cada vez. El nombre en el @ debe coincidir con el nombre del metodo
    end
end