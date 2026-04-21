import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'appointment_provider.dart';
import '../../core/models/appointment.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  final List<Map<String, dynamic>> doctors = const [
    {
      "name": "Dr. Sarah Johnson",
      "specialization": "Cardiologist",
      "experience": "12 years",
      "rating": 4.9,
    },
    {
      "name": "Dr. Michael Chen",
      "specialization": "Dermatologist",
      "experience": "8 years",
      "rating": 4.7,
    },
    {
      "name": "Dr. Emily Brown",
      "specialization": "Neurologist",
      "experience": "15 years",
      "rating": 4.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                return _buildDoctorCard(context, doctors[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search specialists...",
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryDark),
          fillColor: Colors.white.withAlpha(150),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.accent.withAlpha(100),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.person, size: 40, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(doctor['specialization'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(doctor['rating'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 12),
                      const Icon(Icons.history_edu_rounded, color: AppColors.primaryDark, size: 14),
                      const SizedBox(width: 4),
                      Text(doctor['experience'], style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 40),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingDetailsScreen(doctor: doctor)),
              ),
              child: const Text("BOOK", style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  const BookingDetailsScreen({super.key, required this.doctor});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  final List<String> times = ["09:00 AM", "10:30 AM", "01:00 PM", "03:30 PM", "05:00 PM", "06:30 PM"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text("Schedule Visit")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorProfile(),
              const SizedBox(height: 32),
              const Text("Select Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 32),
              const Text("Select Time Slot", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTimeGrid(),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _selectedTimeIndex == -1 ? null : () async {
                  final provider = Provider.of<AppointmentProvider>(context, listen: false);
                  final selectedDate = DateTime.now().add(Duration(days: _selectedDateIndex));
                  
                  final newAppointment = Appointment(
                    id: const Uuid().v4(),
                    doctorName: widget.doctor['name'],
                    specialization: widget.doctor['specialization'],
                    date: selectedDate,
                    time: times[_selectedTimeIndex],
                    status: 'CONFIRMED'
                  );
                  
                  await provider.bookAppointment(newAppointment);

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Success! Appointment confirmed with ${widget.doctor['name']}"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text("CONFIRM BOOKING"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorProfile() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: AppColors.accent.withAlpha(100), borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.person, size: 50, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctor['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(widget.doctor['specialization'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          bool isSelected = index == _selectedDateIndex;
          final date = DateTime.now().add(Duration(days: index));
          return GestureDetector(
            onTap: () => setState(() => _selectedDateIndex = index),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.pureWhite : Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? Border.all(color: AppColors.primaryDark, width: 2) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_getMonth(date.month), style: TextStyle(color: isSelected ? AppColors.primaryDark : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(date.day.toString(), style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getMonth(int m) => ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"][m - 1];

  Widget _buildTimeGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: times.asMap().entries.map((entry) {
        int idx = entry.key;
        String time = entry.value;
        bool isSelected = idx == _selectedTimeIndex;
        
        return GestureDetector(
          onTap: () => setState(() => _selectedTimeIndex = idx),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryDark : Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? Colors.white : AppColors.textPrimary)),
          ),
        );
      }).toList(),
    );
  }
}
