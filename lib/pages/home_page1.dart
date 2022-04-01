import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramclon/models/post_model.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/utils.dart';
import 'package:share_plus/share_plus.dart';

class HomePage1 extends StatefulWidget {
  PageController? pageController;

  HomePage1({Key? key, this.pageController}) : super(key: key);

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  bool isLoading = false;
  List<Post> postList = [];

  void _apiLoadFeeds() {
    setState(() {
      isLoading = true;
    });
    DataService.loadFeeds().then((value) => {
          _resLoadFeeds(value),
        });
  }

  void _resLoadFeeds(List<Post> list) {
    setState(() {
      isLoading = false;
      postList = list;
    });
  }

  void _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });

    await DataService.likePost(post, true);

    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });

    await DataService.likePost(post, false);

    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  void _actionRemovePost(Post post)async{
    var result = await Utils.dialogCommon(context, "Do you want to remove this post", "Instagram clone", false);
    if(result){
      DataService.removePost(post).then((value) => {
        _apiLoadFeeds()
      });
    }
  }

  @override
  void initState() {
    _apiLoadFeeds();
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
          "Instagram",
          style: TextStyle(
              fontFamily: "Billabong", fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.black,
            ),
            onPressed: () {
              widget.pageController!.jumpToPage(2);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: postList.length,
        itemBuilder: (context, index) {
          return _itemOfPost(index);
        },
      ),
    );
  }

  Widget _itemOfPost(index) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(),
          //userinfo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          postList[index].fullName!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          postList[index].date!,
                        ),
                      ],
                    ),
                  ],
                ),

                ///remove
                postList[index].mine?IconButton(
                  onPressed: () {
                    _actionRemovePost(postList[index]);
                  },
                  icon: Icon(Icons.more_horiz),
                ):SizedBox.shrink(),
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
                      onPressed: () {
                        if (postList[index].liked) {
                          _apiPostUnLike(postList[index]);
                        } else {
                          _apiPostLike(postList[index]);
                        }
                      },
                      icon: Icon(
                        postList[index].liked
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color:
                            postList[index].liked ? Colors.red : Colors.black,
                      )),
                  IconButton(
                    onPressed: () {
                      Share.share('${postList[index].img_post}',subject: postList[index].caption);
                    },
                    icon: Icon(Icons.share),
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
