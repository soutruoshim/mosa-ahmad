class ItemCategories {
  int id=0;
  String name='', image='';

  ItemCategories({required this.id, required this.name, required this.image});

  ItemCategories.fromJson(Map<String, dynamic> json) {
    id = json['post_id'];
    name = json['post_title'];
    image = json['post_image'];
  }
}
