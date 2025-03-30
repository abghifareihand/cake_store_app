import 'dart:convert';

import 'package:cake_store_app/core/constants/app_constants.dart';
import 'package:cake_store_app/core/utils/logger_helper.dart';
import 'package:cake_store_app/core/utils/pref_helper.dart';
import 'package:cake_store_app/data/models/cart_model.dart';
import 'package:cake_store_app/data/models/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class CartRepository {
  // Get Cart
  Future<Either<String, CartResponse>> getCart() async {
    final token = await PrefHelper.getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = '${AppConstants.baseUrl}/api/cart';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      // Log response
      LoggerHelper.logResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final cartResponse = CartResponse.fromJson(response.body);
        return Right(cartResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Get Cart Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Get Cart Exception: $e');
      return Left('Failed to connect to the server');
    }
  }

  // Add To Cart
  Future<Either<String, MessageResponse>> addToCart(AddToCartRequest addToCart) async {
    final token = await PrefHelper.getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = addToCart.toJson();
    final url = '${AppConstants.baseUrl}/api/cart';

    // Log request
    LoggerHelper.logRequest(url, headers, body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      // Log response
      LoggerHelper.logResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final cartResponse = MessageResponse.fromJson(response.body);
        return Right(cartResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Add To Cart Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Add To Cart Exception: $e');
      return Left('Failed to connect to the server');
    }
  }

  // Update Cart
  Future<Either<String, MessageResponse>> updateCart(
    int cartId,
    UpdateCartRequest updateCart,
  ) async {
    final token = await PrefHelper.getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = updateCart.toJson();
    final url = '${AppConstants.baseUrl}/api/cart/$cartId';

    // Log request
    LoggerHelper.logRequest(url, headers, body);

    try {
      final response = await http.put(Uri.parse(url), headers: headers, body: body);

      // Log response
      LoggerHelper.logResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final cartResponse = MessageResponse.fromJson(response.body);
        return Right(cartResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Update Cart Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Update Cart Exception: $e');
      return Left('Failed to connect to the server');
    }
  }

  // Delete Cart
  Future<Either<String, MessageResponse>> removeCart(int cartId) async {
    final token = await PrefHelper.getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = '${AppConstants.baseUrl}/api/cart/$cartId';

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);

      // Log response
      LoggerHelper.logResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final cartResponse = MessageResponse.fromJson(response.body);
        return Right(cartResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Delete Cart Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Delete Cart Exception: $e');
      return Left('Failed to connect to the server');
    }
  }
}
