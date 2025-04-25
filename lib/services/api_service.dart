import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'https://api.example.com';
  
  static Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
  
  static Future<Map<String, dynamic>> _mockApiCall({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    // Log the API call
    debugPrint('API $method: $baseUrl$endpoint');
    if (body != null) {
      debugPrint('Body: ${json.encode(body)}');
    }
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock success response
    return {'success': true};
  }
  
  // Wallet methods
  static Future<Map<String, dynamic>> connectWallet(String walletId) async {
    return _mockApiCall(
      endpoint: '/wallet/connect',
      method: 'POST',
      body: {'walletId': walletId},
    );
  }
  
  static Future<Map<String, dynamic>> disconnectWallet(String walletId) async {
    return _mockApiCall(
      endpoint: '/wallet/disconnect',
      method: 'POST',
      body: {'walletId': walletId},
    );
  }
  
  // Token methods
  static Future<Map<String, dynamic>> getTokens() async {
    return _mockApiCall(endpoint: '/tokens');
  }
  
  static Future<Map<String, dynamic>> getTokenBalances(String address) async {
    return _mockApiCall(endpoint: '/tokens/balances?address=$address');
  }
  
  // Message methods
  static Future<Map<String, dynamic>> getMessages() async {
    return _mockApiCall(endpoint: '/messages');
  }
  
  static Future<Map<String, dynamic>> markMessageAsRead(String messageId) async {
    return _mockApiCall(
      endpoint: '/messages/$messageId/read',
      method: 'POST',
    );
  }
  
  static Future<Map<String, dynamic>> markAllMessagesAsRead() async {
    return _mockApiCall(
      endpoint: '/messages/read-all',
      method: 'POST',
    );
  }
  
  // Transaction methods
  static Future<Map<String, dynamic>> getTransactions(String address) async {
    return _mockApiCall(endpoint: '/transactions?address=$address');
  }
  
  // NFT methods
  static Future<Map<String, dynamic>> getNFTs() async {
    return _mockApiCall(endpoint: '/nfts');
  }
  
  static Future<Map<String, dynamic>> getNFTCollections() async {
    return _mockApiCall(endpoint: '/nfts/collections');
  }
  
  static Future<Map<String, dynamic>> likeNFT(String nftId) async {
    return _mockApiCall(
      endpoint: '/nfts/$nftId/like',
      method: 'POST',
    );
  }
  
  // DApp methods
  static Future<Map<String, dynamic>> getDApps() async {
    return _mockApiCall(endpoint: '/dapps');
  }
  
  // Advertisement methods
  static Future<Map<String, dynamic>> getAdvertisements() async {
    return _mockApiCall(endpoint: '/advertisements');
  }
  
  // User preferences
  static Future<Map<String, dynamic>> updateUserPreferences(Map<String, dynamic> preferences) async {
    return _mockApiCall(
      endpoint: '/user/preferences',
      method: 'PUT',
      body: preferences,
    );
  }
  
  // Authentication
  static Future<Map<String, dynamic>> logout() async {
    return _mockApiCall(
      endpoint: '/auth/logout',
      method: 'POST',
    );
  }
  
  // Push notification registration
  static Future<Map<String, dynamic>> registerPushToken(String token, String platform) async {
    return _mockApiCall(
      endpoint: '/notifications/register',
      method: 'POST',
      body: {'token': token, 'platform': platform},
    );
  }
}