import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramclon/models/post_model.dart';
import 'package:instagramclon/models/user_model.dart';
import 'package:instagramclon/services/hive_service.dart';
import 'package:instagramclon/services/utils.dart';


class DataService{
  //instance
  static final instance = FirebaseFirestore.instance;

  //folder
  static const String userFolder = "users";
  static const String postFolder = "posts";
  static const String feedFolder = "feeds";
  static const String followingFolder = "following";
  static const String followerFolder = "followers";

  //user
  static Future<void> storeUser(User user) async {
    user.uid = HiveDB.loadIdUser();
    Map<String,String> params = await Utils.deviceParams();

    if (kDebugMode) {
      print(params.toString());
    }

    user.device_id = params["device_id"]!;
    user.device_type = params["device_type"]!;
    user.device_token = params["device_token"]!;

    return instance.collection(userFolder).doc(user.uid).set(user.toJson());
  }

  static Future<User> loadUser()async{
    String uid = HiveDB.loadIdUser();
    var value = await instance.collection(userFolder).doc(uid).get();
    User user = User.fromJson(value.data()!);

    var querySnapshot1 = await instance.collection(userFolder).doc(uid).collection(followerFolder).get();
    user.followersCount = querySnapshot1.docs.length;

    var querySnapshot2 = await instance.collection(userFolder).doc(uid).collection(followingFolder).get();
    user.followingCount = querySnapshot2.docs.length;

    return user;
  }

  static Future<User> loadPostUser(String uid)async{
    var value = await instance.collection(userFolder).doc(uid).get();
    User user = User.fromJson(value.data()!);

    var querySnapshot1 = await instance.collection(userFolder).doc(uid).collection(followerFolder).get();
    user.followersCount = querySnapshot1.docs.length;

    var querySnapshot2 = await instance.collection(userFolder).doc(uid).collection(followingFolder).get();
    user.followingCount = querySnapshot2.docs.length;

    return user;
  }

  static Future<void> updateUser(User user)async{
    String uid = HiveDB.loadIdUser();
    return instance.collection(userFolder).doc(uid).update(user.toJson());
  }

  static Future<List<User>> searchUsers(String keyword)async{
    List<User> users = [];
    String uid = HiveDB.loadIdUser();
    //write request
    var querySnapshot = await instance.collection(userFolder).orderBy("fullName").startAt([keyword]).endAt([keyword + '\uf8ff']).get();
    if (kDebugMode) {
      print(querySnapshot.docs.toString());
    }

    for (var element in querySnapshot.docs) {
      User newUser = User.fromJson(element.data());
      if(newUser.uid != uid){
        users.add(newUser);
      }
    }
    List<User> following = [];

    var querySnapshot2 = await instance.collection(userFolder).doc(uid).collection(followingFolder).get();
    for (var element in querySnapshot2.docs) {
      following.add(User.fromJson(element.data()));
    }

    for(User user in users){
      if(following.contains(user)){
        user.followed = true;
      }else{
        user.followed = false;
      }
    }

    return users;
  }

  static Future<Post> storePost(Post post) async{
    User me = await loadUser();
    post.uid=me.uid;
    post.fullName = me.fullName;
    post.img_user = me.imageUrl;
    post.date = DateTime.now().toString().substring(0,16);

    String postId = instance.collection(userFolder).doc(me.uid).collection(postFolder).doc().id;
    post.id = postId;
    
    await instance.collection(userFolder).doc(me.uid).collection(postFolder).doc(postId).set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async{
    String uid = HiveDB.loadIdUser();

    await instance.collection(userFolder).doc(uid).collection(feedFolder).doc(post.id).set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadFeeds()async{
    List<Post> list = [];
    String uid = HiveDB.loadIdUser();
    var querySnapshot = await instance.collection(userFolder).doc(uid).collection(feedFolder).get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      if(post.uid==uid) post.mine = true;
      list.add(post);
    }
  return list;
  }

  static Future<List<Post>> loadPosts()async{
    List<Post> list = [];
    String uid = HiveDB.loadIdUser();
    var querySnapshot = await instance.collection(userFolder).doc(uid).collection(postFolder).get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      list.add(post);
    }
    return list;
  }

  static Future<List<Post>> loadUserPosts(String uid)async{
    List<Post> list = [];
    var querySnapshot = await instance.collection(userFolder).doc(uid).collection(postFolder).get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      list.add(post);
    }
    return list;
  }

  static Future<Post> likePost(Post post, bool like)async{
    String uid = HiveDB.loadIdUser();
    post.liked = like;

    await instance.collection(userFolder).doc(uid).collection(feedFolder).doc(post.id).update(post.toJson());

    if(uid == post.uid){
      await instance.collection(userFolder).doc(uid).collection(postFolder).doc(post.id).update(post.toJson());
    }

    return post;
  }

  static Future<List<Post>> loadLikes()async{
    String uid = HiveDB.loadIdUser();
    List<Post> posts = [];

    var querySnapshot = await instance.collection(userFolder).doc(uid).collection(feedFolder).where("liked" , isEqualTo: true).get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      if(uid == post.uid) post.mine = true;
      posts.add(post);
    }

    return posts;
  }

  // Follower and Following Related

  static Future<User> followUser(User someone)async{
    User me = await loadUser();

    // I followed to someone
    await instance.collection(userFolder).doc(me.uid).collection(followingFolder).doc(someone.uid).set(someone.toJson());

    // I am in someone's followers
    await instance.collection(userFolder).doc(someone.uid).collection(followerFolder).doc(me.uid).set(me.toJson());

    return someone;
  }

  static Future<User> unFollowUser(User someone)async{
    User me = await loadUser();

    // I followed to someone
    await instance.collection(userFolder).doc(me.uid).collection(followingFolder).doc(someone.uid).delete();

    // I am in someone's followers
    await instance.collection(userFolder).doc(someone.uid).collection(followerFolder).doc(me.uid).delete();

    return someone;
  }

  static Future storePostsToMyFeed(User someone)async{
    List<Post> posts = [];

    var querySnapshot = await instance.collection(userFolder).doc(someone.uid).collection(postFolder).get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      post.liked = false;
      posts.add(post);
    }

    for (var element in posts) {
      storeFeed(element);
    }
  }

  static Future removePostsFromMyFeed(User someone) async {
    // Remove someone's posts from my feed
    List<Post> posts = [];

    var querySnapshot = await instance.collection(userFolder).doc(someone.uid).collection(postFolder).get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      posts.add(post);
    }

    for (var element in posts) {
      removeFeed(element);
    }
  }

  static Future removeFeed(Post post)async{
    String uid = HiveDB.loadIdUser();
    return await instance.collection(userFolder).doc(uid).collection(feedFolder).doc(post.id).delete();
  }

  static Future removePost(Post post)async{
    String uid = HiveDB.loadIdUser();
    await removeFeed(post);
    return await instance.collection(userFolder).doc(uid).collection(postFolder).doc(post.id).delete();
  }
}