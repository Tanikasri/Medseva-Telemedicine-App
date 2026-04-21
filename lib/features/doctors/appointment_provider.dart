import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/models/appointment.dart';

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];
  bool _isLoading = false;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;

  AppointmentProvider() {
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box<Appointment>('appointmentsBox');
      _appointments = box.values.toList().cast<Appointment>();
      _appointments.sort((a, b) => a.date.compareTo(b.date)); // Sort by upcoming
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> bookAppointment(Appointment appointment) async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box<Appointment>('appointmentsBox');
      await box.put(appointment.id, appointment);
      await fetchAppointments();
    } catch (e) {
      debugPrint('Error booking appointment: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
