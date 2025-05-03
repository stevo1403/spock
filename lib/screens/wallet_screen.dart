import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pure_wallet_2/widgets/advertisement_banner.dart';

import '../providers/wallet_provider.dart';
import '../providers/message_provider.dart';
import '../providers/advertisement_provider.dart';
import '../providers/token_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/wallet_connect_button.dart';
import '../widgets/wallet_card.dart';
import '../widgets/message_list.dart';
import '../widgets/token_list.dart';
import '../widgets/exchange_list.dart';
import '../widgets/section_header.dart';
import '../widgets/wallet_connected_toast.dart';
import '../data/mock_data.dart';
import '../utils/theme.dart';
import '../models/wallet.dart'; // Import the Wallet model

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? _connectingWalletId;
  bool _showConnectedToast = false;

  final Map<String, bool> _expandedSections = {
    'tokens': true,
    'messages': true,
    'exchanges': true,
    'marketplace': true,
  };

  @override
  void initState() {
    super.initState();

    // Load initial data if wallet is connected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletProvider = context.read<WalletProvider>();
      if (walletProvider.connectedWallet != null) {
        if (!mounted) return;
        context.read<MessageProvider>().loadInitialMessages();
        context
            .read<TokenProvider>()
            .fetchBalances(walletProvider.connectedWallet!.address);
      }
    });
  }

  Future<void> _handleRefresh() async {
    final walletProvider = context.read<WalletProvider>();
    if (walletProvider.connectedWallet != null) {
      await walletProvider.refreshWalletData();
      if (!mounted) return;
      await context.read<MessageProvider>().refreshMessages();
      if (!mounted) return;
      await context
          .read<TokenProvider>()
          .fetchBalances(walletProvider.connectedWallet!.address);
      if (!mounted) return;
      await context.read<AdvertisementProvider>().refreshAdvertisements();
    }
  }

  Future<void> _handleConnect(String walletId) async {
    setState(() {
      _connectingWalletId = walletId;
    });

    try {
      final walletProvider = context.read<WalletProvider>();
      final messageProvider = context.read<MessageProvider>();
      final tokenProvider = context.read<TokenProvider>();

      final success = await walletProvider.connectWallet(walletId);

      if (success) {
        final wallet = walletProvider.connectedWallet;
        if (wallet != null) {
          if (!mounted) return;
          await messageProvider.loadInitialMessages();
          if (!mounted) return;
          await tokenProvider.fetchBalances(wallet.address);

          // Show connected toast
          if (!mounted) return;
          setState(() {
            _showConnectedToast = true;
          });

          // Hide toast after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showConnectedToast = false;
              });
            }
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _connectingWalletId = null;
        });
      }
    }
  }

  void _handleDisconnect() async {
    final walletProvider = context.read<WalletProvider>();
    final messageProvider = context.read<MessageProvider>();
    final success = await walletProvider.disconnectWallet();
    if (success) {
      if (!mounted) return;
      messageProvider.clearMessages();
    }
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSections[section] = !(_expandedSections[section] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final messageProvider = context.watch<MessageProvider>();
    final tokenProvider = context.watch<TokenProvider>();
    final connectedWallet = walletProvider.connectedWallet;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const AppHeader(),
                Expanded(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _handleRefresh,
                    color: AppTheme.primaryColor,
                    child: connectedWallet != null
                        ? _buildConnectedView(connectedWallet)
                        : _buildConnectWalletView(),
                  ),
                ),
              ],
            ),

            // Connected Toast
            if (_showConnectedToast && connectedWallet != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: WalletConnectedToast(
                  wallet: connectedWallet,
                  onClose: () => setState(() => _showConnectedToast = false),
                ).animate().fadeIn().slideY(begin: -1, end: 0),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedView(Wallet wallet) {
    final tokenProvider = context.watch<TokenProvider>();
    final messageProvider = context.watch<MessageProvider>();
    final exchanges = MockData.getExchanges();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SearchBarWidget(),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
        const AdvertisementBanner(),
        const SizedBox(height: 16),

        WalletCard(
          wallet: wallet,
          onDisconnect: _handleDisconnect,
        ),
        const SizedBox(height: 16),

        // Tokens Section
        SectionHeader(
          title: 'Tokens',
          isExpanded: _expandedSections['tokens'] ?? true,
          onToggle: () => _toggleSection('tokens'),
        ),
        if (_expandedSections['tokens'] ?? true)
          TokenList(
            tokenBalances: tokenProvider.tokenBalances,
            isLoading: tokenProvider.isLoading,
          ),
        const SizedBox(height: 16),

        // Messages Section
        SectionHeader(
          title: 'Messages',
          isExpanded: _expandedSections['messages'] ?? true,
          onToggle: () => _toggleSection('messages'),
        ),
        if (_expandedSections['messages'] ?? true)
          MessageList(
            messages: messageProvider.messages,
            isLoading: messageProvider.isLoading,
            onMarkAllRead: () => messageProvider.markAllMessagesAsRead(),
            onMarkAsRead: (id) => messageProvider.markMessageAsRead(id),
          ),
        const SizedBox(height: 16),

        // Exchanges Section
        SectionHeader(
          title: 'Exchanges',
          subtitle: 'Crypto Exchanges',
          isExpanded: _expandedSections['exchanges'] ?? true,
          onToggle: () => _toggleSection('exchanges'),
        ),
        if (_expandedSections['exchanges'] ?? true)
          ExchangeList(exchanges: exchanges),
        const SizedBox(height: 16),

        // Marketplace Section
        SectionHeader(
          title: 'Marketplace',
          subtitle: 'Crypto Marketplace',
          isExpanded: _expandedSections['marketplace'] ?? true,
          onToggle: () => _toggleSection('marketplace'),
        ),
        if (_expandedSections['marketplace'] ?? true)
          ExchangeList(exchanges: exchanges.take(3).toList()),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildConnectWalletView() {
    final walletProvider = context.watch<WalletProvider>();
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SearchBarWidget(),
        const SizedBox(height: 32),
        const AdvertisementBanner(),
        const SizedBox(height: 32),
        Text(
          'Connect Wallet',
          style: theme.textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Connect your wallet to access decentralized applications',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        ...walletProvider.availableWallets.map((wallet) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WalletConnectButton(
                wallet: wallet,
                onConnect: _handleConnect,
                isConnecting: _connectingWalletId == wallet.id,
              ),
            )),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {
            _refreshIndicatorKey.currentState?.show();
          },
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Refresh wallets'),
        ),
      ],
    );
  }
}
