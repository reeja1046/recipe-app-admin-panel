// ignore_for_file: unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/core/constants/show_toast.dart';
import 'package:recipe_app/core/constants/sizedbox.dart';
import 'package:recipe_app/core/constants/text_strings.dart';
import 'package:recipe_app/controllers/admin_service.dart';
import 'package:recipe_app/view/profile/widgets/profile_photo_upload.dart';
import 'package:recipe_app/view/profile/widgets/textenteringfield.dart';

class MyAccountEdit extends StatefulWidget {
  const MyAccountEdit({super.key});

  @override
  State<MyAccountEdit> createState() => _MyAccountEditState();
}

class _MyAccountEditState extends State<MyAccountEdit> {
  Map<String, dynamic>? adminData;
  final AdminService adminService = AdminService();
  String imageUrl = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final CollectionReference adminDetail =
      FirebaseFirestore.instance.collection('admin_profile');
  @override
  void initState() {
    super.initState();
    fetchAdminData();
  }

  Future<void> fetchAdminData() async {
    try {
      String adminId = FirebaseAuth.instance.currentUser!.uid;

      if (adminId == null) {
        showToast(message: 'User is not signed in');
        return;
      }
      // Fetch user data from Firestore
      adminData = await adminService.getAdminData(adminId);
      if (adminData != null) {
        setState(() {
          // Set the text field controllers with fetched user data
          nameController.text = adminData?['AdminName'] ?? '';
          emailController.text = adminData?['AdminEmail'] ?? '';
          mobileNumberController.text = adminData?['AdminPhone'] ?? '';
          imageUrl = adminData?['AdminProfileImage'] ?? '';
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizedBoxHeightWidth sizedboxhelper = SizedBoxHeightWidth();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Profile',
          style: TextSize.appBarTitle,
        ),
        backgroundColor: AppColor.baseColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: ProfilePic(
                            currentImage: imageUrl,
                            onImageSelected: (url) {
                              setState(() {
                                imageUrl = url;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextEnteringField(
                              text: 'Name',
                              keyboardtype: TextInputType.text,
                              controller: nameController,
                            ),
                            sizedboxhelper.kheight20,
                            TextEnteringField(
                              text: 'Email',
                              keyboardtype: TextInputType.emailAddress,
                              controller: emailController,
                            ),
                            sizedboxhelper.kheight20,
                            TextEnteringField(
                              text: 'Mobile Number',
                              keyboardtype: TextInputType.number,
                              controller: mobileNumberController,
                            ),
                            sizedboxhelper.kheight30,
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.baseColor,
                              ),
                              onPressed: () {
                                saveadminData();
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  saveadminData() async {
    String adminId = FirebaseAuth.instance.currentUser!.uid;

    if (adminId == null) {
      showToast(message: 'User is not signed in');
      return;
    }

    bool adminIdExists = await adminService.doesAdminIdExist(adminId);

    if (adminIdExists) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Admin data already saved'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    Map<String, dynamic> adminData = {
      'adminId': adminId,
      'AdminName': nameController.text,
      'AdminEmail': emailController.text,
      'AdminPhone': mobileNumberController.text,
      'AdminProfileImage': imageUrl,
    };
    print(adminData);

    String username = nameController.text;
    String useremail = emailController.text;
    String userphone = mobileNumberController.text;

    if (username.isEmpty ||
        useremail.isEmpty ||
        userphone.isEmpty ||
        imageUrl.isEmpty) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All fields are required'),
            content: const Text('Please fill in all the required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    adminService.saveAdminDataToFirebase(adminData, adminId);
  }
}
