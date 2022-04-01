import 'package:flutter/material.dart';
import 'package:instagramclon/pages/user_page.dart';
import 'package:instagramclon/services/http_service.dart';

import '../models/user_model.dart';
import '../services/data_service.dart';
import '../services/hive_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<User> user = [];
  bool isLoading = false;

  void _apiSearchUsers(String keyword) {
    setState(() {
      isLoading = true;
    });
    DataService.searchUsers(keyword).then((users) => _resSearchUser(users));
  }

  void _resSearchUser(List<User> users) {
    setState(() {
      isLoading = false;
      user = users;
    });
  }

  void _apiFollowUser(User someone)async{
    setState(() {
      isLoading = true;
    });

    await DataService.followUser(someone);
    setState(() {
      someone.followed = true;
      isLoading = false;
    });

    DataService.storePostsToMyFeed(someone);
  }

  void _apiUnFollowUser(User someone)async{
    setState(() {
      isLoading = true;
    });

    await DataService.unFollowUser(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });

    DataService.removePostsFromMyFeed(someone);
  }

  void _notification(User user)async{
    String token = await HiveDB.loadFCM();
    Network.POST(Network.API_CREATE, Network.paramsCreate(token,user.fullName)).then((value) => {

    });
  }

  @override
  void initState() {
    super.initState();
    _apiSearchUsers("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Search",
          style: TextStyle(
              fontFamily: "Billabong", fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ///Search
          Container(
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (keyword){
                _apiSearchUsers(keyword);
              },
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          isLoading?LinearProgressIndicator():SizedBox.shrink(),
          ///ListView
          Expanded(
            child: ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                return searchItem(user[index]);
              },
            ),
          ),
        ],
      ),
    );
  }


  ///Search item
  Widget searchItem(User user) {
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
              _apiUnFollowUser(user);
            }else{
              _apiFollowUser(user);
              _notification(user);
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
}
