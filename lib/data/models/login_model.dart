import 'dart:convert';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(String str) => LoginRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginRequest.fromMap(Map<String, dynamic> json) =>
      LoginRequest(email: json["email"], password: json["password"]);

  Map<String, dynamic> toMap() => {"email": email, "password": password};
}

class LoginResponse {
  final String status;
  final String message;
  final String token;
  final User user;

  LoginResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    message: json["message"],
    token: json["token"],
    user: User.fromMap(json["user"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "token": token,
    "user": user.toMap(),
  };
}

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
