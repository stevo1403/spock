import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/wallet.dart';
import '../data/mock_data.dart';
import '../services/api_service.dart';

class WalletProvider with ChangeNotifier {
  Wallet? _connectedWallet;
  bool _isConnecting = false;
  List<Wallet> _availableWallets = [];
  
  Wallet? get connectedWallet => _connectedWallet;
  bool get isConnecting => _isConnecting;
  List<Wallet> get availableWallets => _availableWallets;
  
  WalletProvider() {
    _loadSavedWallet();
    _loadAvailableWallets();
  }
  
  Future<void> _loadSavedWallet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final walletJson = prefs.getString('connected_wallet');
      
      if (walletJson != null) {
        _connectedWallet = Wallet.fromJson(json.decode(walletJson));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved wallet: $e');
    }
  }
  
  Future<void> _loadAvailableWallets() async {
    _availableWallets = MockData.getWallets();
    notifyListeners();
  }
  
  Future<void> _saveWallet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_connectedWallet != null) {
        await prefs.setString('connected_wallet', json.encode(_connectedWallet!.toJson()));
      } else {
        await prefs.remove('connected_wallet');
      }
    } catch (e) {
      debugPrint('Error saving wallet: $e');
    }
  }
  
  Future<bool> connectWallet(String walletId) async {
    _isConnecting = true;
    notifyListeners();
    
    try {
      // Call API to connect wallet
      final response = await ApiService.connectWallet(walletId);
      
      if (response['success'] == true) {
        final wallets = MockData.getWallets();
        _connectedWallet = wallets.firstWhere((w) => w.id == walletId);
        await _saveWallet();
        _isConnecting = false;
        notifyListeners();
        return true;
      } else {
        _isConnecting = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Error connecting wallet: $e');
      _isConnecting = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> disconnectWallet() async {
    try {
      if (_connectedWallet != null) {
        // Call API to disconnect wallet
        final response = await ApiService.disconnectWallet(_connectedWallet!.id);
        
        if (response['success'] == true) {
          _connectedWallet = null;
          await _saveWallet();
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error disconnecting wallet: $e');
      return false;
    }
  }
  
  Future<void> refreshWalletData() async {
    if (_connectedWallet == null) return;
    
    try {
      // In a real app, this would refresh wallet data from the blockchain
      // For now, we'll just simulate a refresh
      final wallets = MockData.getWallets();
      final updatedWallet = wallets.firstWhere((w) => w.id == _connectedWallet!.id);
      _connectedWallet = updatedWallet;
      await _saveWallet();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing wallet data: $e');
    }
  }
}