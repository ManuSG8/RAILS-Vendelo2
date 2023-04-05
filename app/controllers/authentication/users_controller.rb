class Authentication::UsersController < ApplicationController # Declaramos antes el namespace authentication que creamos en routes
    skip_before_action :protect_pages # Aqui saltamos la proteccion de la pagina
    
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            UserMailer.with(user: @user).welcome.deliver_later # Enviamos un email al registrarse
            session[:user_id] = @user.id # Definimos una variable de sesion. Parecese a PHP non?
            redirect_to products_path, notice: t('.created')
        else
            render :new, status: :unprocessable_entity
        end
    end

    private
    def user_params
        params.require(:user).permit(:email, :username, :password)
    end
end