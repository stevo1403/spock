import 'package:flutter/foundation.dart';
import 'dart:async';

import '../models/wallet.dart';
import '../data/mock_data.dart';
import '../services/api_service.dart';

class AdvertisementProvider with ChangeNotifier {
  List<Advertisement> _advertisements = [];
  Advertisement? _currentAd;
  int _currentAdIndex = 0;
  Timer? _adRotationTimer;
  
  List<Advertisement> get advertisements => _advertisements;
  Advertisement? get currentAd => _currentAd;
  
  AdvertisementProvider() {
    _loadAdvertisements();
    _startAdRotation();
  }
  
  @override
  void dispose() {
    _adRotationTimer?.cancel();
    super.dispose();
  }
  
  Future<void> _loadAdvertisements() async {
    try {
      // Call API to get advertisements
      final response = await ApiService.getAdvertisements();
      
      if (response['success'] == true) {
        // For demo purposes, use mock data
        _advertisements = MockData.getAdvertisements();
        if (_advertisements.isNotEmpty) {
          _currentAd = _advertisements[0];
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading advertisements: $e');
    }
  }
  
  void _startAdRotation() {
    _adRotationTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => rotateAdvertisement(),
    );
  }
  
  void rotateAdvertisement() {
    if (_advertisements.isEmpty) return;
    
    _currentAdIndex = (_currentAdIndex + 1) % _advertisements.length;
    _currentAd = _advertisements[_currentAdIndex];
    notifyListeners();
  }
  
  Future<void> refreshAdvertisements() async {
    try {
      // Call API to refresh advertisements
      final response = await ApiService.getAdvertisements();
      
      if (response['success'] == true) {
        // For demo purposes, use mock data
        _advertisements = MockData.getAdvertisements();
        if (_advertisements.isNotEmpty) {
          _currentAd = _advertisements[0];
          _currentAdIndex = 0;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error refreshing advertisements: $e');
    }
  }
}