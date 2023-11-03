class ItemUser {
  int? userID;
  String? userName, userEmail, userPhone, userImage, message, success;
  bool isReporter = false;

  ItemUser({this.message, this.success});

  ItemUser.fromJson(Map<String, dynamic> json) {
    userID = json['user_id'];
    userName = json['name'];
    userEmail = json['email'];
    userPhone = json['phone'];
    userImage = json['user_image'];
    message = json['msg'];
    success = json['success'];
    isReporter = json['usertype'] == 'Reporter';
  }
}
