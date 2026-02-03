import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Find a Tutor'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('My Sessions'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
