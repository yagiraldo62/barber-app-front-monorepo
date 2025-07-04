import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);

  print({file?.path});
  if (file != null) {
    return file;
  }

  print("No image selected");

  return null;
}
