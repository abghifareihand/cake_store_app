import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:cake_store_app/presentation/bloc/order_history/order_history_bloc.dart';
import 'package:cake_store_app/presentation/bloc/product/product_bloc.dart';
import 'package:cake_store_app/presentation/bloc/user/user_bloc.dart';
import 'package:cake_store_app/presentation/pages/history/history_page.dart';
import 'package:cake_store_app/presentation/pages/home/home_page.dart';
import 'package:cake_store_app/presentation/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainPage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(GetProduct());
    context.read<OrderHistoryBloc>().add(GetOrderHistory());
    context.read<CartBloc>().add(GetCart());
    context.read<UserBloc>().add(GetUser());
    super.initState();
  }

  int _selectedIndex = 0;
  final List<Widget> _pages = [const HomePage(), const HistoryPage(), const ProfilePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 30.0,
              blurStyle: BlurStyle.outer,
              spreadRadius: 0,
              color: AppColors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              iconPath: 'assets/icons/home.svg',
              label: 'Home',
              isActive: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            NavItem(
              iconPath: 'assets/icons/ticket.svg',
              label: 'History',
              isActive: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            NavItem(
              iconPath: 'assets/icons/setting.svg',
              label: 'Setting',
              isActive: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.primary : AppColors.navInActive,
                BlendMode.srcIn,
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primary : AppColors.navInActive,
            ),
          ),
        ],
      ),
    );
  }
}
