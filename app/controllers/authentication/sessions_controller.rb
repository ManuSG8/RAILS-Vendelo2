class Authentication::SessionsController < ApplicationController
    skip_before_action :protect_pages # Aqui saltamos la proteccion de la pagina
    
    def new
    end
    
    def create
        @user = User.find_by("email = :login OR username = :login", { login: params[:login] })

        if @user&.authenticate(params[:password]) # El metodo authenticate viene e la gema BCrypt y con el '&' lo ejecuta solo si el usuario existe
            session[:user_id] = @user.id
            redirect_to products_path, notice: t('.created')
        else
            redirect_to new_session_path, alert: t('.failed')
        end
    end

    def destroy
        session.delete(:user_id)
        redirect_to products_path, notice: t('.destroyed')
    end

end