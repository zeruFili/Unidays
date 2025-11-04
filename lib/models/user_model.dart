class UserModel {
  final String id;
  final String name;
  final String email;
  final String university;
  final int loyaltyPoints;
  final DateTime joinDate;
  final List<String> savedOffers;
  final bool isBrand;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.loyaltyPoints,
    required this.joinDate,
    required this.savedOffers,
    required this.isBrand,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      university: json['university'] as String,
      loyaltyPoints: json['loyaltyPoints'] as int,
      joinDate: DateTime.parse(json['joinDate'] as String),
      savedOffers: List<String>.from(json['savedOffers'] as List),
      isBrand: json['isBrand'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'university': university,
      'loyaltyPoints': loyaltyPoints,
      'joinDate': joinDate.toIso8601String(),
      'savedOffers': savedOffers,
      'isBrand': isBrand,
    };
  }
}
