import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TitleContent extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAllTap;

  const TitleContent({super.key, required this.title, required this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
          InkWell(
            onTap: onSeeAllTap,
            child: const Text(
              'See All',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
