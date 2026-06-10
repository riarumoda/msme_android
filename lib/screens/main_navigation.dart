// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import 'notification_page.dart'; // Import halaman notifikasi

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2; // Default ke Notifikasi

  final List<Widget> _pages = [
    const Center(child: Text('Halaman Dashboard')),
    const Center(child: Text('Halaman Barang')),
    const NotificationPage(), // Menggunakan widget dari notification_page.dart
    const Center(child: Text('Halaman Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 10,
        indicatorColor: Colors.indigo.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Colors.indigo),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: Colors.indigo),
            label: 'Barang',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              label: Text('3'),
              child: Icon(Icons.notifications, color: Colors.indigo),
            ),
            label: 'Notifikasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Colors.indigo),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
