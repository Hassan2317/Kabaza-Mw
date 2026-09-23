import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'ride_booking_provider.dart';
import 'location_search_screen.dart';
import '../../core/theme/app_colors.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  // Default coordinates generally placed in Malawi (e.g. Nkhotakota or Lilongwe)
  final LatLng _defaultLocation = const LatLng(-12.9248, 34.2962);
  final MapController _mapController = MapController();

  Future<void> _openSearchScreen() async {
    final result = await Navigator.push<LocationSearchResult>(
      context,
      MaterialPageRoute(builder: (context) => const LocationSearchScreen()),
    );

    if (result != null) {
      // Initiate booking with the real address and coordinates
      ref.read(rideBookingProvider.notifier).initiateBooking(result.displayName, result.coordinates);
      
      // Move camera to destination with some zoom
      _mapController.move(result.coordinates, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(rideBookingProvider);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Real Interactive Map
          _buildRealMap(bookingState),
          
          // 2. Safety Shield (Hidden during active ride for space)
          if (bookingState.status != RideStatus.active && bookingState.status != RideStatus.searching)
            Positioned(
              top: 20,
              right: 20,
              child: SafeArea(
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColors.error,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Safety tools opened!')));
                  },
                  child: const Icon(Icons.shield, color: Colors.white),
                ),
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
      ),
    );
  }

  Widget _buildRealMap(RideBookingState state) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _defaultLocation,
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.hassan2317.kabaza',
        ),
        MarkerLayer(
          markers: [
            // Current Location Marker (mocked static)
            Marker(
              point: _defaultLocation,
              width: 50,
              height: 50,
              child: const Icon(Icons.location_on, color: AppColors.success, size: 40),
            ),
            
            // Destination Marker (if searching/selecting)
            if ((state.status == RideStatus.selecting || state.status == RideStatus.active) && state.destinationCoords != null)
              Marker(
                point: state.destinationCoords!,
                width: 50,
                height: 50,
                child: const Icon(Icons.location_on, color: AppColors.primary, size: 40),
              ),
              
            // Example Driver rendering
            if (state.status == RideStatus.active && state.destinationCoords != null)
               Marker(
                 point: LatLng(state.destinationCoords!.latitude - 0.002, state.destinationCoords!.longitude - 0.002), // Slightly offset
                 width: 50,
                 height: 50,
                 child: const Icon(Icons.two_wheeler, color: AppColors.secondary, size: 40),
               )
          ],
        ),
        // Draw polyline if both exist
        if ((state.status == RideStatus.selecting || state.status == RideStatus.active) && state.destinationCoords != null)
          PolylineLayer(
            polylines: [
              Polyline(
                points: [_defaultLocation, state.destinationCoords!],
                color: AppColors.primary,
                strokeWidth: 4.0,
              ),
            ],
          ),
      ],
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
            onTap: _openSearchScreen,
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
              _buildQuickChip(Icons.home, 'Home', const LatLng(-12.9230, 34.2980)),
              _buildQuickChip(Icons.work, 'Work', const LatLng(-12.9210, 34.2920)),
              _buildQuickChip(Icons.school, 'University', const LatLng(-12.9300, 34.3000)),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickChip(IconData icon, String label, LatLng coords) {
    return GestureDetector(
      onTap: () {
        ref.read(rideBookingProvider.notifier).initiateBooking(label, coords);
        _mapController.move(coords, 14.0);
      },
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
    // Simplify display name if it's too long
    final displayName = state.destinationName!.split(',').first;
    
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
                onPressed: () {
                  ref.read(rideBookingProvider.notifier).cancelBooking();
                  _mapController.move(_defaultLocation, 14.0);
                },
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
                      Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
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
            onPressed: () {
              ref.read(rideBookingProvider.notifier).cancelBooking();
              _mapController.move(_defaultLocation, 14.0);
            },
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
          const Center(
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
                onPressed: () {
                  ref.read(rideBookingProvider.notifier).cancelBooking();
                  _mapController.move(_defaultLocation, 14.0);
                },
                child: const Text('Cancel Ride', style: TextStyle(color: AppColors.error)),
             ),
          ),
        ],
      ),
    );
  }
}
