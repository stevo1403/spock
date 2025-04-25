import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/dapp.dart';
import '../data/mock_data.dart';
import '../utils/theme.dart';
import '../services/api_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<String> _categories = [
    'All',
    'DeFi',
    'NFT',
    'Gaming',
    'Social',
    'Marketplace',
    'Tools'
  ];
  
  String _selectedCategory = 'All';
  List<DApp> _dapps = [];
  List<DApp> _featuredDapps = [];
  bool _isLoading = true;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _loadDapps();
  }
  
  Future<void> _loadDapps() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Call API to get dapps
      final response = await ApiService.getDApps();
      
      if (response['success'] == true) {
        // For demo purposes, use mock data
        final dapps = MockData.getDApps();
        
        setState(() {
          _dapps = dapps;
          _featuredDapps = dapps.where((dapp) => dapp.featured).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading dapps: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  List<DApp> get _filteredDapps {
    return _dapps.where((dapp) {
      final matchesCategory = _selectedCategory == 'All' || dapp.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || 
                           dapp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           dapp.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                  'Loading dApps...',
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
          onRefresh: _loadDapps,
          color: AppTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore',
                        style: theme.textTheme.displayLarge,
                      ),
                      const SizedBox(height: 16),
                      
                      // Search Bar
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(
                              Icons.search,
                              color: theme.brightness == Brightness.dark 
                                  ? AppTheme.subtextColor 
                                  : AppTheme.lightSubtextColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search Decentralized Apps',
                                  hintStyle: theme.brightness == Brightness.dark 
                                      ? AppTheme.captionStyle 
                                      : AppTheme.lightCaptionStyle,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                style: theme.brightness == Brightness.dark 
                                    ? AppTheme.bodyStyle 
                                    : AppTheme.lightBodyStyle,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.tune,
                                color: theme.brightness == Brightness.dark 
                                    ? AppTheme.textColor 
                                    : AppTheme.lightTextColor,
                                size: 18,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              
              // Categories
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
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
                              category,
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
              
              // Featured Section
              if (_featuredDapps.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text(
                      'Featured',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _featuredDapps.length,
                      itemBuilder: (context, index) {
                        final dapp = _featuredDapps[index];
                        
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: CachedNetworkImage(
                                    imageUrl: dapp.icon,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dapp.name,
                                        style: theme.textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dapp.description,
                                        style: theme.textTheme.bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.open_in_new,
                                  size: 20,
                                  color: AppTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
              
              // All dApps
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    'All dApps',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
              
              _filteredDapps.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.explore,
                              size: 64,
                              color: theme.brightness == Brightness.dark 
                                  ? AppTheme.subtextColor 
                                  : AppTheme.lightSubtextColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No dApps Found',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try changing your search or filter criteria',
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final dapp = _filteredDapps[index];
                            
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: dapp.icon,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
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
                                            dapp.name,
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            dapp.description,
                                            style: theme.textTheme.bodySmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              dapp.category,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.open_in_new,
                                      size: 18,
                                      color: theme.brightness == Brightness.dark 
                                          ? AppTheme.subtextColor 
                                          : AppTheme.lightSubtextColor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: _filteredDapps.length,
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