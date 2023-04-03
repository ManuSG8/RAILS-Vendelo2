class UsersController < ApplicationController
    skip_before_action :protect_pages, only: :show

    def show
        @user = User.find_by!(username: params[:username]) # Con la exclamacion, hace que si no encuentra el usuario lanza una excepcion y todo lo que venga a continuacion, incluido el render de show, se va a detener
        @pagy, @products = pagy_countless(FindProducts.new.call({ user_id: @user.id }).load_async, items: 12)
    end
end