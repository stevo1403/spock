import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/message_provider.dart';
import '../utils/theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final hasUnreadMessages = context.watch<MessageProvider>().hasUnreadMessages;
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: theme.brightness == Brightness.dark 
                  ? AppTheme.textColor 
                  : AppTheme.lightTextColor,
            ),
            onPressed: () {},
          ),
          
          Row(
            children: [
              Text(
                'MYWALLET',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: theme.brightness == Brightness.dark 
                    ? AppTheme.textColor 
                    : AppTheme.lightTextColor,
              ),
            ],
          ),
          
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: theme.brightness == Brightness.dark 
                          ? AppTheme.textColor 
                          : AppTheme.lightTextColor,
                    ),
                    onPressed: () {},
                  ),
                  if (hasUnreadMessages)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.notificationColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.fullscreen,
                  color: theme.brightness == Brightness.dark 
                      ? AppTheme.textColor 
                      : AppTheme.lightTextColor,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}