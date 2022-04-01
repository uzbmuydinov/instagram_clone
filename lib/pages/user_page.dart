import 'dart:io';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagramclon/models/user_model.dart';
import 'package:instagramclon/services/data_service.dart';
import '../models/post_model.dart';

class UserPage extends StatefulWidget {
  static const String id = "user_page";
  String? uid;
  UserPage({this.uid,Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Post> postList = [];
  bool isLoading = false;
  File? file;
  User? user;

  void _apiLoadPosts() {
    setState(() {
      isLoading = true;
    });
    DataService.loadUserPosts(widget.uid!).then((value) => {
      _resLoadPosts(value),
    });
  }

  void _resLoadPosts(List<Post> list) {
    setState(() {
      isLoading = false;
      postList = list;
    });
  }

  void _apiLoadUser() async {
    setState(() {
      isLoading = true;
    });
    DataService.loadPostUser(widget.uid!).then((value) => _showUserInfo(value));
  }

  void _showUserInfo(User user) {
    setState(() {
      this.user = user;
      isLoading = false;
    });
  }

  @override
  void initState() {
    _apiLoadUser();
    _apiLoadPosts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  },
                  child: Badge(
                    showBadge: false,
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
            Expanded(
              child: Container(
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
            ),
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  GestureDetector horizScrollItem(BuildContext context, int index) {
    return GestureDetector(
      onLongPress: (){
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

}
