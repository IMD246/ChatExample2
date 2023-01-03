import 'dart:convert';

class UserProfile {
  String? id;
  final String email;
  final String fullName;
  String? urlImage;
  String? messagingToken;
  bool isEmailVerified;
  UserProfile({
    this.id,
    required this.email,
    required this.fullName,
    this.urlImage,
    this.messagingToken,
    required this.isEmailVerified,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_user': id,
      'email': email,
      'full_name': fullName,
      'url_image': urlImage,
      'user_messaging_token': messagingToken,
      'is_email_verified': isEmailVerified
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      email: map['email'],
      fullName: map['full_name'] as String,
      urlImage: map['url_image'] ?? "",
      messagingToken: map['user_messaging_token'] != null
          ? map['user_messaging_token'] as String
          : null,
      isEmailVerified: map['is_email_verified'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>, "");

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, fullName: $fullName, urlImage: $urlImage, messagingToken: $messagingToken, isEmailVerified: $isEmailVerified)';
  }
}
