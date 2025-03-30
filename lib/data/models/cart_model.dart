import 'dart:convert';

class CartResponse {
  final String status;
  final String message;
  final List<CartData> data;

  CartResponse({required this.status, required this.message, required this.data});

  factory CartResponse.fromJson(String str) => CartResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartResponse.fromMap(Map<String, dynamic> json) => CartResponse(
    status: json["status"],
    message: json["message"],
    data: List<CartData>.from(json["data"].map((x) => CartData.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class CartData {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  CartData({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory CartData.fromJson(String str) => CartData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartData.fromMap(Map<String, dynamic> json) => CartData(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    product: Product.fromMap(json["product"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "quantity": quantity,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product": product.toMap(),
  };
}

class Product {
  final int id;
  final String name;
  final String description;
  final String image;
  final int price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
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

class AddToCartRequest {
  final int productId;

  AddToCartRequest({required this.productId});

  factory AddToCartRequest.fromJson(String str) => AddToCartRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddToCartRequest.fromMap(Map<String, dynamic> json) =>
      AddToCartRequest(productId: json["product_id"]);

  Map<String, dynamic> toMap() => {"product_id": productId};
}

class UpdateCartRequest {
  final int quantity;

  UpdateCartRequest({required this.quantity});

  factory UpdateCartRequest.fromJson(String str) => UpdateCartRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateCartRequest.fromMap(Map<String, dynamic> json) =>
      UpdateCartRequest(quantity: json["quantity"]);

  Map<String, dynamic> toMap() => {"quantity": quantity};
}
