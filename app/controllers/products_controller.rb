class ProductsController < ApplicationController
    skip_before_action :protect_pages, only: [:index, :show] # Aqui saltamos la proteccion de la pagina para ciertas acciones

    def index
        @categories = Category.all.load_async
        # @products = Product.all.with_attached_photo # Con with_attached_photo evitamos las consultas innecesarias que se hacen a la BD

        # # Filtrado por categorias
        # if params[:category_id]
        #     @products = @products.where(category_id: params[:category_id]) # Extendemos la query anterior
        # end

        # if params[:min_price].present? # Con present? comprobamos que el parametro contiene valor, porque se va enviar aunque este vacio 
        #     @products = @products.where('price >= ?', params[:min_price]) # Aqui el '?' es parecido a PHP
        # end

        # if params[:max_price].present?
        #     @products = @products.where('price <= ?', params[:max_price])
        # end

        # if params[:query_text].present?
        #     @products = @products.search_full_text(params[:query_text])
        # end

        # if params[:order_by].present?
        #     order_by = {
        #         newest: 'created_at DESC',
        #         expensive: 'price DESC',
        #         cheapest: 'price ASC'
        #     }.fetch(params[:order_by]&.to_sym, 'created_at DESC') # Recibimos un string por parametros, con to_sym lo convertimos a simbolo
        #     # order[params[:order_by]] Esto hace los mismo que el fetch anterior, pero el fetch nos ofrece la posibilidad de introducir un valor por defecto (created_at DESC), incluso el bloque IF no seria necesario

        #     @products = @products.order(order_by).load_async # ATENCION: Solo puede haber un order en cada consulta, asegurate de que no tienes ningun order en las consultas anteriores
        #                                                      # Ademas el metodo load_async siempre tiene que ir al final
        # end

        # @pagy, @products = pagy_countless(@products, items: 12)

        # Todo lo anterior lo refactorizamos asi. El archivo esta en app > queries > find_products.rb
        @pagy, @products = pagy_countless(FindProducts.new.call(product_params_index).load_async, items: 12)
    end

    def show
        product
    end

    def new
        @product = Product.new
    end

    def create
        @product = Current.user.products.new(product_params) # Rails es suficientemente inteligente para recoger los productos de cada usuario. Automaticamente asigna el nuevo producto al usuario  con la sesion iniciada

        if @product.save
            redirect_to products_path, notice: t('.created')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        authorize! product # Metodo creado en application_controller.rb
    end

    def update
        authorize! product # Metodo creado en application_controller.rb

        if product.update(product_params) # Aqui quitamos el @ y asi llamamos al metodo producto creado mas abajo y se le aplica el update directamente
            redirect_to products_path, notice: t('.updated')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        authorize! product # Metodo creado en application_controller.rb

        product.destroy # Aqui quitamos el @ y asi llamamos al metodo producto creado mas abajo y se le aplica el destroy directamente

        redirect_to products_path, notice: t('.destroyed'), status: :see_other # Siempre que haya una peticion DELETE con turbo, debemos pasarle -> status: :see_other
    end

    private
    def product_params
        params.require(:product).permit(:title, :description, :price, :photo, :category_id)
    end

    def product_params_index
        params.permit(:category_id, :min_price, :max_price, :query_text, :order_by, :page, :favorites)
    end

    def product
        @product = Product.find(params[:id]) # En ruby, la ultima sentencia se corresponde con el return
    end
end