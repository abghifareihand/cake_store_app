import 'dart:async';

import 'package:cake_store_app/core/components/custom_button.dart';
import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/core/utils/formatter_helper.dart';
import 'package:cake_store_app/presentation/bloc/order_status/order_status_bloc.dart';
import 'package:cake_store_app/presentation/pages/main_page.dart';
import 'package:cake_store_app/presentation/widgets/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final int orderId;
  final String bankName;
  final String vaNumber;
  final int totalPrice;
  const CheckoutPaymentPage({
    super.key,
    required this.orderId,
    required this.bankName,
    required this.vaNumber,
    required this.totalPrice,
  });

  @override
  State<CheckoutPaymentPage> createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      context.read<OrderStatusBloc>().add(CheckOrderStatus(orderId: widget.orderId));
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bankData = payments.firstWhere(
      (bank) => bank.code == widget.bankName,
      orElse: () => payments.first, // Default jika tidak ditemukan
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Waiting for payment'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
              (route) => false,
            );
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: BlocListener<OrderStatusBloc, OrderStatusState>(
        listener: (context, state) {
          if (state is OrderStatusLoaded) {
            if (state.status == 'paid') {
              _timer?.cancel();
              showSuccessDialog();
            }
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.bankName.toUpperCase()} Virtual Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SvgPicture.asset(bankData.image, width: 20, height: 20, fit: BoxFit.contain),
              ],
            ),
            Divider(height: 24),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Virtual Account',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      widget.vaNumber,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.vaNumber)).then((_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            duration: Duration(seconds: 1),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy, color: AppColors.primary, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Copy',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Total Pembayaran',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                FormatterHelper.formatRupiah(widget.totalPrice),
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: AppColors.primary, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Pembayaran Berhasil',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomButton.filled(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (route) => false,
                    );
                  },
                  label: 'Back to Home',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
