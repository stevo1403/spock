import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/nft.dart';
import '../data/mock_data.dart';
import '../utils/theme.dart';
import '../services/api_service.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final List<String> _categories = [
    'All',
    'Art',
    'Collectibles',
    'Music',
    'Photography',
    'Sports',
    'Gaming',
    'Utility'
  ];
  
  String _selectedCategory = 'All';
  String _activeTab = 'nfts'; // 'nfts' or 'collections'
  List<NFT> _nfts = [];
  List<NFTCollection> _collections = [];
  bool _isLoading = true;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _loadMarketplaceData();
  }
  
  Future<void> _loadMarketplaceData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Call API to get NFTs and collections
      final nftResponse = await ApiService.getNFTs();
      final collectionsResponse = await ApiService.getNFTCollections();
      
      if (nftResponse['success'] == true && collectionsResponse['success'] == true) {
        // For demo purposes, use mock data
        final nfts = MockData.getNFTs();
        final collections = MockData.getNFTCollections();
        
        setState(() {
          _nfts = nfts;
          _collections = collections;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading marketplace data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _toggleLike(String id) async {
    try {
      // Call API to toggle like
      final response = await ApiService.likeNFT(id);
      
      if (response['success'] == true) {
        setState(() {
          _nfts = _nfts.map((nft) {
            if (nft.id == id) {
              final newIsLiked = !nft.isLiked;
              return nft.copyWith(
                isLiked: newIsLiked,
                likes: newIsLiked ? nft.likes + 1 : nft.likes - 1,
              );
            }
            return nft;
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }
  
  List<NFT> get _filteredNFTs {
    return _nfts.where((nft) {
      final matchesCategory = _selectedCategory == 'All' || 
                             nft.collection.contains(_selectedCategory);
      final matchesSearch = _searchQuery.isEmpty || 
                           nft.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           nft.collection.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
  
  List<NFTCollection> get _filteredCollections {
    return _collections.where((collection) {
      final matchesCategory = _selectedCategory == 'All';
      final matchesSearch = _searchQuery.isEmpty || 
                           collection.name.toLowerCase().contains(_searchQuery.toLowerCase());
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
                  'Loading marketplace...',
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
          onRefresh: _loadMarketplaceData,
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
                        'Marketplace',
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
                                  hintText: 'Search NFTs and Collections',
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
                      
                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _activeTab = 'nfts';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _activeTab == 'nfts' 
                                        ? AppTheme.primaryColor 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'NFTs',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _activeTab == 'nfts' 
                                          ? Colors.white 
                                          : theme.brightness == Brightness.dark 
                                              ? AppTheme.textColor 
                                              : AppTheme.lightTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _activeTab = 'collections';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _activeTab == 'collections' 
                                        ? AppTheme.primaryColor 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Collections',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _activeTab == 'collections' 
                                          ? Colors.white 
                                          : theme.brightness == Brightness.dark 
                                              ? AppTheme.textColor 
                                              : AppTheme.lightTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
              
              // Content based on active tab
              _activeTab == 'nfts'
                  ? _buildNFTsGrid()
                  : _buildCollectionsList(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNFTsGrid() {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 48) / 2; // 2 items per row with padding
    
    if (_filteredNFTs.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.store,
                size: 64,
                color: theme.brightness == Brightness.dark 
                    ? AppTheme.subtextColor 
                    : AppTheme.lightSubtextColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No NFTs Found',
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
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final nft = _filteredNFTs[index];
            
            return Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: nft.image,
                      height: itemWidth,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.brightness == Brightness.dark 
                            ? AppTheme.borderColor 
                            : AppTheme.lightBorderColor,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nft.name,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nft.collection,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${nft.price} ${nft.currency}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.brightness == Brightness.dark 
                                    ? AppTheme.textColor 
                                    : AppTheme.lightTextColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleLike(nft.id),
                              child: Row(
                                children: [
                                  Icon(
                                    nft.isLiked ? Icons.favorite : Icons.favorite_border,
                                    size: 16,
                                    color: nft.isLiked ? AppTheme.errorColor : AppTheme.subtextColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    nft.likes.toString(),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: _filteredNFTs.length,
        ),
      ),
    );
  }
  
  Widget _buildCollectionsList() {
    final theme = Theme.of(context);
    
    if (_filteredCollections.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.store,
                size: 64,
                color: theme.brightness == Brightness.dark 
                    ? AppTheme.subtextColor 
                    : AppTheme.lightSubtextColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No Collections Found',
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
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final collection = _filteredCollections[index];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: CachedNetworkImage(
                          imageUrl: collection.image,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: theme.brightness == Brightness.dark 
                                ? AppTheme.borderColor 
                                : AppTheme.lightBorderColor,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collection.name,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem(
                              'Floor',
                              '${collection.floorPrice} ${collection.currency}',
                              theme,
                            ),
                            _buildStatItem(
                              'Volume',
                              '${collection.volume} ${collection.currency}',
                              theme,
                            ),
                            _buildStatItem(
                              'Items',
                              collection.items.toString(),
                              theme,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: _filteredCollections.length,
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.brightness == Brightness.dark 
                  ? AppTheme.subtextColor 
                  : AppTheme.lightSubtextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.brightness == Brightness.dark 
                  ? AppTheme.textColor 
                  : AppTheme.lightTextColor,
            ),
          ),
        ],
      ),
    );
  }
}