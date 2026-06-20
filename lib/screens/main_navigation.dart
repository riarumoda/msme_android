// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import '../services/notification_service.dart';
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
  void initState() {
    super.initState();
    NotificationService.instance.updateUnreadCount();
  }

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
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Colors.indigo),
            label: 'Dashboard',
          ),
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: Colors.indigo),
            label: 'Barang',
          ),
          NavigationDestination(
            icon: ValueListenableBuilder<int>(
              valueListenable: NotificationService.instance.unreadCount,
              builder: (context, count, child) {
                final icon = const Icon(Icons.notifications_outlined);
                return count > 0
                    ? Badge(label: Text('$count'), child: icon)
                    : icon;
              },
            ),
            selectedIcon: ValueListenableBuilder<int>(
              valueListenable: NotificationService.instance.unreadCount,
              builder: (context, count, child) {
                final icon =
                    const Icon(Icons.notifications, color: Colors.indigo);
                return count > 0
                    ? Badge(label: Text('$count'), child: icon)
                    : icon;
              },
            ),
            label: 'Notifikasi',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Colors.indigo),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
