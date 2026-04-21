import 'package:hive/hive.dart';

part 'appointment.g.dart';

@HiveType(typeId: 2)
class Appointment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String doctorName;

  @HiveField(2)
  final String specialization;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final String status;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.status,
  });
}
