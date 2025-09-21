import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = false;

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

  Future<bool> hasInternetConnection() async {
    await _checkConnectivity();
    return _isConnected;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
