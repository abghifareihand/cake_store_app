import 'package:cake_store_app/core/components/custom_button.dart';
import 'package:cake_store_app/presentation/bloc/logout/logout_bloc.dart';
import 'package:cake_store_app/presentation/bloc/user/user_bloc.dart';
import 'package:cake_store_app/presentation/pages/auth/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            final user = state.userResponse.user;
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                const SizedBox(height: 40.0),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                ProfileTile(label: 'Nama', title: user.name),
                ProfileTile(label: 'Email', title: user.email),
                const SizedBox(height: 20.0),
                BlocConsumer<LogoutBloc, LogoutState>(
                  listener: (context, state) {
                    if (state is LogoutLoaded) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SplashPage()),
                        (route) => false,
                      );
                    }
                    if (state is LogoutError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is LogoutLoading;
                    return CustomButton.filled(
                      onPressed: () {
                        context.read<LogoutBloc>().add(DoLogout());
                      },
                      label: 'Logout',
                      isLoading: isLoading,
                    );
                  },
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String label;
  final String title;
  const ProfileTile({super.key, required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xffFAFAFA),
          ),
          child: Text(title, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
