import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/wallet.dart';
import '../utils/theme.dart';

class WalletCard extends StatelessWidget {
  final Wallet wallet;
  final VoidCallback onDisconnect;

  const WalletCard({
    super.key,
    required this.wallet,
    required this.onDisconnect,
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: wallet.address));
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openExplorer() async {
    final url = 'https://etherscan.io/address/${wallet.address}';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: wallet.icon,
                      width: 24,
                      height: 24,
                      placeholder: (context, url) => Container(
                        color: theme.brightness == Brightness.dark 
                            ? AppTheme.borderColor 
                            : AppTheme.lightBorderColor,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    wallet.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              TextButton(
                onPressed: onDisconnect,
                style: TextButton.styleFrom(
                  backgroundColor: AppTheme.errorColor.withOpacity(0.1),
                  foregroundColor: AppTheme.errorColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Disconnect',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Address
          Text(
            'Address',
            style: theme.brightness == Brightness.dark 
                ? AppTheme.captionStyle 
                : AppTheme.lightCaptionStyle,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  wallet.shortAddress,
                  style: theme.brightness == Brightness.dark 
                      ? AppTheme.bodyStyle 
                      : AppTheme.lightBodyStyle,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.copy,
                  size: 16,
                  color: theme.brightness == Brightness.dark 
                      ? AppTheme.subtextColor 
                      : AppTheme.lightSubtextColor,
                ),
                onPressed: () => _copyToClipboard(context),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              IconButton(
                icon: Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: theme.brightness == Brightness.dark 
                      ? AppTheme.subtextColor 
                      : AppTheme.lightSubtextColor,
                ),
                onPressed: _openExplorer,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Balance
          Text(
            'Balance',
            style: theme.brightness == Brightness.dark 
                ? AppTheme.captionStyle 
                : AppTheme.lightCaptionStyle,
          ),
          const SizedBox(height: 4),
          Text(
            wallet.balance,
            style: theme.textTheme.headlineSmall,
          ),
          
          const SizedBox(height: 12),
          
          // Network
          Text(
            'Network',
            style: theme.brightness == Brightness.dark 
                ? AppTheme.captionStyle 
                : AppTheme.lightCaptionStyle,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                wallet.network,
                style: theme.brightness == Brightness.dark 
                    ? AppTheme.bodyStyle 
                    : AppTheme.lightBodyStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}