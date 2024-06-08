import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/sizedbox.dart';
import 'package:recipe_app/core/constants/text_strings.dart';

// ignore: must_be_immutable
class DetailedRecipeScreen extends StatelessWidget {
  final String recipeId; // Pass the recipe ID to the screen
  final String userId;
  DetailedRecipeScreen({Key? key, required this.recipeId, required this.userId})
      : super(key: key);

  final SizedBoxHeightWidth sizeBoxHelper = SizedBoxHeightWidth();

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('admin recipes')
            .doc(recipeId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Recipe not found'));
          }

          final Map<String, dynamic> recipeData =
              snapshot.data!.data() as Map<String, dynamic>;
          print(recipeData);

          final List<String> ingredients =
              List<String>.from(recipeData['ingredients'] ?? []);
          final List<String> instructions =
              List<String>.from(recipeData['instructions'] ?? []);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      recipeData['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                sizeBoxHelper.kheight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${recipeData['recipeName']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    Text(
                      '${recipeData['difficultyText']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    )
                  ],
                ),
                sizeBoxHelper.kheight10,
                Text(
                  '${recipeData['description']}',
                ),
                sizeBoxHelper.kheight10,
                const Text(
                  'Ingredients :',
                  style: TextSize.subtitletextsize,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      title: Text(ingredients[index]),
                    );
                  },
                ),
                sizeBoxHelper.kheight10,
                const Text(
                  'Instructions',
                  style: TextSize.subtitletextsize,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: instructions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      title: Text(instructions[index]),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
