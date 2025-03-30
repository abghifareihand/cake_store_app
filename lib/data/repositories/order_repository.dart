import 'dart:convert';

import 'package:cake_store_app/core/constants/app_constants.dart';
import 'package:cake_store_app/core/utils/logger_helper.dart';
import 'package:cake_store_app/core/utils/pref_helper.dart';
import 'package:cake_store_app/data/models/order_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  // Order
  Future<Either<String, OrderResponse>> checkoutOrder(OrderRequest order) async {
    final token = await PrefHelper.getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = order.toJson();
    final url = '${AppConstants.baseUrl}/api/order';

    // Log request
    LoggerHelper.logRequest(url, headers, body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      // Log response
      LoggerHelper.logResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final cartResponse = OrderResponse.fromJson(response.body);
        return Right(cartResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Order Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Order Exception: $e');
      return Left('Failed to connect to the server');
    }
  }

  // Check status order
  Future<Either<String, String>> checkOrderStatus(int orderId) async {
    final token = await PrefHelper.getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = '${AppConstants.baseUrl}/api/order-status/$orderId';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      // Log response
      LoggerHelper.logResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final successMessage = jsonDecode(response.body)['status'];
        return Right(successMessage);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Order Status Exception: $e');
      return Left('Failed to connect to the server');
    }
  }

  // Get order history
  Future<Either<String, OrderHistoryResponse>> getOrderHistory() async {
    final token = await PrefHelper.getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = '${AppConstants.baseUrl}/api/order';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      // Log response
      LoggerHelper.logResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final orderHistoryResponse = OrderHistoryResponse.fromJson(response.body);
        return Right(orderHistoryResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Get Order History Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Get Order History Exception: $e');
      return Left('Failed to connect to the server');
    }
  }
}
