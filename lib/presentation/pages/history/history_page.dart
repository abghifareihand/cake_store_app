import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/core/utils/formatter_helper.dart';
import 'package:cake_store_app/presentation/bloc/order_history/order_history_bloc.dart';
import 'package:cake_store_app/presentation/pages/checkout/checkout_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'History Order',
          style: TextStyle(color: AppColors.primary, fontSize: 18),
        ),
      ),
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
          if (state is OrderHistoryLoaded) {
            final orderHistory = state.orderHistoryResponse.data;
            if (orderHistory.isEmpty) {
              return Center(child: Text('Belum ada history order'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrderHistoryBloc>().add(GetOrderHistory());
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                itemCount: orderHistory.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final order = orderHistory[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap:
                        order.status == 'paid'
                            ? null
                            : () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CheckoutPaymentPage(
                                        orderId: order.id,
                                        bankName: order.bankName,
                                        vaNumber: order.paymentVa,
                                        totalPrice: order.totalPrice,
                                      ),
                                ),
                                (route) => false,
                              );
                            },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.primary),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.trxNumber,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    FormatterHelper.formatDate(order.createdAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      order.status == 'paid'
                                          ? Colors.green.withValues(alpha: 0.2)
                                          : order.status == 'pending'
                                          ? Colors.orange.withValues(alpha: 0.2)
                                          : Colors.red.withValues(alpha: 0.2),
                                ),
                                child: Text(
                                  order.status == 'paid'
                                      ? 'Berhasil'
                                      : order.status == 'pending'
                                      ? 'Belum dibayar'
                                      : 'Gagal',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        order.status == 'paid'
                                            ? Colors.green
                                            : order.status == 'pending'
                                            ? Colors.orange
                                            : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.withValues(alpha: 0.2),
                            margin: EdgeInsets.symmetric(vertical: 12),
                          ),
                          ...order.items.map<Widget>((item) {
                            final productPrice = item.product.price * item.quantity;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 8.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${FormatterHelper.formatRupiah(item.product.price)} x ${item.quantity}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      FormatterHelper.formatRupiah(productPrice),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            );
                          }),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pembayaran',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${order.bankName.toUpperCase()} Virtual Account',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Harga',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                FormatterHelper.formatRupiah(order.totalPrice),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          if (state is OrderHistoryError) {
            return Center(child: Text(state.message, style: TextStyle(fontSize: 16)));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
