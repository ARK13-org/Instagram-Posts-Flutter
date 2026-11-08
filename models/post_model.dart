class Posts {
  final int? id;
  final String? caption;
  final String? imageUrl;
  final User? user;

  Posts({this.id, this.caption, this.imageUrl, this.user});

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      id: json["id"],
      caption: json["caption"],
      imageUrl: json["image_url"],
      user: User.fromJson(json["user"]),
    );
  }
}

class User {
  String? username;

  User({this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json['username']);
  }
}
