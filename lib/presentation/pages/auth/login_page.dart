import 'package:cake_store_app/core/components/custom_button.dart';
import 'package:cake_store_app/core/components/custom_text_field.dart';
import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/data/models/login_model.dart';
import 'package:cake_store_app/presentation/bloc/login/login_bloc.dart';
import 'package:cake_store_app/presentation/pages/auth/register_page.dart';
import 'package:cake_store_app/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    _isButtonEnabled.value =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
                ),
                Text(
                  'Login untuk menikmati berbagai pilihan kue lezat dari toko kami',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                ),
              ],
            ),
          ),
          CustomTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            label: 'Email',
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            label: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 32.0),
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginLoaded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              }

              if (state is LoginError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
              }
            },
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              return ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return CustomButton.filled(
                    onPressed:
                        isLoading || !isEnabled
                            ? null
                            : () {
                              final login = LoginRequest(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              context.read<LoginBloc>().add(DoLogin(loginRequest: login));
                            },
                    label: 'Login',
                    isLoading: isLoading,
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Belum punya akun? '),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
