class ItemSuccess {
  int? commentID = 0;
  String? message, success, userImage, date;

  ItemSuccess({this.message, this.success});

  ItemSuccess.fromJson(Map<String, dynamic> json) {
    message = json['msg'];
    success = json['success'].toString();
    if (json.containsKey('user_image')) {
      userImage = json['user_image'];
    }
  }

  ItemSuccess.fromAddCommentJson(Map<String, dynamic> json) {
    message = json['msg'];
    success = json['success'].toString();
    commentID = json['comment_id'];
    date = json['post_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.message;
    data['success'] = this.success;
    return data;
  }
}
