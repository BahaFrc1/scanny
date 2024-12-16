class User {
  final String id;
  final String displayName;
  final String email;
  final String? photoURL;

  User({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      displayName: json['name'],
      email: json['email'],
      photoURL: json['photoUrl'],
    );
  }
}
