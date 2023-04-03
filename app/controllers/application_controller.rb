class ApplicationController < ActionController::Base
    include Pagy::Backend

    class NotAuthorizedError < StandardError
    end

    rescue_from NotAuthorizedError do
        redirect_to products_path, alert: t('common.not_authorized') # Cuando hay una excepcion de NotAuthorizedError (la capturamos mas abajo), hacemos el redirect
    end

    rescue_from ActiveRecord::RecordNotFound do # Excepcion que lanza el metodo show en users_controller.rb (ver archivo)
        redirect_to products_path, alert: t('.common.not_found')
    end

    around_action :switch_locale
    before_action :set_current_user
    before_action :protect_pages

    def switch_locale(&action)
        I18n.with_locale(locale_from_header, &action)
    end

    private
    def locale_from_header
        request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
    end

    def set_current_user
        Current.user = User.find_by(id: session[:user_id]) if session[:user_id] # Buscamos el usuario por el id, si la sesion existe (if session[:user_id])
    end

    def protect_pages
        redirect_to new_session_path, alert: t('not_logged_in') unless Current.user # Redirigimos a login si no tenemos una sesion. Este metodo debemos obviarlo en ciertas paginas (registro, login, ...). Lo definimos en sus controladores.
    end

    def authorize! record = nil # Parametro opcional
        if record
            is_allowed = record.user_id == Current.user&.id
        else
            is_allowed = Current.user.admin?
        end
        raise NotAuthorizedError unless is_allowed # Capturamos el error cuando is_allowed == false, es decir, cuando el usuario no esta permitido
    end
end
