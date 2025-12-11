import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, dynamic>> _cards = [
    {
      'type': 'Visa',
      'number': '**** **** **** 4532',
      'holder': 'John Doe',
      'expiry': '12/25',
      'isDefault': true,
    },
    {
      'type': 'Mastercard',
      'number': '**** **** **** 8765',
      'holder': 'John Doe',
      'expiry': '08/26',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cards.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                return _buildCardItem(_cards[index], index);
              },
            ),
          ),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildCardItem(Map<String, dynamic> card, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: card['isDefault']
            ? const LinearGradient(
          colors: [AppColors.primaryPurple, AppColors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : LinearGradient(
          colors: [
            AppColors.textSecondary.withOpacity(0.8),
            AppColors.textSecondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card['type'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              PopupMenuButton(
                icon: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  color: AppColors.white,
                  size: 20,
                ),
                itemBuilder: (context) => [
                  if (!card['isDefault'])
                    const PopupMenuItem(
                      value: 'default',
                      child: Text('Set as default'),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Remove card'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    setState(() {
                      _cards.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Card removed')),
                    );
                  } else if (value == 'default') {
                    setState(() {
                      for (var c in _cards) {
                        c['isDefault'] = false;
                      }
                      card['isDefault'] = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Default card updated')),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            card['number'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Holder',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card['holder'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Expires',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card['expiry'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (card['isDefault']) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Default',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.creditcard,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No payment methods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your payment cards',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add payment method - Coming soon')),
          );
        },
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryPurple, AppColors.lightBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.plus,
                  color: AppColors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Add Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
