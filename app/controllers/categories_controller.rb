class CategoriesController < ApplicationController
  # before_action :authorize! Con esto no tendriamos que poner el authorize! en cada uno de los metodos

  def index
    authorize!

    @categories = Category.all.order(name: :asc)
  end

  def new
    authorize!

    @category = Category.new
  end

  def edit
    authorize!

    category
  end

  def create
    authorize!

    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_url, notice: t('.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize!

    if category.update(category_params)
      redirect_to categories_url, notice: t('.updated') 
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!
    
    category.destroy

    redirect_to categories_url, notice: t('.destroyed') 
  end

  private
    def category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
