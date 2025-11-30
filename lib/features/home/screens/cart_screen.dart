import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Cart'),
      ),
      child: const Center(
        child: Text(
          'Cart Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
