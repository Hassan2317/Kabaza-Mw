import 'package:flutter/material.dart';
import '../../features/safety_tracking/screens/safety_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../theme/app_colors.dart';

class DriverMainNavigationScreen extends StatefulWidget {
  const DriverMainNavigationScreen({super.key});

  @override
  State<DriverMainNavigationScreen> createState() => _DriverMainNavigationScreenState();
}

class _DriverMainNavigationScreenState extends State<DriverMainNavigationScreen> {
  int _selectedIndex = 0;
  bool _isOnline = false;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _updateScreens();
  }

  void _updateScreens() {
    _screens = [
      _buildHomeMapTab(),
      const Center(child: Text('Earnings Dashboard', style: TextStyle(fontSize: 24))),
      const SafetyScreen(),
      const ProfileScreen(),
    ];
  }

  Widget _buildHomeMapTab() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: AppColors.success.withOpacity(0.1),
          child: const Text(
            'Demo Mode: Application Auto-Approved',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Mock Map Background
              Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('Map View Placeholder', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              // Status Indicator
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isOnline ? Icons.sensors : Icons.sensors_off,
                          color: _isOnline ? AppColors.success : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isOnline ? 'Online - Finding rides...' : 'Offline - You are not visible',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isOnline ? AppColors.success : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Go Online Button
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: _isOnline ? AppColors.error : AppColors.primary,
                    shadowColor: (_isOnline ? AppColors.error : AppColors.primary).withOpacity(0.5),
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    setState(() {
                      _isOnline = !_isOnline;
                      _updateScreens();
                    });
                  },
                  child: Text(
                    _isOnline ? 'GO OFFLINE' : 'GO ONLINE',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kabaza Driver', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // Prevents back button after replacement
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.two_wheeler_outlined),
            selectedIcon: Icon(Icons.two_wheeler),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Safety',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
