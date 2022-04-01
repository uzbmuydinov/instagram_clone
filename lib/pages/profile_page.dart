import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclon/models/user_model.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/utils.dart';

import '../models/post_model.dart';
import '../services/auth_service.dart';
import '../services/file_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> postList = [];
  bool isLoading = false;
  File? file;
  User? user;

  void _apiLoadPosts() {
    setState(() {
      isLoading = true;
    });
    DataService.loadPosts().then((value) => {
          _resLoadPosts(value),
        });
  }

  void _resLoadPosts(List<Post> list) {
    setState(() {
      isLoading = false;
      postList = list;
    });
  }

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

    _apiChangePhoto();
  }

  // for load user
  void _apiLoadUser() async {
    setState(() {
      isLoading = true;
    });
    DataService.loadUser().then((value) => _showUserInfo(value));
  }

  void _showUserInfo(User user) {
    setState(() {
      this.user = user;
      isLoading = false;
    });
  }

  // for edit user
  void _apiChangePhoto() {
    if (file == null) return;

    setState(() {
      isLoading = true;
    });
    FileService.uploadImage(file!, FileService.folderUserImg)
        .then((value) => _apiUpdateUser(value));
  }

  void _apiUpdateUser(String imgUrl) async {
    setState(() {
      isLoading = false;
      user?.imageUrl = imgUrl;
    });
    await DataService.updateUser(user!);
  }

  Future _getImageOfCamera() async {
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

    _apiChangePhoto();
  }

  _actionLogOut() async {
    var result = await Utils.dialogCommon(
        context, "Do you want to log out", "Instagram clone", false);
    if (result) {
      AuthService.signOutUser(context);
    }
  }

  void _actionRemovePost(Post post)async{
    var result = await Utils.dialogCommon(context, "Do you want to remove this post", "Instagram clone", false);
    if(result){
      DataService.removePost(post).then((value) => {
        _apiLoadPosts(),
      });
    }
  }

  @override
  void initState() {
    _apiLoadUser();
    _apiLoadPosts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Profile",
            style: TextStyle(
                fontFamily: "Billabong", fontSize: 25, color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  _actionLogOut();
                },
                icon: const Icon(
                  Icons.login_outlined,
                  color: Colors.black,
                ))
          ],
        ),
        body: user != null
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return bottomSheet();
                                });
                          },
                          child: Badge(
                            badgeColor: Colors.purple,
                            badgeContent: const Text(
                              "+",
                              style: TextStyle(color: Colors.white),
                            ),
                            position:
                                const BadgePosition(bottom: -5, end: 2),
                            child: Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                      color: !isLoading
                                          ? Colors.purple
                                          : Colors.white,
                                      width: 2)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: user?.imageUrl == null ||
                                        user!.imageUrl!.isEmpty
                                    ? const Image(
                                        image: AssetImage(
                                            "assets/images/img.png"),
                                        height: 50,
                                        width: 50,
                                      )
                                    : Image(
                                        image:
                                            NetworkImage(user!.imageUrl!),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        isLoading
                            ? const SizedBox(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.purple),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user!.fullName.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      user!.email,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ///posts
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  postList.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const Text(
                                  "POSTS",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                          height: 25,
                        ),

                        ///followers
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  user!.followersCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const Text(
                                  "FOLLOWERS",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                          height: 25,
                        ),

                        ///following
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  user!.followingCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const Text(
                                  "FOLLOWING",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const TabBar(
                      indicatorColor: Colors.grey,
                      tabs: [
                        Tab(
                          child: Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                        ),
                        Tab(
                          child: Icon(
                            Icons.grid_view,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: ListView.builder(
                              itemCount: postList.length,
                              itemBuilder: (context, index) {
                                return verticalScrollItem(context, index);
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: GridView.builder(
                              itemCount: postList.length,
                              itemBuilder: (context, index) {
                                return horizScrollItem(context, index);
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  GestureDetector horizScrollItem(BuildContext context, int index) {
    return GestureDetector(
                                onLongPress: (){
                                  _actionRemovePost(postList[index]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  alignment: Alignment.topRight,
                                  child: CachedNetworkImage(
                                    width:
                                        MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.width,
                                    imageUrl: postList[index].img_post,
                                    placeholder: (context, url) =>
                                        const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
  }

  Column verticalScrollItem(BuildContext context, int index) {
    return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: CachedNetworkImage(
                                      height: MediaQuery.of(context)
                                          .size
                                          .width,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      imageUrl: postList[index].img_post,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child:
                                            CircularProgressIndicator(),
                                      ),
                                      errorWidget:
                                          (context, url, error) =>
                                              const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Text(postList[index].caption,style: TextStyle(fontSize: 25,fontFamily: "Billabong"),),
                                        IconButton(
                                          onPressed: () {
                                            _actionRemovePost(postList[index]);
                                          },
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                  ),
                                ],
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
              _getImageOfCamera();
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
