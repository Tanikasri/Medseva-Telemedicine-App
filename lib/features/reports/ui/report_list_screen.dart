import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../report_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/report.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  Future<void> _pickAndUpload(BuildContext context) async {
    final picker = ImagePicker();
    final provider = Provider.of<ReportProvider>(context, listen: false);

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final success = await provider.uploadReport(image, image.name);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Report uploaded & analyzed successfully!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<ReportProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          
          if (provider.reports.isEmpty) {
            return _buildEmptyState(context);
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchReports(),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: provider.reports.length,
              itemBuilder: (context, index) {
                final report = provider.reports[index];
                return _buildReportCard(context, report);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickAndUpload(context),
        backgroundColor: AppColors.primaryDark,
        icon: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        label: const Text("Scan New Report", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 80, color: Colors.grey.withAlpha(100)),
          const SizedBox(height: 16),
          const Text("No medical reports yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const Text("Upload a photo or PDF to start tracking.", style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withAlpha(50), borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                    report.type == 'PDF' ? Icons.picture_as_pdf_rounded : Icons.image_rounded, 
                    color: AppColors.primaryDark
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(report.fileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text("${report.uploadTimestamp.day}/${report.uploadTimestamp.month}/${report.uploadTimestamp.year}", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            const Text("AI SUMMARY PREVIEW:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(
              report.summary ?? "Processing summary...",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
