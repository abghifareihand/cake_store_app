import 'package:cake_store_app/core/components/custom_button.dart';
import 'package:cake_store_app/core/components/custom_text_field.dart';
import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/core/utils/formatter_helper.dart';
import 'package:cake_store_app/data/models/cart_model.dart';
import 'package:cake_store_app/data/models/order_model.dart';
import 'package:cake_store_app/presentation/bloc/order/order_bloc.dart';
import 'package:cake_store_app/presentation/pages/checkout/checkout_payment_page.dart';
import 'package:cake_store_app/presentation/widgets/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutDetailPage extends StatefulWidget {
  final List<CartData> cartItems;
  final int totalPrice;
  final int totalQty;

  const CheckoutDetailPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.totalQty,
  });

  @override
  State<CheckoutDetailPage> createState() => _CheckoutDetailPageState();
}

class _CheckoutDetailPageState extends State<CheckoutDetailPage> {
  final _addressController = TextEditingController();
  final ValueNotifier<String> _selectedBank = ValueNotifier<String>('bca');
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_validateForm);
    _selectedBank.addListener(_validateForm);
  }

  void _validateForm() {
    _isButtonEnabled.value = _addressController.text.isNotEmpty && _selectedBank.value.isNotEmpty;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _selectedBank.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Checkout Detail')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.cartItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
            itemBuilder: (context, index) {
              final item = widget.cartItems[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.stroke),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product.name, style: const TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${FormatterHelper.formatRupiah(item.product.price)} x ${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          FormatterHelper.formatRupiah(item.product.price * item.quantity),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32.0),
          CustomTextField(
            controller: _addressController,
            label: 'Alamat Pengiriman',
            textInputAction: TextInputAction.done,
            maxLines: 4,
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              const Text(
                'Metode Pembayaran',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              InkWell(
                onTap: _showBankSelection,
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ValueListenableBuilder<String>(
            valueListenable: _selectedBank,
            builder: (context, selectedBank, child) {
              final selectedBankData = payments.firstWhere(
                (bank) => bank.code == selectedBank,
                orElse: () => payments.first,
              );
              return PaymentTile(isActive: true, data: selectedBankData);
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total Price'),
                  Text(
                    FormatterHelper.formatRupiah(widget.totalPrice),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40.0),
            BlocConsumer<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderLoaded) {
                  final order = state.orderResponse.data;
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.orderResponse.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }

                if (state is OrderError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is OrderLoading;
                return ValueListenableBuilder<bool>(
                  valueListenable: _isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return Expanded(
                      child: CustomButton.filled(
                        onPressed:
                            isLoading || !isEnabled
                                ? null
                                : () {
                                  final order = OrderRequest(
                                    address: _addressController.text,
                                    bankName: _selectedBank.value,
                                    items:
                                        widget.cartItems.map((item) {
                                          return OrderItem(
                                            productId: item.product.id,
                                            quantity: item.quantity,
                                          );
                                        }).toList(),
                                  );
                                  context.read<OrderBloc>().add(CheckoutOrder(orderRequest: order));
                                },
                        label: 'Payment (${widget.totalQty})',
                        height: 46,
                        fontSize: 14,
                        isLoading: isLoading,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBankSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                child: ColoredBox(
                  color: AppColors.light,
                  child: SizedBox(height: 8.0, width: 48.0),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.light,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.separated(
                  itemCount: payments.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final bank = payments[index];
                    return PaymentCard(
                      isActive: _selectedBank.value == bank.code,
                      data: bank,
                      onTap: () {
                        _selectedBank.value = bank.code;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
