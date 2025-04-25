import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/wallet_provider.dart';
import '../providers/message_provider.dart';
import '../providers/advertisement_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/wallet_connect_button.dart';
import '../widgets/advertisement_banner.dart';
import '../widgets/wallet_card.dart';
import '../widgets/message_list.dart';
import '../utils/theme.dart';
import '../data/mock_data.dart'; // Import MockData

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Timer? _adRotationTimer;
  String? _connectingWalletId;

  @override
  void initState() {
    super.initState();

    // Start ad rotation timer
    _adRotationTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        if (!mounted) return;
        context.read<AdvertisementProvider>().rotateAdvertisement();
      },
    );

    // Load initial data if wallet is connected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletProvider = context.read<WalletProvider>();
      if (walletProvider.connectedWallet != null) {
        context.read<MessageProvider>().loadInitialMessages();
      }
    });
  }

  @override
  void dispose() {
    _adRotationTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final walletProvider = context.read<WalletProvider>();
    if (walletProvider.connectedWallet != null) {
       if (!mounted) return;
      await context.read<MessageProvider>().refreshMessages();
    }
  }

  Future<void> _handleConnect(String walletId) async {
    setState(() {
      _connectingWalletId = walletId;
    });

    try {
      final walletProvider = context.read<WalletProvider>();
      final messageProvider = context.read<MessageProvider>();
      await walletProvider.connectWallet(walletId);
      if (!mounted) return; // Add mounted check here
      messageProvider.loadInitialMessages();
    } finally {
       if (!mounted) return;
      setState(() {
        _connectingWalletId = null;
      });
    }
  }

  void _handleDisconnect() {
    context.read<WalletProvider>().disconnectWallet();
    context.read<MessageProvider>().clearMessages();
  }

  void _markMessageAsRead(String messageId) {
    context.read<MessageProvider>().markMessageAsRead(messageId);
  }

  void _markAllMessagesAsRead() {
    context.read<MessageProvider>().markAllMessagesAsRead();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final messageProvider = context.watch<MessageProvider>(); // Watch MessageProvider
    final connectedWallet = walletProvider.connectedWallet;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                color: AppTheme.primaryColor,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SearchBarWidget(),
                    const SizedBox(height: 16),
                    if (connectedWallet != null) ...[
                      const AdvertisementBanner(),
                      const SizedBox(height: 16),
                      WalletCard(
                        wallet: connectedWallet,
                        onDisconnect: _handleDisconnect,
                      ),
                      const SizedBox(height: 16),
                      // Pass the messages and callbacks from the provider
                      MessageList(
                        messages: messageProvider.messages,
                        onMarkAsRead: _markMessageAsRead, // Add required callback
                        onMarkAllRead: _markAllMessagesAsRead, // Add required callback
                      ),
                    ] else ...[
                      _buildConnectWalletSection(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildConnectWalletSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Connect Wallet',
          style: AppTheme.headingStyle,
        ),
        const SizedBox(height: 8),
        const Text(
          'Connect your wallet to access decentralized applications',
          style: AppTheme.captionStyle,
        ),
        const SizedBox(height: 24),
        ...MockData.getWallets().map((wallet) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WalletConnectButton(
                wallet: wallet,
                onConnect: _handleConnect,
                isConnecting: _connectingWalletId == wallet.id,
              ),
            )), // Remove .toList()
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Refresh wallets'),
        ),
      ],
    );
  }
}
