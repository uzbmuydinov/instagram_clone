import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/search_controller.dart';
import 'package:instagramclon/views/search_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  void initState() {
    super.initState();
    Get.find<SearchController>().apiSearchUsers("");
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
      body: GetBuilder(
        init: SearchController(),
        builder: (SearchController controller) => Column(
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
                  controller.apiSearchUsers(keyword);
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

            controller.isLoading?LinearProgressIndicator():SizedBox.shrink(),
            ///ListView
            Expanded(
              child: ListView.builder(
                itemCount: controller.user.length,
                itemBuilder: (context, index) {
                  return searchItem(context,controller.user[index],controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
