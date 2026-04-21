import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildItem(context, Icons.person_outline, "My Profile", "/profile"),
          _buildItem(context, Icons.upload_file_outlined, "Upload Reports", "/reports"),
          _buildItem(context, Icons.document_scanner_outlined, "Scan Documents", "/scanner"),
          _buildItem(context, Icons.analytics_outlined, "Health Analytics", "/analytics"),
          _buildItem(context, Icons.calendar_month_outlined, "Doctor Booking", "/doctors"),
          const Spacer(),
          const Divider(),
          _buildItem(context, Icons.logout_rounded, "Logout", "/login", isLogout: true),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primaryDark, size: 40),
          ),
          SizedBox(height: 16),
          Text(
            "Tanika Gupta",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "tanika@medseva.com",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title, String route, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.redAccent : AppColors.primaryDark),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (isLogout || route == "/profile") {
          Navigator.pushReplacementNamed(context, route);
        } else {
          // Navigation logic for main sections
          // This depends on how MainShell is set up. 
          // For MVP, we'll push them to the specific screen.
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
