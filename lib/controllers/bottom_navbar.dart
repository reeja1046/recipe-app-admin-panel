import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/view/categories/category.dart';
import 'package:recipe_app/view/profile/my_account.dart';
import 'package:recipe_app/view/home/home_screen.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;
  var isRepeat = false.obs;
  var isShuffle = false.obs;

  void changeSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    MyHomePage(),
    const CategoryScreen(),
    const MyAccountEdit(),
  ];
}
