import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/controllers/my_recipes.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/core/constants/sizedbox.dart';
import 'package:recipe_app/core/constants/text_strings.dart';
import 'package:recipe_app/models/myrecipe_class.dart';
import 'package:recipe_app/view/new_recipe/add_recipe_screen.dart';
import 'package:recipe_app/widgets/detailed_recipe.dart';

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final SizedBoxHeightWidth sizedboxhelper = SizedBoxHeightWidth();
  final MyRecipeController controller = Get.put(MyRecipeController());
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flavor Fusion',
          style: TextSize.appBarTitle,
        ),
        backgroundColor: AppColor.baseColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Recipes',
                    style: TextSize.titletextsize,
                  ),
                  Obx(() => controller.recipes.isEmpty
                      ? const SizedBox.shrink()
                      : PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: "edit",
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == "edit") {
                              showEditOptions(context);
                            } else if (value == "delete") {
                              showDeleteOptions(context);
                            }
                          },
                        )),
                ],
              ),
              sizedboxhelper.kheight20,
              Obx(() {
                print(controller.recipes);
                print(';;ppppppkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkp');
                if (controller.recipes.isEmpty) {
                  print(controller.recipes);
                  print(';;ppppppppppppppp');
                  return Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Card(
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                              ),
                              const Text(
                                'Oops',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 25),
                              ),
                              const Text(
                                'No Recipes Found',
                                style: TextSize.subtitletextsize,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: controller.recipes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final MyRecipes recipe = controller.recipes[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailedRecipeScreen(
                                  recipeId: recipe.recipeId.toString(),
                                  userId: userId,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.network(
                                  recipe.imageUrl!,
                                  height: 120.0,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Image.asset(
                                        'assets/placeholder.jpg',
                                        height: 120.0,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        recipe.recipeName!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddRecipe(recipeDetail: null));
        },
        backgroundColor: AppColor.baseColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void showDeleteOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select recipe to delete"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (MyRecipes recipe in controller.recipes)
                ListTile(
                  title: Text(recipe.recipeName!),
                  onTap: () {
                    _deleteRecipe(context, recipe);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _deleteRecipe(BuildContext context, MyRecipes recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content:
              Text("Are you sure you want to delete ${recipe.recipeName}?"),
          actions: [
            TextButton(
              onPressed: () {
                controller.deleteRecipe(recipe);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void showEditOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose one to edit"),
          content: SizedBox(
            height: 200,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (MyRecipes recipe in controller.recipes)
                      ListTile(
                        title: Text(recipe.recipeName!),
                        onTap: () {
                          fetchRecipeDetails(recipe.recipeId!);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void fetchRecipeDetails(String recipeId) async {
    var recipeDetail = await FirebaseFirestore.instance
        .collection('admin recipes')
        .doc(recipeId)
        .get();
    if (recipeDetail.exists) {
      Get.to(() => AddRecipe(recipeDetail: recipeDetail));
    }
  }
}
