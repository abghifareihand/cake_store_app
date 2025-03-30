import 'dart:convert';

class OrderRequest {
  final String address;
  final String bankName;
  final List<OrderItem> items;

  OrderRequest({required this.address, required this.bankName, required this.items});

  factory OrderRequest.fromJson(String str) => OrderRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderRequest.fromMap(Map<String, dynamic> json) => OrderRequest(
    address: json["address"],
    bankName: json["bank_name"],
    items: List<OrderItem>.from(json["items"].map((x) => OrderItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "address": address,
    "bank_name": bankName,
    "items": List<dynamic>.from(items.map((x) => x.toMap())),
  };
}

class OrderItem {
  final int productId;
  final int quantity;

  OrderItem({required this.productId, required this.quantity});

  factory OrderItem.fromJson(String str) => OrderItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderItem.fromMap(Map<String, dynamic> json) =>
      OrderItem(productId: json["product_id"], quantity: json["quantity"]);

  Map<String, dynamic> toMap() => {"product_id": productId, "quantity": quantity};
}

class OrderResponse {
  final String status;
  final String message;
  final OrderData data;

  OrderResponse({required this.status, required this.message, required this.data});

  factory OrderResponse.fromJson(String str) => OrderResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderResponse.fromMap(Map<String, dynamic> json) => OrderResponse(
    status: json["status"],
    message: json["message"],
    data: OrderData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {"status": status, "message": message, "data": data.toMap()};
}

class OrderData {
  final int userId;
  final String trxNumber;
  final String address;
  final String status;
  final int totalPrice;
  final String paymentMethod;
  final String bankName;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;
  final String paymentVa;

  OrderData({
    required this.userId,
    required this.trxNumber,
    required this.address,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
    required this.bankName,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.paymentVa,
  });

  factory OrderData.fromJson(String str) => OrderData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderData.fromMap(Map<String, dynamic> json) => OrderData(
    userId: json["user_id"],
    trxNumber: json["trx_number"],
    address: json["address"],
    status: json["status"],
    totalPrice: json["total_price"],
    paymentMethod: json["payment_method"],
    bankName: json["bank_name"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    paymentVa: json["payment_va"],
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "trx_number": trxNumber,
    "address": address,
    "status": status,
    "total_price": totalPrice,
    "payment_method": paymentMethod,
    "bank_name": bankName,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "payment_va": paymentVa,
  };
}

class OrderHistoryResponse {
  final String status;
  final String message;
  final List<OrderHistoryData> data;

  OrderHistoryResponse({required this.status, required this.message, required this.data});

  factory OrderHistoryResponse.fromJson(String str) =>
      OrderHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderHistoryResponse.fromMap(Map<String, dynamic> json) => OrderHistoryResponse(
    status: json["status"],
    message: json["message"],
    data: List<OrderHistoryData>.from(json["data"].map((x) => OrderHistoryData.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class OrderHistoryData {
  final int id;
  final int userId;
  final String trxNumber;
  final String address;
  final int totalPrice;
  final String status;
  final String paymentMethod;
  final String paymentVa;
  final String bankName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Item> items;

  OrderHistoryData({
    required this.id,
    required this.userId,
    required this.trxNumber,
    required this.address,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.paymentVa,
    required this.bankName,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory OrderHistoryData.fromJson(String str) => OrderHistoryData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderHistoryData.fromMap(Map<String, dynamic> json) => OrderHistoryData(
    id: json["id"],
    userId: json["user_id"],
    trxNumber: json["trx_number"],
    address: json["address"],
    totalPrice: json["total_price"],
    status: json["status"],
    paymentMethod: json["payment_method"],
    paymentVa: json["payment_va"],
    bankName: json["bank_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "trx_number": trxNumber,
    "address": address,
    "total_price": totalPrice,
    "status": status,
    "payment_method": paymentMethod,
    "payment_va": paymentVa,
    "bank_name": bankName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "items": List<dynamic>.from(items.map((x) => x.toMap())),
  };
}

class Item {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  Item({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    product: Product.fromMap(json["product"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "order_id": orderId,
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
