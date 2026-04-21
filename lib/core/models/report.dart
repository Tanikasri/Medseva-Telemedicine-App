import 'package:hive/hive.dart';

part 'report.g.dart';

@HiveType(typeId: 0)
class Report extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fileName;

  @HiveField(2)
  final String fileUrl; // Local file path

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String? extractedText;

  @HiveField(5)
  final String? summary;

  @HiveField(6)
  final DateTime uploadTimestamp;

  Report({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.type,
    this.extractedText,
    this.summary,
    required this.uploadTimestamp,
  });
}
