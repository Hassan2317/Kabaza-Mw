import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  bool _isBooking = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Mock Map Background
        Container(
          color: Colors.grey.shade200,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 80, color: Colors.blueGrey.shade300),
                    const SizedBox(height: 16),
                    Text('Map centered on Nkhotakota Boma', style: TextStyle(color: Colors.blueGrey.shade600, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              // Dummy Driver Pins
              const Positioned(top: 100, left: 80, child: Icon(Icons.two_wheeler, color: AppColors.primary, size: 36)),
              const Positioned(top: 250, right: 60, child: Icon(Icons.two_wheeler, color: AppColors.primary, size: 36)),
              const Positioned(bottom: 350, left: 150, child: Icon(Icons.two_wheeler, color: AppColors.primary, size: 36)),
            ],
          ),
        ),
        
        // 2. Safety Shield FAB
        Positioned(
          top: 20,
          right: 20,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: AppColors.error,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Safety tools opened!')));
            },
            child: const Icon(Icons.shield, color: Colors.white),
          ),
        ),

        // 3. Bottom Sheet (Where to? OR Booking Confirmation)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: 0,
          left: 0,
          right: 0,
          child: _isBooking ? _buildFareEstimateCard() : _buildWhereToCard(),
        ),
      ],
    );
  }

  Widget _buildWhereToCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Ready for a ride?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          const SizedBox(height: 16),
          // Search Bar Mock
          InkWell(
            onTap: () {
              setState(() => _isBooking = true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('Where to in Nkhotakota?', style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Recent Locations
          _buildRecentLocationTile(Icons.home, 'Home', 'Sitima, Nkhotakota'),
          const Divider(),
          _buildRecentLocationTile(Icons.work, 'Nkhotakota Pottery Lodge', 'Sani, Nkhotakota'),
          const Divider(),
          _buildRecentLocationTile(Icons.history, 'Ilala Gap', 'Lake Malawi Shore'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFareEstimateCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ride Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () {
                  setState(() => _isBooking = false);
                },
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(16),
              color: AppColors.primary.withOpacity(0.05),
            ),
            child: const Row(
              children: [
                Icon(Icons.two_wheeler, size: 40, color: AppColors.primary),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Standard Kabaza', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('4 mins away', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Text('MK 1,500', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.secondary)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: AppColors.success),
              const SizedBox(width: 8),
              const Text('Payment: ', style: TextStyle(color: AppColors.textSecondary)),
              const Text('Cash', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Change', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)))
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Finding a Kabaza driver nearby...')));
            },
            child: const Text('CONFIRM KABAZA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRecentLocationTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade100,
        child: Icon(icon, color: AppColors.secondary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      onTap: () {
        setState(() => _isBooking = true);
      },
    );
  }
}
