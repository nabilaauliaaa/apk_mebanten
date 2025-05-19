// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  String? photoUrl;
  
  UserModel({
    required this.uid, 
    required this.name, 
    required this.email, 
    this.photoUrl,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }
}