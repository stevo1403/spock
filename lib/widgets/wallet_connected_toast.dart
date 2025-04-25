import 'package:flutter/material.dart';

import '../models/wallet.dart';
import '../utils/theme.dart';

class WalletConnectedToast extends StatelessWidget {
  final Wallet wallet;
  final VoidCallback onClose;

  const WalletConnectedToast({
    super.key,
    required this.wallet,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppTheme.accentColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet Connected',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.brightness == Brightness.dark 
                        ? AppTheme.textColor 
                        : AppTheme.lightTextColor,
                  ),
                ),
                Text(
                  '${wallet.name} has been successfully connected',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.brightness == Brightness.dark 
                        ? AppTheme.subtextColor 
                        : AppTheme.lightSubtextColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: theme.brightness == Brightness.dark 
                  ? AppTheme.subtextColor 
                  : AppTheme.lightSubtextColor,
              size: 20,
            ),
            onPressed: onClose,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}