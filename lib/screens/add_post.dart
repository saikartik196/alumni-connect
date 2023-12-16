import 'dart:io';

import 'package:alumni_connect/constant/gloabalvariable.dart';
import 'package:alumni_connect/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? imageUrl;
  File? pickedImage;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.mainColor,
        title:
            const Text('Add New Post', style: TextStyle(color: Colors.white)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text("Enter Title:",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a detailed description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: const Color.fromRGBO(232, 250, 248, 1),
                hoverColor: GlobalVariables.mainColor,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                prefixIcon: const Icon(
                  Icons.title,
                  color: GlobalVariables.mainColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text("Enter Description:",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a detailed description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.description,
                    color: GlobalVariables.mainColor),
                filled: true,
                fillColor: const Color.fromARGB(255, 232, 250, 248),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, color: GlobalVariables.mainColor),
                TextButton(
                  onPressed: _showImageSourceDialog,
                  child: const Text(
                    'Pick Image',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (pickedImage != null)
              Image.file(
                pickedImage!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 30),
            isUploading
                ? const CircularProgressIndicator()
                : Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_validateInputs()) {
                          setState(() {
                            isUploading = true;
                          });

                          String? downloadUrl;

                          try {
                            if (pickedImage != null) {
                              downloadUrl = await _uploadImageToFirebaseStorage(
                                pickedImage!,
                              );
                            }

                            User? currentUser =
                                FirebaseAuth.instance.currentUser;

                            if (currentUser != null) {
                              Post newPost = Post(
                                title: titleController.text,
                                description: descriptionController.text,
                                userName:
                                    currentUser.displayName ?? 'Anonymous',
                                imageUrl: downloadUrl,
                                postedDate: DateTime.now().toString(),
                                userProfileImageUrl: currentUser.photoURL,
                              );

                              await _addPostToFirestore(newPost);

                              Navigator.pop(context, newPost);
                            } else {
                              print('User not signed in.');
                            }
                          } catch (error) {
                            print('Error uploading data: $error');
                          } finally {
                            setState(() {
                              isUploading = false;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: GlobalVariables.mainColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 15),
                          Icon(Icons.upload_outlined),
                          SizedBox(width: 15),
                          Text(
                            'Add Post',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      print('Title and description cannot be empty.');
      return false;
    }

    return true;
  }

  Future<void> _addPostToFirestore(Post newPost) async {
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'title': newPost.title,
        'description': newPost.description,
        'userName': newPost.userName,
        'imageUrl': newPost.imageUrl,
        'postedDate': newPost.postedDate,
        'userProfileImageUrl': newPost.userProfileImageUrl,
      });
    } catch (e) {
      print('Error adding post to Firestore: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImageFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });
    }
  }

  Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
    String folderName = 'postsImages';
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference =
        FirebaseStorage.instance.ref().child('$folderName/$fileName.jpg');

    await storageReference.putFile(imageFile);

    String downloadUrl = await storageReference.getDownloadURL();

    return downloadUrl;
  }
}
