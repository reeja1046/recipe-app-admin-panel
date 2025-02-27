import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/controllers/bottom_navbar.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:super_bottom_navigation_bar/super_bottom_navigation_bar.dart';

class BottomNavBar extends StatelessWidget {
  final BottomNavBarController controller = Get.put(BottomNavBarController());
  BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pages[controller.selectedIndex.value]),
      bottomNavigationBar: SuperBottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: controller.selectedIndex.value,
        items: const [
          SuperBottomNavigationBarItem(
            unSelectedIcon: Icons.home_outlined,
            selectedIcon: Icons.home,
            splashColor: AppColor.baseColor,
            borderBottomColor: AppColor.baseColor,
            selectedIconColor: AppColor.baseColor,
            unSelectedIconColor: Colors.black,
          ),
          SuperBottomNavigationBarItem(
            unSelectedIcon: Icons.category_outlined,
            selectedIcon: Icons.category,
            splashColor: AppColor.baseColor,
            borderBottomColor: AppColor.baseColor,
            selectedIconColor: AppColor.baseColor,
            unSelectedIconColor: Colors.black,
          ),
          SuperBottomNavigationBarItem(
            unSelectedIcon: Icons.person_outline_rounded,
            selectedIcon: Icons.person,
            splashColor: AppColor.baseColor,
            borderBottomColor: AppColor.baseColor,
            selectedIconColor: AppColor.baseColor,
            unSelectedIconColor: Colors.black,
          ),
        ],
        onSelected: (index) {
          controller.changeSelectedIndex(index);
        },
      ),
    );
  }
}
