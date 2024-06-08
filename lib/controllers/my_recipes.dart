import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:recipe_app/models/myrecipe_class.dart';

class MyRecipeController extends GetxController {
  final RxList<MyRecipes> recipes = <MyRecipes>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      FirebaseFirestore.instance
          .collection('admin recipes')
          .snapshots()
          .listen((snapshot) {
        print(snapshot.docs);
        recipes.assignAll(
          snapshot.docs.map((doc) {
            String recipeId = doc.id;
            return MyRecipes(
              recipeId: recipeId,
              imageUrl: doc['imageUrl'] ?? 'assets/placeholder.jpg',
              recipeName: doc['recipeName'] ?? '',
            );
          }),
        );
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  void deleteRecipe(MyRecipes recipe) async {
    try {
      // Delete recipe locally
      recipes.remove(recipe);
      update();

      // Delete recipe from Firestore
      await FirebaseFirestore.instance
          .collection('admin recipes')
          .doc(recipe.recipeId!)
          .delete();
    } catch (error) {
      print('Failed to delete recipe: $error');
    }
  }
}
