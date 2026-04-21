import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/models/health_summary.dart';

class HealthSummaryProvider extends ChangeNotifier {
  HealthSummary? _latestSummary;
  List<HealthSummary> _history = [];
  bool _isLoading = false;

  HealthSummary? get latestSummary => _latestSummary;
  List<HealthSummary> get history => _history;
  bool get isLoading => _isLoading;

  HealthSummaryProvider() {
    fetchHistory();
  }

  Future<void> fetchLatestSummary() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box<HealthSummary>('healthSummaryBox');
      final allSummaries = box.values.toList().cast<HealthSummary>();
      if (allSummaries.isNotEmpty) {
        allSummaries.sort((a, b) => b.analyzedAt.compareTo(a.analyzedAt));
        _latestSummary = allSummaries.first;
      }
    } catch (e) {
      debugPrint('Error fetching latest summary: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box<HealthSummary>('healthSummaryBox');
      _history = box.values.toList().cast<HealthSummary>();
      _history.sort((a, b) => b.analyzedAt.compareTo(a.analyzedAt));
      if (_history.isNotEmpty) {
        _latestSummary = _history.first;
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveSummary(HealthSummary summary) async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box<HealthSummary>('healthSummaryBox');
      await box.put(summary.id, summary);
      await fetchHistory(); // Also refreshes latestSummary
    } catch (e) {
      debugPrint('Error saving summary: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
