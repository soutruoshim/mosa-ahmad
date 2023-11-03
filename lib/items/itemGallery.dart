import 'package:image_picker/image_picker.dart';

class ItemGallery {
  int id = 0;
  String image = '';
  XFile? imageFile;

  ItemGallery({required this.id, required this.image, required this.imageFile});

  ItemGallery.fromJson(Map<String, dynamic> json) {
    id = json['gallery_img_id'];
    image = json['gallery_image'];
  }
}
