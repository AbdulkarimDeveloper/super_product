import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePickerHelper _singleton = ImagePickerHelper._();
  static ImagePickerHelper get instance => _singleton;
  ImagePickerHelper._();

  Future<XFile?> pick({required ImageSource source}) async {
    try {
      XFile? file = await ImagePicker().pickImage(source: source);
      return file;
    } catch (e, c) {
      return null;
    }
  }

  Future<List<XFile>?> pickMultiple() async {
    try {
      List<XFile>? files = await ImagePicker().pickMultiImage();
      return files;
    } catch (e, c) {
      return null;
    }
  }
}
