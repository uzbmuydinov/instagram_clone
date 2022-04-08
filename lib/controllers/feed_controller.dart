import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagramclon/models/post_model.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/utils.dart';

class FeedController extends GetxController{
  bool isLoading = false;
  List<Post> postList = [];

  void apiLoadFeeds() {
    isLoading = true;
    update();

    DataService.loadFeeds().then((value) => {
      resLoadFeeds(value),
    });
    update();
  }

  void resLoadFeeds(List<Post> list) {
    isLoading = false;
    update();
    postList = list;
    update();
  }

  void apiPostLike(Post post) async {
    isLoading = true;
    update();

    await DataService.likePost(post, true);

    isLoading = false;
    update();
    post.liked = true;
    update();
  }

  void apiPostUnLike(Post post) async {
    isLoading = true;
    update();

    await DataService.likePost(post, false);

    isLoading = false;
    update();
    post.liked = false;
    update();
  }

  void actionRemovePost(BuildContext context,Post post)async{
    var result = await Utils.dialogCommon(context, "Do you want to remove this post", "Instagram clone", false);
    if(result){
      DataService.removePost(post).then((value) => {
        apiLoadFeeds()
      });
    }
    update();
  }
}