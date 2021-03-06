class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    @user = current_user
    @recipe = Recipe.new
    5.times do
      @recipe_ingredient = @recipe.recipe_ingredients.build
      @recipe_ingredient.build_ingredient
    end
  end

  def create
    @recipe = Recipe.new(recipe_params) do |r|
      r.user = current_user
    end
    if @recipe.save
      @recipe.add_ingredients_to_recipe(recipe_ingredient_params)
      respond_to do |format|
        format.html { redirect_to recipes_path }
        format.js { } #controller method sends back response as js
      end
    else
      render 'new'
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @review = Review.new
  end

  def edit
    @recipe = Recipe.find(params[:id])
    if @recipe.ingredients.length === 1
      4.times do
        @recipe_ingredient = @recipe.recipe_ingredients.build
        @recipe_ingredient.build_ingredient
      end
    elsif @recipe.ingredients.length === 2
      3.times do
        @recipe_ingredient = @recipe.recipe_ingredients.build
        @recipe_ingredient.build_ingredient
      end
    elsif @recipe.ingredients.length === 3
      2.times do
        @recipe_ingredient = @recipe.recipe_ingredients.build
        @recipe_ingredient.build_ingredient
      end
    elsif @recipe.ingredients.length === 4
      1.time do
        @recipe_ingredient = @recipe.recipe_ingredients.build
        @recipe_ingredient.build_ingredient
      end
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      @recipe.add_ingredients_to_recipe(recipe_ingredient_params)
      flash[:notice] = 'Recipe was successfully updated.'
      redirect_to @recipe
    else
      render 'edit'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path
  end

  def quickest
    @recipes = Recipe.quickest
  end

  private
  def recipe_params
    params.require(:recipe).permit(:name, :prep_time, :cook_time, :instructions, :user_id, recipe_ingredients_attributes: [:quantity, :ingredient_id, ingredient: [:name]])
  end

  def recipe_ingredient_params
    params.require(:recipe).permit(recipe_ingredients_attributes: [:quantity, :ingredient_id, ingredient: [:name]])
  end

end
