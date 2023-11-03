class ItemLiveTV {
  String name='', description='', type='', url = '';

  ItemLiveTV.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    type = json['type'];
    url = json['url'];
  }
}