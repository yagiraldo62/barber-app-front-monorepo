import 'dart:typed_data';
import 'package:utils/device/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatelessWidget {
  final String? imageUrl;
  final Function(XFile? image) onPickImage;

  const AvatarPicker({super.key, this.imageUrl, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AvatarPickerController(imageUrl));

    return Stack(
      children: [
        Obx(
          () => CircleAvatar(
            radius: 50,
            backgroundImage: controller.source.value,
          ),
        ),
        Positioned(
          bottom: -10,
          left: 60,
          child: IconButton(
            onPressed: () => controller.selectImage(onPickImage),
            icon: Icon(
              Icons.add_a_photo,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ],
    );
  }
}

class AvatarPickerController extends GetxController {
  final String? initialUrl;
  AvatarPickerController(this.initialUrl);

  final Rx<Uint8List?> _image = Rx<Uint8List?>(null);
  final Rx<ImageProvider?> source = Rx<ImageProvider?>(null);

  @override
  void onInit() {
    source.value = getSource(null);
    super.onInit();
  }

  ImageProvider getSource(Uint8List? image) {
    if (image != null) {
      return MemoryImage(image);
    }
    return NetworkImage(
      initialUrl ??
          "https://bysperfeccionoral.com/wp-content/uploads/2020/01/136-1366211_group-of-10-guys-login-user-icon-png.jpg",
    );
  }

  void selectImage(Function(XFile?) onPickImage) async {
    XFile? file = await pickImage(ImageSource.gallery);
    Uint8List? image = file != null ? await file.readAsBytes() : null;

    _image.value = image;
    source.value = getSource(image);
    onPickImage(file);
  }
}
