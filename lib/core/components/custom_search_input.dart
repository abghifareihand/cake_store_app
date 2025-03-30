import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSearchInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final VoidCallback? onTap;

  const CustomSearchInput({super.key, required this.controller, this.onChanged, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: onTap != null,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: Color(0xffFAFAFA),
        filled: true,
        hintText: 'Cari Produk di sini',
        hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        suffixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.light),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.light),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.light),
        ),
      ),
    );
  }
}
