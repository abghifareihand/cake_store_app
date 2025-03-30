import 'package:cake_store_app/core/components/custom_search_input.dart';
import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:cake_store_app/core/constants/app_constants.dart';
import 'package:cake_store_app/core/utils/formatter_helper.dart';
import 'package:cake_store_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:cake_store_app/presentation/bloc/product/product_bloc.dart';
import 'package:cake_store_app/presentation/pages/cart/cart_page.dart';
import 'package:cake_store_app/presentation/pages/home/product_page.dart';
import 'package:cake_store_app/presentation/widgets/banner_slider.dart';
import 'package:cake_store_app/presentation/widgets/product_shimmer.dart';
import 'package:cake_store_app/presentation/widgets/tile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Cake Store', style: TextStyle(color: AppColors.primary, fontSize: 18)),
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
                    icon: Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductBloc>().add(GetProduct());
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomSearchInput(controller: TextEditingController(), onTap: () {}),
            ),
            BannerSlider(
              items: [
                'assets/images/banner_1.png',
                'assets/images/banner_2.png',
                'assets/images/banner_3.png',
              ],
            ),
            const SizedBox(height: 20.0),
            TitleContent(title: 'Top Product', onSeeAllTap: () {}),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return ProductShimmer();
                }

                if (state is ProductLoaded) {
                  final listProduct = state.productResponse.data;
                  if (listProduct.isEmpty) {
                    return const Center(
                      child: Text('Produk tidak tersedia', style: TextStyle(fontSize: 16)),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listProduct.length,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 200,
                    ),
                    itemBuilder: (context, index) {
                      final product = listProduct[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductPage(product: product)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 7.0,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  '${AppConstants.baseUrl}/${product.image}',
                                  height: 125,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/picture.png',
                                      height: 125,
                                      width: double.infinity,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                FormatterHelper.formatRupiah(product.price),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                if (state is ProductError) {
                  return Center(child: Text(state.message, style: TextStyle(fontSize: 16)));
                }
                return SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
