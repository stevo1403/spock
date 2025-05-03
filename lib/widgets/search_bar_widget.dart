import 'package:flutter/material.dart';
import '../utils/theme.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Decentralized Apps',
                hintStyle: theme.brightness == Brightness.dark
                    ? AppTheme.captionStyle
                    : AppTheme.lightCaptionStyle,
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.brightness == Brightness.dark
                      ? AppTheme.subtextColor
                      : AppTheme.lightSubtextColor,
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: theme.brightness == Brightness.dark
                  ? AppTheme.bodyStyle
                  : AppTheme.lightBodyStyle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.tune,
              color: theme.brightness == Brightness.dark
                  ? AppTheme.textColor
                  : AppTheme.lightTextColor,
              size: 18,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
