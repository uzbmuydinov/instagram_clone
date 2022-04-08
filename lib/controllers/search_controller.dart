import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/models/user_model.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/get_storage.dart';
import 'package:instagramclon/services/http_service.dart';

class SearchController extends GetxController{
  TextEditingController controller = TextEditingController();
  List<User> user = [];
  bool isLoading = false;

  void apiSearchUsers(String keyword) {
    isLoading = true;
    update();
    DataService.searchUsers(keyword).then((users) => resSearchUser(users));
  }

  void resSearchUser(List<User> users) {
    isLoading = false;
    update();
    user = users;
    update();
  }

  void apiFollowUser(User someone)async{
    isLoading = true;
    update();

    await DataService.followUser(someone);
    someone.followed = true;
    update();
    isLoading = false;
    update();
    DataService.storePostsToMyFeed(someone);
  }

  void apiUnFollowUser(User someone)async{
    isLoading = true;

    await DataService.unFollowUser(someone);
    someone.followed = false;
    update();
    isLoading = false;
    update();

    DataService.removePostsFromMyFeed(someone);
  }

  void notification(User user)async{
    String? token = await GetStorageDB.load(StorageKeys.TOKEN);
    Network.POST(Network.API_CREATE, Network.paramsCreate(token!,user.fullName)).then((value) => {
    });
  }
}