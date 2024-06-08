import 'package:flutter/material.dart';
import 'package:recipe_app/controllers/add_recipe.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/core/constants/show_toast.dart';
import 'package:recipe_app/models/allrecipe_class.dart';
import 'package:recipe_app/view/home/home_screen.dart';

class RecipeValidator {
  static void validateRecipe(
      BuildContext context,
      RecipeController rController,
      TextEditingController recipeNameController,
      TextEditingController recipeCategoryController,
      TextEditingController timeController,
      TextEditingController priceController,
      TextEditingController descriptionController,
      TextEditingController difficultyController,
      String userId,
      String imageUrl,
      List<String> ingredientsList,
      List<String> instructionsList,
      // String selectedOption
      ) {
    // ignore: unnecessary_null_comparison
    if (userId == null) {
      showToast(message: 'User is not signed in');
      return;
    }

    String recipetime = timeController.text;
    String recipePrice =
        priceController.text.isEmpty ? " " : priceController.text;

    String recipename = recipeNameController.text;
    String category = recipeCategoryController.text;
    String difficultylevel = difficultyController.text;
    String description = descriptionController.text;

    if (recipename.isEmpty ||
        description.isEmpty ||
        category.isEmpty ||
        recipetime.isEmpty ||
        recipePrice.isEmpty ||
        difficultylevel.isEmpty ||
        imageUrl.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'All fields are required',
              style: TextStyle(
                color: AppColor.favButtonColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please fill in all the required fields.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: AppColor.baseColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );

      return;
    }

    rController.addRecipes(
      Recipes(
        imageUrl: imageUrl,
        price: priceController.text,
        category: recipeCategoryController.text,
        difficultyText: difficultyController.text,
        description: descriptionController.text,
        ingredients: ingredientsList,
        instructions: instructionsList,
        time: timeController.text,
        userId: userId,
        recipeName: recipeNameController.text,
      ),
    
    );
    // Clear input fields
    recipeNameController.clear();
    recipeCategoryController.clear();
    timeController.clear();
    priceController.clear();
    descriptionController.clear();
    imageUrl = '';

    // Navigate back to MyRecipeScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MyHomePage(),
      ),
    );
  }
}
