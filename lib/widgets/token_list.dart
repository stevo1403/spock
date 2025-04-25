import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/token.dart';
import '../utils/theme.dart';

class TokenList extends StatelessWidget {
  final List<TokenBalance> tokenBalances;
  final bool isLoading;

  const TokenList({
    super.key,
    required this.tokenBalances,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }

    if (tokenBalances.isEmpty) {
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
              Icons.account_balance_wallet,
              size: 48,
              color: theme.brightness == Brightness.dark
                  ? AppTheme.subtextColor
                  : AppTheme.lightSubtextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No tokens found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? AppTheme.textColor
                    : AppTheme.lightTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect your wallet to view your tokens',
              textAlign: TextAlign.center, // Moved textAlign here
              style: TextStyle(
                fontSize: 14,
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
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tokenBalances.length,
        separatorBuilder: (context, index) => Divider(
          color: theme.brightness == Brightness.dark
              ? AppTheme.borderColor
              : AppTheme.lightBorderColor,
        ),
        itemBuilder: (context, index) {
          final tokenBalance = tokenBalances[index];
          final priceChange = tokenBalance.priceChange24h != null
              ? double.tryParse(
                  tokenBalance.priceChange24h!.replaceAll('%', ''))
              : 0.0;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Token Icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: tokenBalance.token.logoURI,
                    width: 36,
                    height: 36,
                    placeholder: (context, url) => Container(
                      color: theme.brightness == Brightness.dark
                          ? AppTheme.borderColor
                          : AppTheme.lightBorderColor,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 12),

                // Token Info
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tokenBalance.token.symbol,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.brightness == Brightness.dark
                              ? AppTheme.textColor
                              : AppTheme.lightTextColor,
                        ),
                      ),
                      Text(
                        tokenBalance.token.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.brightness == Brightness.dark
                              ? AppTheme.subtextColor
                              : AppTheme.lightSubtextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Balance
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        tokenBalance.balance,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.brightness == Brightness.dark
                              ? AppTheme.textColor
                              : AppTheme.lightTextColor,
                        ),
                      ),
                      Text(
                        tokenBalance.balanceUsd ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.brightness == Brightness.dark
                              ? AppTheme.subtextColor
                              : AppTheme.lightSubtextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        tokenBalance.price ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.brightness == Brightness.dark
                              ? AppTheme.textColor
                              : AppTheme.lightTextColor,
                        ),
                      ),
                      Text(
                        tokenBalance.priceChange24h ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: priceChange != null && priceChange >= 0
                              ? AppTheme.accentColor
                              : AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: theme.brightness == Brightness.dark
                      ? AppTheme.subtextColor
                      : AppTheme.lightSubtextColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
