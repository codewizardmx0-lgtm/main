import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String firstName;
  
  @HiveField(1)
  String lastName;
  
  @HiveField(2)
  String email;
  
  @HiveField(3)
  String password;
  
  @HiveField(4)
  DateTime? createdAt;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.createdAt,
  }) {
    createdAt ??= DateTime.now();
  }

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;

  @override
  String toString() => 'User(firstName: $firstName, lastName: $lastName, email: $email)';
}