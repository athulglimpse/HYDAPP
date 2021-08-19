class CommentModel {
  int id;
  String comment;
  String createDateTime;
  String created;
  String username;
  bool liked;
  List<CommentModel> replied;
  int pid;
  String image;

  CommentModel({
    this.id,
    this.comment,
    this.createDateTime,
    this.created,
    this.username,
    this.liked,
    this.replied,
    this.pid,
    this.image,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    createDateTime = json['create_date_time'];
    created = json['created'];
    username = json['username'];
    liked = json['liked'];
    if (json['replied'] != null) {
      replied = <CommentModel>[];
      json['replied'].forEach((v) {
        replied.add(CommentModel.fromJson(v));
      });
    }
    pid = json['pid'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['create_date_time'] = createDateTime;
    data['created'] = created;
    data['username'] = username;
    data['liked'] = liked;
    if (replied != null) {
      data['replied'] = replied.map((v) => v.toJson()).toList();
    }
    data['pid'] = pid;
    data['image'] = image;
    return data;
  }
}
