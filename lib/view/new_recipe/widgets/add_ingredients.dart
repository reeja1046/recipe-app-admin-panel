import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/colors.dart';

class IngredientsForm extends StatefulWidget {
  final Function(List<String>) onIngredientsChanged;
  final List<String> initialIngredients;

  const IngredientsForm({
    Key? key,
    required this.onIngredientsChanged,
    required this.initialIngredients,
  }) : super(key: key);

  @override
  State<IngredientsForm> createState() => _IngredientsFormState();
}

class _IngredientsFormState extends State<IngredientsForm> {
  List<TextEditingController> ingredientControllers = [];
  final double textFieldHeight = 60;
  final double verticalPadding = 8.0;
  final double containerHeight = 200; // Fixed height for the container

  @override
  void initState() {
    super.initState();
    if (widget.initialIngredients.isNotEmpty) {
      ingredientControllers = widget.initialIngredients.map((ingredient) {
        TextEditingController controller = TextEditingController();
        controller.text = ingredient;
        return controller;
      }).toList();
    } else {
      ingredientControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  ingredientControllers.add(TextEditingController());
                });
              },
              child: const Text(
                'Add More',
                style: TextStyle(color: AppColor.baseColor),
              ),
            ),
          ],
        ),
        Container(
          height: containerHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.baseColor),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Scrollbar(
            trackVisibility: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < ingredientControllers.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          top: i == 0 ? 0 : verticalPadding,
                          bottom: i == ingredientControllers.length - 1
                              ? 0
                              : verticalPadding,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: ingredientControllers[i],
                                decoration: InputDecoration(
                                  labelText: 'Ingredient ${i + 1}',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: AppColor.baseColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: AppColor.baseColor),
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 15),
                                ),
                                onChanged: (value) {
                                  widget.onIngredientsChanged(
                                      getIngredientsList());
                                },
                              ),
                            ),
                            if (i > 0)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    ingredientControllers.removeAt(i);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<String> getIngredientsList() {
    return ingredientControllers.map((controller) => controller.text).toList();
  }
}
