import 'package:get/get.dart';
import 'package:instagramclon/controllers/feed_controller.dart';
import 'package:instagramclon/controllers/home_controller.dart';
import 'package:instagramclon/controllers/like_controller.dart';
import 'package:instagramclon/controllers/profile_controller.dart';
import 'package:instagramclon/controllers/search_controller.dart';
import 'package:instagramclon/controllers/sign_in_controller.dart';
import 'package:instagramclon/controllers/sign_up_controller.dart';
import 'package:instagramclon/controllers/upload_controller.dart';
import 'package:instagramclon/controllers/user_controller.dart';

class DIService{
  static Future<void> init()async{
    Get.lazyPut<SignInController>(() => SignInController(), fenix:  true);
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix:  true);
    Get.lazyPut<FeedController>(() => FeedController(), fenix:  true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix:  true);
    Get.lazyPut<LikeController>(() => LikeController(), fenix:  true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix:  true);
    Get.lazyPut<SearchController>(() => SearchController(), fenix:  true);
    Get.lazyPut<UploadController>(() => UploadController(), fenix:  true);
    Get.lazyPut<UserController>(() => UserController(), fenix:  true);
  }
}