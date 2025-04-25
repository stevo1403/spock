import 'package:flutter/material.dart';

import '../models/wallet.dart';
import '../utils/theme.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final bool isLoading;
  final VoidCallback onMarkAllRead;
  final Function(String) onMarkAsRead;

  const MessageList({
    super.key,
    required this.messages,
    this.isLoading = false,
    required this.onMarkAllRead,
    required this.onMarkAsRead,
  });

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes min${minutes != 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours != 1 ? 's' : ''} ago';
    } else {
      final days = difference.inDays;
      return '$days day${days != 1 ? 's' : ''} ago';
    }
  }

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
    
    if (messages.isEmpty) {
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
              Icons.notifications_none,
              size: 48,
              color: theme.brightness == Brightness.dark 
                  ? AppTheme.subtextColor 
                  : AppTheme.lightSubtextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Messages',
                style: theme.textTheme.titleLarge,
              ),
              TextButton.icon(
                onPressed: onMarkAllRead,
                icon: const Icon(Icons.check, size: 14),
                label: const Text(
                  'Mark all as read',
                  style: TextStyle(fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Message List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: messages.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final message = messages[index];
              
              return InkWell(
                onTap: () => onMarkAsRead(message.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!message.read)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 6, right: 8),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(width: 16),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.title,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message.content,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.brightness == Brightness.dark 
                                    ? AppTheme.subtextColor 
                                    : AppTheme.lightSubtextColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTimestamp(message.timestamp),
                              style: theme.brightness == Brightness.dark 
                                  ? AppTheme.captionStyle 
                                  : AppTheme.lightCaptionStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          // Show More Button
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Text('Show more'),
              label: const Icon(Icons.keyboard_arrow_down, size: 16),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}