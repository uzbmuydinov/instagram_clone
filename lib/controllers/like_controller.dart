import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagramclon/models/post_model.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/utils.dart';

class LikeController extends GetxController{
  List<Post> postList = [];
  bool isLoading = false;

  void apiLoadLikes() {
    isLoading = true;
    update();

    DataService.loadLikes().then((value) => {
      resLoadLikes(value),
    });
  }

  void resLoadLikes(List<Post> posts) {
    isLoading = false;
    update();
    postList = posts;
    update();
  }

  void actionRemovePost(BuildContext context,Post post)async{
    var result = await Utils.dialogCommon(context, "Do you want to remove this post", "Instagram clone", false);
    if(result){
      DataService.removePost(post).then((value) => {
        apiLoadLikes()
      });
    }
  }
}