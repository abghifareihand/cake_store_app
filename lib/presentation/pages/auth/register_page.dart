import 'package:cake_store_app/core/components/custom_button.dart';
import 'package:cake_store_app/core/components/custom_text_field.dart';
import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/data/models/register_model.dart';
import 'package:cake_store_app/presentation/bloc/register/register_bloc.dart';
import 'package:cake_store_app/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    _isButtonEnabled.value =
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                  'Register',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
                ),
                Text(
                  'Register sekarang dan nikmati berbagai pilihan kue lezat dari toko kami',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                ),
              ],
            ),
          ),
          CustomTextField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            label: 'Nama',
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16.0),
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
          BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterLoaded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              }
              if (state is RegisterError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
              }
            },
            builder: (context, state) {
              final isLoading = state is RegisterLoading;
              return ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return CustomButton.filled(
                    onPressed:
                        isLoading || !isEnabled
                            ? null
                            : () {
                              final register = RegisterRequest(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              context.read<RegisterBloc>().add(
                                DoRegister(registerRequest: register),
                              );
                            },
                    label: 'Register',
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
                Text('Sudah punya akun? '),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
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
