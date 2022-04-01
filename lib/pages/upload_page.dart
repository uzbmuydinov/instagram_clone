import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclon/models/post_model.dart';
import 'package:instagramclon/pages/home_page.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/file_service.dart';

class UploadPage extends StatefulWidget {
  PageController? pageController;

  UploadPage({Key? key, this.pageController}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final captionController = TextEditingController();
  File? file;
  bool isLoading = false;

  Future _getImageOfGalary() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        file = File(image.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future _getImageOfCamere() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        file = File(image.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  void _uploadNewPost() {
    String caption = captionController.text.trim().toString();
    if (caption.isEmpty) return;
    if (file == null) return;

    _apiPostImage();
  }

  void _apiPostImage() {
    setState(() {
      isLoading = true;
    });

    FileService.uploadImage(file!, FileService.folderPostImg).then((value) => {
          _resPostImage(value),
        });
  }

  void _resPostImage(String downloadUrl) {
    String caption = captionController.text.toString().trim();
    Post post = Post(img_post: downloadUrl, caption: caption);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async {
    Post posted = await DataService.storePost(post);
    await DataService.storeFeed(posted).then((value) => {
          Navigator.of(context).pushReplacementNamed(HomePage.id),
          setState(() {
            file = null;
            captionController.clear();
            isLoading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Upload",
          style: TextStyle(
              fontFamily: "Billabong", fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.purple,
            ),
            onPressed: () {
              _uploadNewPost();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  file == null
                      ? GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return bottomSheet();
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            color: Colors.grey.shade300,
                            child: Icon(
                              Icons.add_a_photo_rounded,
                              size: 70,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 400,
                          child: Image(
                            image: FileImage(file!),
                            fit: BoxFit.cover,
                          ),
                        ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: captionController,
                      decoration: const InputDecoration(
                        hintText: "Caption",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                      minLines: 1,
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    endIndent: 10,
                    indent: 10,
                    height: 3,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
          isLoading? LinearProgressIndicator():SizedBox.shrink(),
        ],
      ),
    );
  }

  SizedBox bottomSheet() {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    Icons.image_outlined,
                    size: 30,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Pick Photo",
                    style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            onTap: () {
              _getImageOfGalary();
              Navigator.pop(context);
            },
          ),
          GestureDetector(
            onTap: () {
              _getImageOfCamere();
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Take Photo",
                    style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
