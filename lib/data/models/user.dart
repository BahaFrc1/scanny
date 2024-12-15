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

  // Factory method for creating a User from Firebase User object
  factory User.fromFirebaseUser(dynamic firebaseUser) {
    return User(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? 'Anonymous',
      email: firebaseUser.email ?? 'No email',
      photoURL: firebaseUser.photoURL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': displayName,
      'email': email,
      'photoUrl': photoURL,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      displayName: json['name'],
      email: json['email'],
      photoURL: json['photoUrl'],
    );
  }
}
