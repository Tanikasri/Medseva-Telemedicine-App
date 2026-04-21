import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../features/analytics/health_summary_provider.dart';
import '../../core/models/health_summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthSummaryProvider>(context, listen: false).fetchLatestSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Consumer<HealthSummaryProvider>(
                builder: (context, provider, child) {
                  return _buildHealthCard(context, provider.latestSummary);
                },
              ),
              const SizedBox(height: 32),
              Text(
                "Health Services",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildVerticalGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back,", style: TextStyle(color: AppColors.textSecondary)),
            Text("Tanika 👋", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.person_outline, color: AppColors.primaryDark)
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCard(BuildContext context, HealthSummary? summary) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Latest Health Score", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const Icon(Icons.favorite, color: AppColors.primaryDark),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "${summary?.healthScore ?? '--'}",
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 8),
            Text(
              summary?.summary ?? "Analyze your first report to see insights here.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalGrid(BuildContext context) {
    return Column(
      children: [
        _buildFeatureCard(
          context,
          title: "Upload Reports",
          desc: "Manage and save your medical files",
          icon: Icons.upload_file_rounded,
          color: AppColors.primaryDark,
          route: '/reports',
        ),
        _buildFeatureCard(
          context,
          title: "Scan Documents",
          desc: "Extract text with AI Scanner",
          icon: Icons.document_scanner_rounded,
          color: Colors.blueAccent,
          route: '/scanner',
        ),
        _buildFeatureCard(
          context,
          title: "Health Analytics",
          desc: "Track your health trends",
          icon: Icons.analytics_rounded,
          color: Colors.orangeAccent,
          route: '/analytics',
        ),
        _buildFeatureCard(
          context,
          title: "Doctor Booking",
          desc: "Consult with specialists online",
          icon: Icons.calendar_month_rounded,
          color: Colors.tealAccent.shade700,
          route: '/doctors',
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
