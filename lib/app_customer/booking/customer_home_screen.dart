import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ride_booking_provider.dart';
import '../../core/theme/app_colors.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(rideBookingProvider);

    return Stack(
      children: [
        // 1. Mock Map Background
        _buildMapMockup(bookingState.status),
        
        // 2. Safety Shield FAB (Hidden during active ride for space, but usually present)
        if (bookingState.status != RideStatus.active && bookingState.status != RideStatus.searching)
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

        // 3. Dynamic Bottom Sheet
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomSheet(bookingState),
        ),
      ],
    );
  }

  Widget _buildMapMockup(RideStatus status) {
    return Container(
      color: Colors.grey.shade200, // Usually Google Map widget here
      child: Stack(
        children: [
          // Simulated map grid styling
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(),
            ),
          ),
          // Center Marker
          if (status == RideStatus.idle || status == RideStatus.selecting)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.location_on, size: 50, color: status == RideStatus.selecting ? AppColors.success : AppColors.primary),
                   const SizedBox(height: 8),
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                     decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20)),
                     child: Text(status == RideStatus.selecting ? 'Drop-off' : 'Pickup Location', style: const TextStyle(color: Colors.white, fontSize: 12)),
                   )
                ],
              ),
            ),
          
          // Simulated Route Line
          if (status == RideStatus.selecting || status == RideStatus.active)
             Center(
               child: Container(
                 width: 4,
                 height: 150,
                 color: AppColors.primary.withOpacity(0.5),
               ),
             ),

          // Driver pins
          if (status == RideStatus.idle || status == RideStatus.selecting) ...[
            const Positioned(top: 100, left: 80, child: Icon(Icons.two_wheeler, color: AppColors.primary, size: 36)),
            const Positioned(top: 250, right: 60, child: Icon(Icons.two_wheeler, color: AppColors.primary, size: 36)),
            const Positioned(bottom: 350, left: 150, child: Icon(Icons.two_wheeler, color: AppColors.primary, size: 36)),
          ],

          if (status == RideStatus.active) ...[
            // Active driver approaching
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.4,
              child: const Icon(Icons.two_wheeler, color: AppColors.primary, size: 48),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomSheet(RideBookingState state) {
    switch (state.status) {
      case RideStatus.idle:
        return _buildWhereToCard();
      case RideStatus.selecting:
        return _buildFareEstimateCard(state);
      case RideStatus.searching:
        return _buildSearchingCard();
      case RideStatus.active:
        return _buildActiveRideCard(state);
    }
  }

  Widget _buildWhereToCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Ready for a ride?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              ref.read(rideBookingProvider.notifier).initiateBooking('University Campus');
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
                  Text('Where to in Malawi?', style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickChip(Icons.home, 'Home'),
              _buildQuickChip(Icons.work, 'Work'),
              _buildQuickChip(Icons.school, 'University'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          _buildRecentLocationTile(Icons.history, 'City Mall', 'Lilongwe'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildQuickChip(IconData icon, String label) {
    return GestureDetector(
      onTap: () => ref.read(rideBookingProvider.notifier).initiateBooking(label),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 26,
            child: Icon(icon, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFareEstimateCard(RideBookingState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))
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
                onPressed: () => ref.read(rideBookingProvider.notifier).cancelBooking(),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(16),
              color: AppColors.primary.withOpacity(0.05),
            ),
            child: Row(
              children: [
                const Icon(Icons.two_wheeler, size: 40, color: AppColors.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.destination ?? 'Destination', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      const Text('Standard Kabaza • 4 mins away', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                Text('MK ${state.estimatedFare}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.secondary)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              ref.read(rideBookingProvider.notifier).confirmRide();
            },
            child: const Text('CONFIRM RIDE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSearchingCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 24),
          const Text('Connecting you to a driver...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => ref.read(rideBookingProvider.notifier).cancelBooking(),
            child: const Text('Cancel Request', style: TextStyle(color: AppColors.error, fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildActiveRideCard(RideBookingState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Driver arriving info
          Center(
            child: Text('Driver arriving in 2 mins', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 35, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.driverName ?? 'Driver Name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('${state.motorcycleModel} • ${state.licensePlate}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
              // Safety PIN Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text('PIN', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                    Text(state.safetyPin ?? '----', style: const TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  icon: const Icon(Icons.call, color: AppColors.primary),
                  label: const Text('Call', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  icon: const Icon(Icons.message, color: AppColors.primary),
                  label: const Text('Message', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
             child: TextButton(
                onPressed: () => ref.read(rideBookingProvider.notifier).cancelBooking(),
                child: const Text('Cancel Ride', style: TextStyle(color: AppColors.error)),
             ),
          ),
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
        ref.read(rideBookingProvider.notifier).initiateBooking(title);
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
