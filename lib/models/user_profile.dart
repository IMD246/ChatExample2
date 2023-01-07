import 'package:hive/hive.dart';

part 'user_profile.g.dart';
@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  String fullName;
  @HiveField(3)
  String? messagingToken;
  @HiveField(4)
  bool isEmailVerified;
  UserProfile({
    this.id,
    required this.email,
    required this.fullName,
    this.messagingToken,
    required this.isEmailVerified,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_user': id,
      'email': email,
      'full_name': fullName,
      'user_messaging_token': messagingToken,
      'is_email_verified': isEmailVerified
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      email: map['email'],
      fullName: map['full_name'] as String,
      messagingToken: map['user_messaging_token'] != null
          ? map['user_messaging_token'] as String
          : null,
      isEmailVerified: map['is_email_verified'],
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, fullName: $fullName messagingToken: $messagingToken, isEmailVerified: $isEmailVerified)';
  }
}
