import 'dart:developer';
import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/core/utils/pref_helper.dart';
import 'package:cake_store_app/presentation/pages/auth/login_page.dart';
import 'package:cake_store_app/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _checkAuthentication();
    super.initState();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLogin = await PrefHelper.isLogin();
    final token = await PrefHelper.getToken();

    if (mounted) {
      if (isLogin) {
        log('TOKEN: $token');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
      } else {
        log('TOKEN: $token');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 20.0),
            Text(
              'Cake Store App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
