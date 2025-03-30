import 'package:cake_store_app/core/components/custom_button.dart';
import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/core/constants/app_constants.dart';
import 'package:cake_store_app/core/utils/formatter_helper.dart';
import 'package:cake_store_app/data/models/cart_model.dart';
import 'package:cake_store_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:cake_store_app/presentation/pages/checkout/checkout_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('My Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else if (state is CartLoaded) {
            final cartItems = state.cartResponse.data;

            if (cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 48),
                    const SizedBox(height: 4.0),
                    Text(
                      'Keranjang kamu kosong',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Slidable(
                  endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(12.0),
                        onPressed: (context) {
                          context.read<CartBloc>().add(RemoveFromCart(cartId: item.id));
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete_outlined,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.stroke),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                '${AppConstants.baseUrl}/${item.product.image}',
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/picture.png',
                                    height: 60,
                                    width: 60,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontSize: 16.0)),
                                  Text(
                                    FormatterHelper.formatRupiah(item.product.price),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TileQuantity(cart: item),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded && state.cartResponse.data.isNotEmpty) {
              int totalPrice = state.cartResponse.data.fold(0, (sum, item) {
                return sum + (item.product.price * item.quantity);
              });

              int totalQty = state.cartResponse.data.fold(0, (sum, item) {
                return sum + item.quantity;
              });

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Total Price'),
                        Text(
                          FormatterHelper.formatRupiah(totalPrice),
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40.0),
                  Expanded(
                    child: CustomButton.filled(
                      borderRadius: 12,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CheckoutDetailPage(
                                  cartItems: state.cartResponse.data,
                                  totalPrice: totalPrice,
                                  totalQty: totalQty,
                                ),
                          ),
                        );
                      },
                      height: 46,
                      label: 'Checkout ($totalQty)',
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class TileQuantity extends StatelessWidget {
  final CartData cart;
  const TileQuantity({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonQuantity(
          icon: Icons.remove,
          onTap:
              cart.quantity > 1
                  ? () {
                    final updateCartRequest = UpdateCartRequest(quantity: cart.quantity - 1);
                    context.read<CartBloc>().add(
                      UpdateCart(cartId: cart.id, updateCartRequest: updateCartRequest),
                    );
                  }
                  : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('${cart.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        ButtonQuantity(
          icon: Icons.add,
          onTap: () {
            final updateCart = UpdateCartRequest(quantity: cart.quantity + 1);
            context.read<CartBloc>().add(
              UpdateCart(cartId: cart.id, updateCartRequest: updateCart),
            );
          },
        ),
      ],
    );
  }
}

class ButtonQuantity extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  const ButtonQuantity({super.key, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.primary),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
