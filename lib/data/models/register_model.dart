import 'dart:convert';

class RegisterRequest {
  final String name;
  final String email;
  final String password;

  RegisterRequest({required this.name, required this.email, required this.password});

  factory RegisterRequest.fromJson(String str) => RegisterRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterRequest.fromMap(Map<String, dynamic> json) =>
      RegisterRequest(name: json["name"], email: json["email"], password: json["password"]);

  Map<String, dynamic> toMap() => {"name": name, "email": email, "password": password};
}

class RegisterResponse {
  final String status;
  final String message;
  final String token;
  final User user;

  RegisterResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory RegisterResponse.fromJson(String str) => RegisterResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterResponse.fromMap(Map<String, dynamic> json) => RegisterResponse(
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
  final String name;
  final String email;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  User({
    required this.name,
    required this.email,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
