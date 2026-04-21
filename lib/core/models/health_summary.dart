import 'package:hive/hive.dart';

part 'health_summary.g.dart';

@HiveType(typeId: 1)
class HealthSummary extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int healthScore;

  @HiveField(2)
  final String summary;

  @HiveField(3)
  final DateTime analyzedAt;

  HealthSummary({
    required this.id,
    required this.healthScore,
    required this.summary,
    required this.analyzedAt,
  });
}
