import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/upload_controller.dart';

SizedBox imageUploadArea(BuildContext context,UploadController controller) {
  return SizedBox(
    height: MediaQuery.of(context).size.height,
    child: Column(
      children: [
        controller.file == null
            ? GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return bottomSheet(controller);
                });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.add_a_photo_rounded,
              size: 70,
              color: Colors.grey,
            ),
          ),
        )
            : Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: Image(
            image: FileImage(controller.file!),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: controller.captionController,
            decoration: const InputDecoration(
              hintText: "Caption",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            maxLines: 5,
            minLines: 1,
          ),
        ),
        const Divider(
          color: Colors.grey,
          endIndent: 10,
          indent: 10,
          height: 3,
          thickness: 1,
        ),
      ],
    ),
  );
}

SizedBox bottomSheet(UploadController controller) {
  return SizedBox(
    height: 120,
    child: Column(
      children: [
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.image_outlined,
                  size: 30,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Pick Photo",
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          onTap: () {
            controller.getImageOfGalary();
            Get.back();
          },
        ),
        GestureDetector(
          onTap: () {
            controller.getImageOfCamere();
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Take Photo",
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}