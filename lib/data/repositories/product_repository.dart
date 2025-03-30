import 'dart:convert';

import 'package:cake_store_app/core/constants/app_constants.dart';
import 'package:cake_store_app/core/utils/logger_helper.dart';
import 'package:cake_store_app/data/models/product_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  // Get Product
  Future<Either<String, ProductResponse>> getProduct() async {
    final headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    final url = '${AppConstants.baseUrl}/api/product';

    LoggerHelper.logInfo('Get Product Request: $url');
    LoggerHelper.logDebug('Headers: $headers');

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      LoggerHelper.logInfo('Get Product Response: ${response.statusCode}');
      LoggerHelper.logDebug('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final productResponse = ProductResponse.fromJson(response.body);
        return Right(productResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Get Product Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Get Product Exception: $e');
      return Left('Failed to connect to the server');
    }
  }
}
