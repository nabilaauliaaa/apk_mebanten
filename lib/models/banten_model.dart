// lib/models/banten_model.dart
class BantenModel {
  String? id;
  final String name;
  final String description;
  final String userId;
  final DateTime createdAt;
  
  BantenModel({
    this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.createdAt,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory BantenModel.fromJson(String id, Map<String, dynamic> json) {
    return BantenModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}