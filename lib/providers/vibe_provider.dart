import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/api_service.dart';

class VibeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Destination> _destinations = [];
  List<Destination> get destinations => _destinations;

  VibeType _selectedVibe = VibeType.beach;
  VibeType get selectedVibe => _selectedVibe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Destination> get filteredDestinations {
    if (_destinations.isEmpty) return [];
    return _destinations.where((d) => d.vibe == _selectedVibe).toList();
  }

  void setVibe(VibeType vibe) {
    if (_selectedVibe == vibe) return;
    _selectedVibe = vibe;
    notifyListeners();
  }

  Future<void> fetchDestinations() async {
    // Only fetch if we don't have data yet to save API calls in this demo
    if (_destinations.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _destinations = await _apiService.getDestinations();
    } catch (e) {
      print('Error fetching destinations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Allow refreshing data
  Future<void> refreshDestinations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _destinations = await _apiService.getDestinations();
    } catch (e) {
      print('Error refreshing destinations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
