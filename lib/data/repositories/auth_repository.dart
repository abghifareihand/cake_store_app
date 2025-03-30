import 'dart:convert';
import 'dart:developer';

import 'package:cake_store_app/core/constants/app_constants.dart';
import 'package:cake_store_app/core/utils/logger_helper.dart';
import 'package:cake_store_app/core/utils/pref_helper.dart';
import 'package:cake_store_app/data/models/login_model.dart';
import 'package:cake_store_app/data/models/message_model.dart';
import 'package:cake_store_app/data/models/register_model.dart';
import 'package:cake_store_app/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  // Register
  Future<Either<String, RegisterResponse>> register(RegisterRequest register) async {
    final headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    final body = register.toJson();
    final url = '${AppConstants.baseUrl}/api/register';

    LoggerHelper.logInfo('Register Request: $url');
    LoggerHelper.logDebug('Headers: $headers');
    LoggerHelper.logDebug('Body: $body');

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      LoggerHelper.logInfo('Register Response: ${response.statusCode}');
      LoggerHelper.logDebug('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final registerResponse = RegisterResponse.fromJson(response.body);
        await PrefHelper.saveToken(registerResponse.token);
        return Right(registerResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Register Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Register Exception: $e');
      return Left('Failed to connect to the server');
    }
  }

  // Login
  Future<Either<String, LoginResponse>> login(LoginRequest login) async {
    final headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    final body = login.toJson();
    final url = '${AppConstants.baseUrl}/api/login';

    LoggerHelper.logDebug('Login Request: $body');

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      LoggerHelper.logInfo('Login Status: ${response.statusCode}');
      LoggerHelper.logDebug('Login Response: ${response.body}');

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.body);
        await PrefHelper.saveToken(loginResponse.token);
        return Right(loginResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Login Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Login Exception: $e');
      return Left('Failed to connect to the server');
    }
  }

  // Get User
  Future<Either<String, UserResponse>> getUser() async {
    final token = await PrefHelper.getToken();
    log('Token User: $token');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = '${AppConstants.baseUrl}/api/user';

    LoggerHelper.logInfo('Get User Request: $url');
    LoggerHelper.logDebug('Headers: $headers');

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      LoggerHelper.logInfo('Get User Response: ${response.statusCode}');
      LoggerHelper.logDebug('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final userResponse = UserResponse.fromJson(response.body);
        return Right(userResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Get User Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Get User Exception: $e');
      return Left('Failed to connect to the server');
    }
  }

  // Logout
  Future<Either<String, MessageResponse>> logout() async {
    final token = await PrefHelper.getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = '${AppConstants.baseUrl}/api/logout';

    LoggerHelper.logInfo('Logout Request: $url');
    LoggerHelper.logDebug('Headers: $headers');

    try {
      final response = await http.post(Uri.parse(url), headers: headers);

      LoggerHelper.logInfo('Logout Response: ${response.statusCode}');
      LoggerHelper.logDebug('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final logoutResponse = MessageResponse.fromJson(response.body);
        await PrefHelper.removeAll();
        return Right(logoutResponse);
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        LoggerHelper.logError('Logout Error: $errorMessage');
        return Left(errorMessage);
      }
    } catch (e) {
      LoggerHelper.logError('Logout Exception: $e');
      return Left('Failed to connect to the server');
    }
  }
}
