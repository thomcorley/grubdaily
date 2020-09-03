class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :publish, :unpublish]
  before_action :authenticate, only: [:index, :edit, :update, :destroy, :create, :publish]

  def index
    @recipes = Recipe.all
  end

  def show
    unless @recipe
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
      return
    end

    @ingredient_sets = @recipe.ingredient_sets

    @introduction_paragraphs = @recipe.introduction.split("\n").map do |paragraph|
      MarkdownConverter.convert(paragraph)
    end

    @method_steps_with_description = @recipe.method_steps.order(:position).map do |method_step|
      OpenStruct.new(
        method_step: method_step,
        description: MarkdownConverter.convert(method_step.description)
      )
    end

    @ingredient_entries = @recipe.ingredient_entries

    @tags = @recipe.tags.split(",")

    @prev_recipe = Recipe.find_by_id(@recipe.id - 1)
    @next_recipe = Recipe.find_by_id(@recipe.id + 1)
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  def publish
    @recipe.publish!
    redirect_to recipe_path(@recipe), flash: { notice: "Recipe successfully published!" }
  end

  def unpublish
    @recipe.unpublish!
    redirect_to recipe_path(@recipe), flash: { notice: "Recipe unpublished" }
  end

  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def authenticate
    # Only allowing access from home IP address
    not_found unless Rails.env.development? || request.remote_ip == "82.44.245.7"
  end

  def set_recipe
    # Confusingly, `recipe_title` is usually the permalink of the recipe, but sometimes the ID
    if params["recipe_path"]
      @recipe = Recipe.all.find { |recipe| recipe.permalink == "/#{params["recipe_path"]}" }
    elsif params[:id]
      @recipe = Recipe.find_by_id(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recipe_params
    params.require(:recipe).permit(:title, :summary, :total_time, :introduction, :serves, :makes, :makes_unit, :recipe_type, :tags)
  end
end
