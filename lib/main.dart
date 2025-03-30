import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/data/repositories/auth_repository.dart';
import 'package:cake_store_app/data/repositories/cart_repository.dart';
import 'package:cake_store_app/data/repositories/order_repository.dart';
import 'package:cake_store_app/data/repositories/product_repository.dart';
import 'package:cake_store_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:cake_store_app/presentation/bloc/login/login_bloc.dart';
import 'package:cake_store_app/presentation/bloc/logout/logout_bloc.dart';
import 'package:cake_store_app/presentation/bloc/order/order_bloc.dart';
import 'package:cake_store_app/presentation/bloc/order_history/order_history_bloc.dart';
import 'package:cake_store_app/presentation/bloc/order_status/order_status_bloc.dart';
import 'package:cake_store_app/presentation/bloc/product/product_bloc.dart';
import 'package:cake_store_app/presentation/bloc/register/register_bloc.dart';
import 'package:cake_store_app/presentation/bloc/user/user_bloc.dart';
import 'package:cake_store_app/presentation/pages/auth/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AUTH
        BlocProvider(create: (context) => LoginBloc(AuthRepository())),
        BlocProvider(create: (context) => RegisterBloc(AuthRepository())),
        BlocProvider(create: (context) => UserBloc(AuthRepository())),
        BlocProvider(create: (context) => LogoutBloc(AuthRepository())),

        // PRODUCT
        BlocProvider(create: (context) => ProductBloc(ProductRepository())),
        BlocProvider(create: (context) => CartBloc(CartRepository())),
        BlocProvider(create: (context) => OrderBloc(OrderRepository())),
        BlocProvider(create: (context) => OrderStatusBloc(OrderRepository())),
        BlocProvider(create: (context) => OrderHistoryBloc(OrderRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Cake Store',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          dialogTheme: const DialogTheme(elevation: 0),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleTextStyle: GoogleFonts.poppins(
              color: AppColors.primary,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(color: AppColors.primary),
            centerTitle: true,
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
