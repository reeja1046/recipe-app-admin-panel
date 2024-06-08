
import 'package:get/get.dart';
import 'package:recipe_app/controllers/recipe_service.dart';
import 'package:recipe_app/models/allrecipe_class.dart';

class RecipeController extends GetxController {
  RecipeService addrecipe = RecipeService();

  void addRecipes(Recipes recipe) {
    Map<String, dynamic> recipeMap = recipe.toMap();

    addrecipe.saveRecipeToFirebase(recipeMap);
  }
}
