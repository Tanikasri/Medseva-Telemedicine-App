import 'package:flutter/material.dart';
import 'app_drawer.dart';
import '../theme/app_colors.dart';
import '../../features/dashboard/home_screen.dart';
import '../../features/reports/ui/report_list_screen.dart';
import '../../features/doctors/doctor_list_screen.dart';
import '../../features/analytics/health_analytics_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ReportListScreen(),
    const HealthAnalyticsScreen(),
    const DoctorListScreen(),
  ];

  final List<String> _titles = ["MedSeva", "Medical Reports", "Health Analytics", "Book Doctors"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important for showing container gradient
        appBar: AppBar(
          title: Text(_titles[_currentIndex]),
          actions: [
            IconButton(
              onPressed: () {}, 
              icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary)
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, -5))
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryDark,
            unselectedItemColor: AppColors.textSecondary,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_max_rounded), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.folder_copy_rounded), label: "Reports"),
              BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: "Analytics"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: "Doctors"),
            ],
          ),
        ),
      ),
    );
  }
}
