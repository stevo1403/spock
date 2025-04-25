import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/wallet.dart';
import '../utils/theme.dart';

class WalletConnectButton extends StatelessWidget {
  final Wallet wallet;
  final Function(String) onConnect;
  final bool isConnecting;

  const WalletConnectButton({
    super.key,
    required this.wallet,
    required this.onConnect,
    this.isConnecting = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: isConnecting ? null : () => onConnect(wallet.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: wallet.icon,
                width: 40,
                height: 40,
                placeholder: (context, url) => Container(
                  color: theme.brightness == Brightness.dark 
                      ? AppTheme.borderColor 
                      : AppTheme.lightBorderColor,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                wallet.name,
                style: theme.textTheme.titleMedium,
              ),
            ),
            isConnecting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryColor,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}