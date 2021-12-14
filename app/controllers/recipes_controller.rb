class RecipesController < ApplicationController
    before_action :authorize
    def index
        recipe= Recipe.all
        render json: recipe
    end

    def show
        recipe= this_recipe
        render json: recipe
        # , each_serializer: RecipeSerializer
    end

    def create
        recipe= Recipe.create(recipe_params)
        if recipe.valid?
            render json: recipe, status: :created
        else 
            render json: { errors: recipe.errors.full_message }, status: :unprocessable_entity
        end
    end

    def destroy
        recipe= this_recipe
        head :no_content
    end

    def update
        recipe= this_recipe
        recipe.update(recipe_params)
        render json: recipe
    end

    private

    def this_recipe
        Recipe.find_by(id: params[:id]) 
    end
    def recipe_params
        params.permit(:id, :title, :instructions, :minutes_to_complete, :user_id)
    end

    def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end
end
