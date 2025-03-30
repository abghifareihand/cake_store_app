import 'dart:convert';

class MessageResponse {
  final String status;
  final String message;

  MessageResponse({required this.status, required this.message});

  factory MessageResponse.fromJson(String str) => MessageResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MessageResponse.fromMap(Map<String, dynamic> json) =>
      MessageResponse(status: json["status"], message: json["message"]);

  Map<String, dynamic> toMap() => {"status": status, "message": message};
}
