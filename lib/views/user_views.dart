import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramclon/controllers/user_controller.dart';

SizedBox userBody(BuildContext context,UserController controller) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        Stack(
          children: [
            GestureDetector(
              onTap: () {
              },
              child: Badge(
                showBadge: false,
                position:
                const BadgePosition(bottom: -5, end: 2),
                child: Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: !controller.isLoading
                              ? Colors.purple
                              : Colors.white,
                          width: 2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: controller.user?.imageUrl == null ||
                        controller.user!.imageUrl!.isEmpty
                        ? const Image(
                      image: AssetImage(
                          "assets/images/img.png"),
                      height: 50,
                      width: 50,
                    )
                        : Image(
                      image:
                      NetworkImage(controller.user!.imageUrl!),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            controller.isLoading
                ? const SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.purple),
            )
                : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          controller.user!.fullName.toUpperCase(),
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          controller.user!.email,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black54),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            ///posts
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      controller.postList.length.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      "POSTS",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
              height: 25,
            ),

            ///followers
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      controller.user!.followersCount.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      "FOLLOWERS",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
              height: 25,
            ),

            ///following
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      controller.user!.followingCount.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      "FOLLOWING",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: GridView.builder(
              itemCount: controller.postList.length,
              itemBuilder: (context, index) {
                return horizScrollItem(context, index,controller);
              },
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            ),
          ),
        ),
      ],
    ),
  );
}

GestureDetector horizScrollItem(BuildContext context, int index,UserController controller) {
  return GestureDetector(
    onLongPress: (){
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 5, vertical: 5),
      alignment: Alignment.topRight,
      child: CachedNetworkImage(
        width:
        MediaQuery.of(context).size.width,
        height:
        MediaQuery.of(context).size.width,
        imageUrl: controller.postList[index].img_post,
        placeholder: (context, url) =>
        const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) =>
        const Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    ),
  );
}