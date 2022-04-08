import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/feed_controller.dart';
import 'package:share_plus/share_plus.dart';

class HomePage1 extends StatefulWidget {
  PageController? pageController;

  HomePage1({Key? key, this.pageController}) : super(key: key);

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<FeedController>().apiLoadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FeedController(),
        builder: (FeedController _controller) => Scaffold(
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
        itemCount: _controller.postList.length,
        itemBuilder: (context, index) {
          return _itemOfPost(index,_controller);
        },
      ),
    ));
  }

  Widget _itemOfPost(index,FeedController controller) {
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
                          controller.postList[index].fullName!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          controller.postList[index].date!,
                        ),
                      ],
                    ),
                  ],
                ),

                ///remove
                controller.postList[index].mine?IconButton(
                  onPressed: () {
                    controller.actionRemovePost(context,controller.postList[index]);
                  },
                  icon: Icon(Icons.more_horiz),
                ):SizedBox.shrink(),
              ],
            ),
          ),
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            imageUrl: controller.postList[index].img_post,
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
                        if (controller.postList[index].liked) {
                          controller.apiPostUnLike(controller.postList[index]);
                        } else {
                          controller.apiPostLike(controller.postList[index]);
                        }
                      },
                      icon: Icon(
                        controller.postList[index].liked
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color:
                            controller.postList[index].liked ? Colors.red : Colors.black,
                      )),
                  IconButton(
                    onPressed: () {
                      Share.share('${controller.postList[index].img_post}',subject: controller.postList[index].caption);
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
                    text: controller.postList[index].caption,
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
