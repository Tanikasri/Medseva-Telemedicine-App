import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/auth_provider.dart';
import 'features/reports/report_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/health_dashboard.dart';
import 'features/scanner/ocr_scanner_screen.dart';
import 'features/auth/register_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/main_shell.dart';
import 'features/reports/ui/report_list_screen.dart';
import 'features/analytics/health_analytics_screen.dart';
import 'features/doctors/doctor_list_screen.dart';
import 'features/analytics/health_summary_provider.dart';
import 'features/doctors/appointment_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/report.dart';
import 'core/models/health_summary.dart';
import 'core/models/appointment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ReportAdapter());
  Hive.registerAdapter(HealthSummaryAdapter());
  Hive.registerAdapter(AppointmentAdapter());

  await Hive.openBox<Report>('reportsBox');
  await Hive.openBox<HealthSummary>('healthSummaryBox');
  await Hive.openBox<Appointment>('appointmentsBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => HealthSummaryProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: MedSevaApp(),
    ),
  );
}

class MedSevaApp extends StatelessWidget {
  const MedSevaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedSeva Telemedicine',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainShell(),
        '/dashboard': (context) => HealthDashboard(),
        '/scanner': (context) => OcrScannerScreen(),
        '/reports': (context) => ReportListScreen(),
        '/analytics': (context) => HealthAnalyticsScreen(),
        '/doctors': (context) => DoctorListScreen(),
      },
    );
  }
}
