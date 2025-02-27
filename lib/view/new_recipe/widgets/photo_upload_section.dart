import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/core/constants/show_toast.dart';
import 'package:recipe_app/controllers/recipe_service.dart';

// ignore: must_be_immutable
class PhotoUploadSection extends StatefulWidget {
  final void Function(List<String>) onImagesSelected;
  String initialImage;
  PhotoUploadSection(
      {Key? key, required this.onImagesSelected, required this.initialImage})
      : super(key: key);

  @override
  State<PhotoUploadSection> createState() => _PhotoUploadSectionState();
}

class _PhotoUploadSectionState extends State<PhotoUploadSection> {
  RecipeService addrecipe = RecipeService();
  List<String> imageUrls = [];
  List<File> pickedImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialImage.isNotEmpty) {
      imageUrls.add(widget.initialImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.baseColor),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16.0),
          if (widget.initialImage.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          imageUrls.remove(widget.initialImage);
                          widget.initialImage = '';
                          pickedImages.clear();
                          widget.onImagesSelected(imageUrls);
                        });
                      },
                    ),
                    if (widget.initialImage != null)
                      Image.network(
                        widget.initialImage,
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                  ]),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(
              Icons.photo_library,
              size: 40.0,
              color: Colors.grey,
            ),
            onPressed: () async {
              ImagePicker imagePicker = ImagePicker();

              List<XFile>? files = await imagePicker.pickMultiImage(
                  maxWidth: 1920, imageQuality: 80);

              if (files == null) return;

              for (XFile file in files) {
                String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');
                Reference referenceImageToUpload =
                    referenceDirImages.child(uniqueFileName);

                try {
                  await referenceImageToUpload.putFile(File(file.path));
                  String imageUrl =
                      await referenceImageToUpload.getDownloadURL();
                  setState(() {
                    pickedImages.add(File(file.path));
                    imageUrls.add(imageUrl);
                  });
                } catch (error) {
                  showToast(message: 'Error uploading image: $error');
                }
              }

              widget.onImagesSelected(imageUrls);
            },
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Click here to upload photos',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: pickedImages.asMap().entries.map((entry) {
                final int index = entry.key;
                final File image = entry.value;

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        image,
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            pickedImages.removeAt(index);
                            imageUrls.removeAt(index);
                          });
                          widget.onImagesSelected(imageUrls);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.all(4.0),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
