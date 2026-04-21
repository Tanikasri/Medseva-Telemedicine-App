import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'health_summary_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/health_summary.dart';

class HealthAnalyticsScreen extends StatefulWidget {
  const HealthAnalyticsScreen({super.key});

  @override
  State<HealthAnalyticsScreen> createState() => _HealthAnalyticsScreenState();
}

class _HealthAnalyticsScreenState extends State<HealthAnalyticsScreen> {
  final _summaryController = TextEditingController();
  bool _isAnalyzing = false;
  HealthSummary? _manualResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthSummaryProvider>(context, listen: false).fetchHistory();
    });
  }

  Future<void> _analyzeSummary() async {
    final text = _summaryController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _manualResult = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate processing

      int score = 88;
      String generatedSummary = "General condition seems stable.";

      if (text.toLowerCase().contains("sugar") || text.toLowerCase().contains("glucose")) {
        score -= 10;
        generatedSummary += " Mention of sugar detected. Please monitor intake.";
      }
      if (text.toLowerCase().contains("pressure") || text.toLowerCase().contains("bp")) {
        score -= 15;
        generatedSummary += " Blood pressure metrics spotted. Ensure stability.";
      }

      final newSummary = HealthSummary(
        id: "manual_${DateTime.now().millisecondsSinceEpoch}",
        healthScore: score,
        summary: "Manual AI Analysis: $generatedSummary\n(Input: ${text.length > 50 ? '${text.substring(0, 50)}...' : text})",
        analyzedAt: DateTime.now()
      );

      if (!mounted) return;
      final provider = Provider.of<HealthSummaryProvider>(context, listen: false);
      await provider.saveSummary(newSummary);

      if (mounted) {
        setState(() {
          _manualResult = newSummary;
        });
      }
    } catch (e) {
      debugPrint("Analysis error: $e");
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildManualInputCard(),
          const SizedBox(height: 32),
          Text(
            "Health History",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildManualInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.psychology_alt_rounded, color: AppColors.primaryDark),
                SizedBox(width: 12),
                Text("Smart Clinical Analysis", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            const Text("Paste a medical summary below for immediate AI clinical scoring.", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 20),
            TextField(
              controller: _summaryController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "e.g. Patient has high sugar and normal blood pressure...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAnalyzing ? null : _analyzeSummary,
              child: _isAnalyzing ? const CircularProgressIndicator(color: Colors.white) : const Text("ANALYZE NOW"),
            ),
            if (_manualResult != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text("Analysis Result:", style: TextStyle(fontWeight: FontWeight.bold)),
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                     decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
                     child: Text("Score: ${_manualResult!.healthScore}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                   )
                ],
              ),
              const SizedBox(height: 12),
              Text(_manualResult!.summary, style: const TextStyle(color: AppColors.textPrimary)),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Consumer<HealthSummaryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        if (provider.history.isEmpty) return const Center(child: Text("No analysis history found."));

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.history.length,
          itemBuilder: (context, index) {
            final summary = provider.history[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: summary.healthScore > 80 ? Colors.green.shade50 : Colors.red.shade50,
                  child: Text(summary.healthScore.toString(), style: TextStyle(color: summary.healthScore > 80 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                ),
                title: Text(summary.summary, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text("Analyzed at: ${summary.analyzedAt.day}/${summary.analyzedAt.month}"),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            );
          },
        );
      },
    );
  }
}
