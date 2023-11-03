class ItemComments {
  int id = 0;
  String comment = '', date = '', userName = '', userImage = '';

  ItemComments(
      this.id, this.comment, this.date, this.userName, this.userImage) {}

  ItemComments.fromJson(Map<String, dynamic> json) {
    id = json['comment_id'];
    comment = json['comment_text'];
    date = json['comment_date'];
    userName = json['user_name'];
    userImage = json['user_image'];
  }
}
