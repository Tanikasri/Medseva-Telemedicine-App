import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/report.dart';

class ReportProvider extends ChangeNotifier {
  List<Report> _reports = [];
  bool _isLoading = false;

  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;

  ReportProvider() {
    fetchReports();
  }

  Future<void> fetchReports() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box<Report>('reportsBox');
      _reports = box.values.toList().cast<Report>();
      _reports.sort((a, b) => b.uploadTimestamp.compareTo(a.uploadTimestamp));
    } catch (e) {
      debugPrint('Error fetching reports from Hive: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> uploadReport(XFile file, String fileName) async {
    _isLoading = true;
    notifyListeners();

    try {
      String localFilePath = "web_mock_path_${DateTime.now().millisecondsSinceEpoch}";
      final String fileExtension = fileName.contains('.') ? fileName.split('.').last : 'IMAGE';

      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final String folderPath = '${directory.path}/reports';
        final folder = Directory(folderPath);
        if (!await folder.exists()) {
          await folder.create(recursive: true);
        }

        final String uniqueFileName = '${const Uuid().v4()}.$fileExtension';
        localFilePath = '$folderPath/$uniqueFileName';

        await File(file.path).copy(localFilePath);
      }

      // Create Report Model
      final report = Report(
        id: const Uuid().v4(),
        fileName: fileName,
        fileUrl: localFilePath,
        type: fileExtension.toUpperCase() == 'PDF' ? 'PDF' : 'IMAGE',
        uploadTimestamp: DateTime.now(),
      );

      // Save to Hive
      final box = Hive.box<Report>('reportsBox');
      await box.put(report.id, report);

      await fetchReports();
      return true;
    } catch (e) {
      debugPrint('Error uploading report locally: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
