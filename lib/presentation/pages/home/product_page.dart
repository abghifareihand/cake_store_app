import 'package:cake_store_app/core/components/custom_button.dart';
import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/core/constants/app_constants.dart';
import 'package:cake_store_app/core/utils/formatter_helper.dart';
import 'package:cake_store_app/data/models/cart_model.dart';
import 'package:cake_store_app/data/models/product_model.dart';
import 'package:cake_store_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:cake_store_app/presentation/pages/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatelessWidget {
  final ProductData product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Detail Product'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int totalQty = 0;
              if (state is CartLoaded) {
                totalQty = state.cartResponse.data.fold(0, (sum, item) => sum + item.quantity);
              }
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                    },
                    icon: Icon(Icons.shopping_bag_outlined),
                  ),
                  if (totalQty > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(
                          "$totalQty",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${AppConstants.baseUrl}/${product.image}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/picture.png');
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(
            FormatterHelper.formatRupiah(product.price),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(product.description),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton.filled(
          onPressed: () {
            context.read<CartBloc>().add(
              AddToCart(addToCartRequest: AddToCartRequest(productId: product.id)),
            );
          },
          label: 'Add to Cart',
        ),
      ),
    );
  }
}
