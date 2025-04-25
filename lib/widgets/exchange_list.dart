import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/wallet.dart';
import '../utils/theme.dart';

class ExchangeList extends StatelessWidget {
  final List<Exchange> exchanges;

  const ExchangeList({
    super.key,
    required this.exchanges,
  });

  Future<void> _launchUrl(String url) async {
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
    
    if (exchanges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront,
              size: 48,
              color: theme.brightness == Brightness.dark 
                  ? AppTheme.subtextColor 
                  : AppTheme.lightSubtextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No exchanges found',
              style: TextStyle(
                fontSize: 16,
                color: theme.brightness == Brightness.dark 
                    ? AppTheme.subtextColor 
                    : AppTheme.lightSubtextColor,
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: exchanges.length,
        separatorBuilder: (context, index) => Divider(
          color: theme.brightness == Brightness.dark 
              ? AppTheme.borderColor 
              : AppTheme.lightBorderColor,
        ),
        itemBuilder: (context, index) {
          final exchange = exchanges[index];
          
          return InkWell(
            onTap: () => _launchUrl(exchange.url),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: exchange.icon,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exchange.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.brightness == Brightness.dark 
                                ? AppTheme.textColor 
                                : AppTheme.lightTextColor,
                          ),
                        ),
                        Text(
                          exchange.description,
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
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: theme.brightness == Brightness.dark 
                        ? AppTheme.subtextColor 
                        : AppTheme.lightSubtextColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}