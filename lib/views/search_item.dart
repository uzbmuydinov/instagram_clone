
import 'package:flutter/material.dart';
import 'package:instagramclon/controllers/search_controller.dart';
import 'package:instagramclon/models/user_model.dart';
import 'package:instagramclon/pages/user_page.dart';

///Search item
Widget searchItem(BuildContext context,User user,SearchController controller) {
  return GestureDetector(
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return UserPage(uid: user.uid,);
      }));
    },
    child: ListTile(
      leading: Container(
        height: 53,
        width: 53,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.purple, width: 2)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: const Image(
            image: AssetImage("assets/images/img.png"),
            height: 50,
            width: 50,
          ),
        ),
      ),
      title: Text(user.fullName),
      subtitle: Text(user.email),
      trailing: MaterialButton(
        onPressed: () {
          if(user.followed){
            controller.apiUnFollowUser(user);
          }else{
            controller.apiFollowUser(user);
            controller.notification(user);
          }
        },
        child:  user.followed ? Text("Following") : Text("Follow"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.grey.withOpacity(0.2),
        elevation: 0,
      ),
    ),
  );
}