import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramclon/controllers/like_controller.dart';

Widget itemOfPost(BuildContext context,index,LikeController controller) {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Divider(),
        //userinfo
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        controller.postList[index].fullName.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        controller.postList[index].date.toString(),
                      ),
                    ],
                  ),
                ],
              ),
              controller.postList[index].mine?IconButton(onPressed: () {
                controller.actionRemovePost(context,controller.postList[index]);
              }, icon: Icon(Icons.more_horiz),):SizedBox.shrink(),
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.share_outlined),
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