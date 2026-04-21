import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../analytics/health_summary_provider.dart';

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("MedSeva Health Dashboard"),
        elevation: 0,
      ),
      body: Consumer<HealthSummaryProvider>(
        builder: (context, provider, child) {
          final summary = provider.latestSummary;
          final score = summary?.healthScore ?? 0;
          final details = summary?.summary ?? 'Scan a medical report to generate insights';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScoreCard(score),
                const SizedBox(height: 25),
                const Text("Health Insights", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                if (summary == null)
                  _buildInsightCard("No Data", details, Icons.info, Colors.grey)
                else ...[
                  if (score < 85)
                     _buildInsightCard("Attention Required", "Your recent scan indicates vitals may need monitoring.", Icons.warning_amber, Colors.orange)
                  else
                     _buildInsightCard("Risk Level: Stable", "Your general vitals are within normal range.", Icons.check_circle, Colors.green),
                  
                  _buildInsightCard("Latest AI Analysis", details, Icons.analytics, Colors.blue),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreCard(int score) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blue.withAlpha(76), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Overall Health Score", style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 8),
              Text("$score/100", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(value: score / 100, color: Colors.white, backgroundColor: Colors.white24, strokeWidth: 8),
              ),
              const Icon(Icons.favorite, color: Colors.white, size: 30),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 25), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
