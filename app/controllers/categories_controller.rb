class CategoriesController < ApplicationController
  def show
    @current_category = @category = Category.find(params[:id])
    @talks = Talk.talks_with_user_specific_info(current_user[:id], params[:page], @category.id)
  end
end
