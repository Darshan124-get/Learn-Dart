import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../screens/internet_required_screen.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = false;
  BuildContext? _currentContext;

  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    // Check initial connectivity
    await _checkConnectivity();
    
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isConnected = result.isNotEmpty && !result.contains(ConnectivityResult.none);
    } catch (e) {
      print('Error checking connectivity: $e');
      _isConnected = false;
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    _isConnected = result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  void setCurrentContext(BuildContext context) {
    _currentContext = context;
  }

  void _showInternetRequiredScreen() {
    if (_currentContext != null) {
      Navigator.of(_currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const InternetRequiredScreen()),
        (route) => false,
      );
    }
  }

  Future<bool> hasInternetConnection() async {
    await _checkConnectivity();
    return _isConnected;
  }

  Future<bool> checkInternetAndShowRequiredScreen() async {
    final hasInternet = await hasInternetConnection();
    
    if (!hasInternet && _currentContext != null) {
      _showInternetRequiredScreen();
      return false;
    }
    
    return hasInternet;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
