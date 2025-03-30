import 'dart:convert';

class ProductResponse {
  final String status;
  final String message;
  final List<ProductData> data;

  ProductResponse({required this.status, required this.message, required this.data});

  factory ProductResponse.fromJson(String str) => ProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponse.fromMap(Map<String, dynamic> json) => ProductResponse(
    status: json["status"],
    message: json["message"],
    data: List<ProductData>.from(json["data"].map((x) => ProductData.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class ProductData {
  final int id;
  final String name;
  final String description;
  final String image;
  final int price;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductData.fromJson(String str) => ProductData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductData.fromMap(Map<String, dynamic> json) => ProductData(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    price: json["price"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "price": price,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
