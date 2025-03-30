import 'package:cake_store_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentCard extends StatelessWidget {
  final bool isActive;
  final PaymentModel data;
  final Function()? onTap;

  const PaymentCard({super.key, required this.isActive, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey.withValues(alpha: 0.5),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 48.0, height: 24.0, child: SvgPicture.asset(data.image)),
                const SizedBox(width: 16.0),
                Text(
                  data.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2.0),
              ),
              child: Icon(
                Icons.circle,
                color: isActive ? AppColors.primary : Colors.transparent,
                size: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentTile extends StatelessWidget {
  final bool isActive;
  final PaymentModel data;

  const PaymentTile({super.key, required this.data, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(
          color: isActive ? AppColors.primary : Colors.grey.withValues(alpha: 0.5),
          width: isActive ? 1.8 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 48.0,
                height: 24.0,
                child: SvgPicture.asset(data.image, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12.0),
              Text(
                data.name,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.0),
            ),
            child: Icon(
              Icons.circle,
              color: isActive ? AppColors.primary : Colors.transparent,
              size: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentModel {
  final String name;
  final String code;
  final String image;

  PaymentModel({required this.name, required this.code, required this.image});
}

List<PaymentModel> payments = [
  PaymentModel(name: "BCA Virtual Account", code: 'bca', image: "assets/icons/bank_bca.svg"),
  PaymentModel(name: "BRI Virtual Account", code: 'bri', image: "assets/icons/bank_bri.svg"),
  PaymentModel(name: "BNI Virtual Account", code: 'bni', image: "assets/icons/bank_bni.svg"),
  PaymentModel(name: "BSI Virtual Account", code: 'bsi', image: "assets/icons/bank_bsi.svg"),
];
