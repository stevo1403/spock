import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/token.dart';
import '../data/mock_data.dart';
import '../services/api_service.dart';

class TokenProvider with ChangeNotifier {
  List<Token> _tokens = [];
  List<TokenBalance> _tokenBalances = [];
  bool _isLoading = false;
  
  List<Token> get tokens => _tokens;
  List<TokenBalance> get tokenBalances => _tokenBalances;
  bool get isLoading => _isLoading;
  
  TokenProvider() {
    _loadTokens();
  }
  
  Future<void> _loadTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokensJson = prefs.getString('tokens');
      
      if (tokensJson != null) {
        final List<dynamic> decoded = json.decode(tokensJson);
        _tokens = decoded.map((item) => Token.fromJson(item)).toList();
        notifyListeners();
      } else {
        await refreshTokens();
      }
    } catch (e) {
      debugPrint('Error loading tokens: $e');
    }
  }
  
  Future<void> _saveTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokensJson = json.encode(_tokens.map((t) => t.toJson()).toList());
      await prefs.setString('tokens', tokensJson);
    } catch (e) {
      debugPrint('Error saving tokens: $e');
    }
  }
  
  Future<void> refreshTokens() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Call API to get tokens
      final response = await ApiService.getTokens();
      
      if (response['success'] == true) {
        // For demo purposes, use mock data
        _tokens = MockData.getTokens();
        await _saveTokens();
      }
    } catch (e) {
      debugPrint('Error refreshing tokens: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchBalances(String address) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Call API to get token balances
      final response = await ApiService.getTokenBalances(address);
      
      if (response['success'] == true) {
        // For demo purposes, use mock data
        _tokenBalances = MockData.getTokenBalances(address);
      }
    } catch (e) {
      debugPrint('Error fetching token balances: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}