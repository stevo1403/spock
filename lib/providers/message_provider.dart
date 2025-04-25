import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/wallet.dart';
import '../data/mock_data.dart';
import '../services/notification_service.dart';
import '../services/api_service.dart';

class MessageProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _hasUnreadMessages = false;
  bool _isLoading = false;
  
  List<Message> get messages => _messages;
  bool get hasUnreadMessages => _hasUnreadMessages;
  bool get isLoading => _isLoading;
  
  MessageProvider() {
    _loadMessages();
  }
  
  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString('messages');
      
      if (messagesJson != null) {
        final List<dynamic> decoded = json.decode(messagesJson);
        _messages = decoded.map((item) => Message.fromJson(item)).toList();
        _updateUnreadStatus();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }
  
  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = json.encode(_messages.map((m) => m.toJson()).toList());
      await prefs.setString('messages', messagesJson);
    } catch (e) {
      debugPrint('Error saving messages: $e');
    }
  }
  
  void _updateUnreadStatus() {
    _hasUnreadMessages = _messages.any((message) => !message.read);
  }
  
  Future<void> loadInitialMessages() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Call API to get messages
      final response = await ApiService.getMessages();
      
      if (response['success'] == true) {
        // For demo purposes, use mock data
        _messages = MockData.getMessages();
        _updateUnreadStatus();
        await _saveMessages();
      }
    } catch (e) {
      debugPrint('Error loading initial messages: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> markMessageAsRead(String messageId) async {
    final index = _messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      try {
        // Call API to mark message as read
        final response = await ApiService.markMessageAsRead(messageId);
        
        if (response['success'] == true) {
          _messages[index].read = true;
          _updateUnreadStatus();
          await _saveMessages();
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error marking message as read: $e');
      }
    }
  }
  
  Future<void> markAllMessagesAsRead() async {
    try {
      // Call API to mark all messages as read
      final response = await ApiService.markAllMessagesAsRead();
      
      if (response['success'] == true) {
        for (var message in _messages) {
          message.read = true;
        }
        _hasUnreadMessages = false;
        await _saveMessages();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking all messages as read: $e');
    }
  }
  
  Future<void> refreshMessages() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Call API to refresh messages
      final response = await ApiService.getMessages();
      
      if (response['success'] == true) {
        // Add a new message
        final newMessage = MockData.generateNewMessage();
        _messages.insert(0, newMessage);
        _hasUnreadMessages = true;
        
        // Show notification
        await NotificationService.showNotification(
          title: newMessage.title,
          body: newMessage.content,
        );
        
        await _saveMessages();
      }
    } catch (e) {
      debugPrint('Error refreshing messages: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearMessages() {
    _messages = [];
    _hasUnreadMessages = false;
    _saveMessages();
    notifyListeners();
  }
}