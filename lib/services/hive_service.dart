import 'package:hive/hive.dart';

class HiveDB{
  static String dbName = "db_firebase";
  static var box = Hive.box(dbName);

  static storeIdUser(String id)async{
    await box.put("id", id);
  }

  static String loadIdUser(){
    String id = box.get("id");
    return id;
  }

  static Future<void> removeIdUser()async{
    await box.delete("id");
  }

  static Future saveFCM(String fcm_token)async{
    await box.put("fcm_token", fcm_token);
  }

  static Future<String> loadFCM()async{
    String fcmToken = await box.get("fcm_token");
    return fcmToken;
  }
}