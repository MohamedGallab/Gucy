class UserData {
  String eventPermission;
  String name;
  String picture;
  int score;
  String uid;

  UserData({
    required this.eventPermission,
    required this.name,
    required this.picture,
    required this.score,
    required this.uid,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      eventPermission: json['eventPermission'] ?? 'None',
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      score: json['score'] ?? 0,
      uid: json['uid'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "eventPermission": eventPermission,
      "name": name,
      "picture": picture,
      "score": score,
      "uid": uid,
    };
  }
}
