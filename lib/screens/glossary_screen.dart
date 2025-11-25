import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/glossary_item.dart';
import '../services/data_service.dart';
import '../services/admob_service.dart';
import '../services/connectivity_service.dart';
import '../config/ad_config.dart';
import '../utils/app_theme.dart';
import '../widgets/navigation_drawer.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  final DataService _dataService = DataService();
  final AdMobService _adMobService = AdMobService();
  final TextEditingController _searchController = TextEditingController();
  
  List<GlossaryItem> _allItems = [];
  List<GlossaryItem> _filteredItems = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadGlossaryData();
    _loadBannerAd();
    _searchController.addListener(_filterItems);
  }

  void _loadGlossaryData() {
    _allItems = _dataService.getGlossary();
    _categories = ['All', ..._dataService.getGlossaryCategories()];
    _filteredItems = _allItems;
    setState(() {});
  }

  Future<void> _loadBannerAd() async {
    // Check internet connectivity before loading ads
    final hasInternet = await ConnectivityService().checkInternetAndShowRequiredScreen();
    if (!hasInternet) return;

    _bannerAd = BannerAd(
      adUnitId: AdConfig.getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner ad loaded successfully');
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          setState(() {
            _isBannerAdReady = false;
          });
          ad.dispose();
        },
        onAdOpened: (ad) {
          print('Banner ad opened');
        },
        onAdClosed: (ad) {
          print('Banner ad closed');
        },
      ),
    );
    _bannerAd!.load();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty && _selectedCategory == 'All') {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems.where((item) {
          final matchesSearch = query.isEmpty ||
              item.term.toLowerCase().contains(query) ||
              item.definition.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query);
          
          final matchesCategory = _selectedCategory == 'All' ||
              item.category == _selectedCategory;
          
          return matchesSearch && matchesCategory;
        }).toList();
      }
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Glossary'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Open Menu',
          ),
        ),
      ),
      drawer: const CustomNavigationDrawer(),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search terms, definitions, or categories...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) => _onCategorySelected(category),
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${_filteredItems.length} terms found',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Glossary Items
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredItems.length + (_isBannerAdReady && _bannerAd != null ? 2 : 0),
                    itemBuilder: (context, index) {
                      // Add banner ad after first few items
                      if (_isBannerAdReady && _bannerAd != null && index == 3) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            width: double.infinity,
                            height: _bannerAd!.size.height.toDouble(),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        );
                      }
                      
                      // Add banner ad near the end
                      if (_isBannerAdReady && _bannerAd != null && index == _filteredItems.length + 1) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            width: double.infinity,
                            height: _bannerAd!.size.height.toDouble(),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        );
                      }
                      
                      // Adjust index for banner ads
                      final adjustedIndex = _isBannerAdReady && _bannerAd != null && index > 3 ? index - 1 : index;
                      
                      if (adjustedIndex >= _filteredItems.length) return const SizedBox.shrink();
                      
                      final item = _filteredItems[adjustedIndex];
                      return _buildGlossaryItem(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No terms found',
            style: AppTheme.heading3.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or category filter',
            style: AppTheme.bodyLarge.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGlossaryItem(GlossaryItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCategoryColor(item.category),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              item.term[0].toUpperCase(),
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          item.term,
          style: AppTheme.heading3,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoryColor(item.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _getCategoryColor(item.category).withOpacity(0.3),
                ),
              ),
              child: Text(
                item.category,
                style: AppTheme.bodySmall.copyWith(
                  color: _getCategoryColor(item.category),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              item.definition,
              style: AppTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'language':
        return AppTheme.primaryColor;
      case 'framework':
        return AppTheme.infoColor;
      case 'basics':
        return AppTheme.successColor;
      case 'functions':
        return AppTheme.warningColor;
      case 'oop':
        return AppTheme.errorColor;
      case 'collections':
        return Colors.purple;
      case 'error handling':
        return Colors.red[700]!;
      case 'language features':
        return Colors.teal;
      case 'async programming':
        return Colors.orange;
      case 'advanced':
        return Colors.deepPurple;
      case 'development':
        return Colors.blueGrey;
      default:
        return AppTheme.primaryColor;
    }
  }
}
