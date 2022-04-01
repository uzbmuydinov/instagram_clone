import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramclon/services/utils.dart';

import '../models/post_model.dart';
import '../services/data_service.dart';

class LikePage extends StatefulWidget {
  const LikePage({Key? key}) : super(key: key);

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  List<Post> postList = [];
  bool isLoading = false;

  void _apiLoadLikes() {
    setState(() {
      isLoading = true;
    });

    DataService.loadLikes().then((value) => {
          _resLoadLikes(value),
        });
  }

  void _resLoadLikes(List<Post> posts) {
    setState(() {
      isLoading = false;
      postList = posts;
    });
  }

  void _actionRemovePost(Post post)async{
    var result = await Utils.dialogCommon(context, "Do you want to remove this post", "Instagram clone", false);
    if(result){
      DataService.removePost(post).then((value) => {
        _apiLoadLikes()
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _apiLoadLikes();
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
          "Likes",
          style: TextStyle(
              fontFamily: "Billabong", fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: !isLoading?Container(
        child: ListView.builder(
          itemCount: postList.length,
          itemBuilder: (context, index) {
            return _itemOfPost(index);
          },
        ),
      ):const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _itemOfPost(index) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(),
          //userinfo
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: const Image(
                          image: AssetImage("assets/images/img.png"),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postList[index].fullName.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          postList[index].date.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
                postList[index].mine?IconButton(onPressed: () {
                  _actionRemovePost(postList[index]);
                }, icon: Icon(Icons.more_horiz),):SizedBox.shrink(),
              ],
            ),
          ),
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            imageUrl: postList[index].img_post,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share_outlined),
                  ),
                ],
              ),
            ],
          ),
          // #caption
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: postList[index].caption,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
