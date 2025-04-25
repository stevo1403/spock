import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wallet_provider.dart';
import '../models/transaction.dart';
import '../data/mock_data.dart';
import '../utils/theme.dart';
import '../services/api_service.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final List<String> _filters = ['All', 'Send', 'Receive', 'Swap', 'Approve'];
  String _selectedFilter = 'All';
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }
  
  Future<void> _loadTransactions() async {
    final walletProvider = context.read<WalletProvider>();
    final connectedWallet = walletProvider.connectedWallet;
    
    if (connectedWallet == null) {
      setState(() {
        _transactions = [];
        _isLoading = false;
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Call API to get transactions
      final response = await ApiService.getTransactions(connectedWallet.address);
      
      if (response['success'] == true) {
        // For demo purposes, use mock data
        final transactions = MockData.getTransactions(connectedWallet.address);
        
        setState(() {
          _transactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading transactions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
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
  
  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'send':
        return Icons.arrow_upward;
      case 'receive':
        return Icons.arrow_downward;
      case 'swap':
        return Icons.swap_horiz;
      case 'approve':
        return Icons.check_circle_outline;
      default:
        return Icons.bar_chart;
    }
  }
  
  Color _getTransactionColor(String type) {
    switch (type) {
      case 'send':
        return AppTheme.errorColor;
      case 'receive':
        return AppTheme.accentColor;
      case 'swap':
        return AppTheme.primaryColor;
      case 'approve':
        return AppTheme.subtextColor;
      default:
        return AppTheme.textColor;
    }
  }
  
  String _getTransactionTitle(Transaction transaction) {
    switch (transaction.type) {
      case 'send':
        return 'Sent ${transaction.amount} ${transaction.tokenSymbol}';
      case 'receive':
        return 'Received ${transaction.amount} ${transaction.tokenSymbol}';
      case 'swap':
        return 'Swapped for ${transaction.amount} ${transaction.tokenSymbol}';
      case 'approve':
        return 'Approved ${transaction.token}';
      default:
        return '${transaction.amount} ${transaction.tokenSymbol}';
    }
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppTheme.accentColor;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return AppTheme.errorColor;
      default:
        return AppTheme.subtextColor;
    }
  }
  
  List<Transaction> get _filteredTransactions {
    return _transactions.where((tx) => 
      _selectedFilter == 'All' || tx.type.toLowerCase() == _selectedFilter.toLowerCase()
    ).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final connectedWallet = walletProvider.connectedWallet;
    final theme = Theme.of(context);
    
    if (connectedWallet == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 64,
                  color: theme.brightness == Brightness.dark 
                      ? const Color.fromRGBO(156, 163, 175, 1) 
                      : AppTheme.lightSubtextColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Wallet Connected',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect your wallet to view your transaction history',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (_isLoading) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: AppTheme.primaryColor),
                const SizedBox(height: 16),
                Text(
                  'Loading transactions...',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadTransactions,
          color: AppTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Activity',
                        style: theme.textTheme.displayLarge,
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Filters
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? AppTheme.primaryColor 
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected 
                                    ? Colors.white 
                                    : theme.brightness == Brightness.dark 
                                        ? AppTheme.textColor 
                                        : AppTheme.lightTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Transactions
              _filteredTransactions.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 48,
                              color: theme.brightness == Brightness.dark 
                                  ? AppTheme.subtextColor 
                                  : AppTheme.lightSubtextColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Transactions',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your transaction history will appear here',
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final transaction = _filteredTransactions[index];
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: _getTransactionColor(transaction.type).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        _getTransactionIcon(transaction.type),
                                        color: _getTransactionColor(transaction.type),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _getTransactionTitle(transaction),
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatTimestamp(transaction.timestamp),
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(transaction.status).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        transaction.status,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: _getStatusColor(transaction.status),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: _filteredTransactions.length,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}