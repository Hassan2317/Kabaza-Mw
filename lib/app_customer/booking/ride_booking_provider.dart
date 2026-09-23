import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

enum RideStatus { idle, selecting, searching, active }

class RideBookingState {
  final RideStatus status;
  final String? destinationName;
  final LatLng? destinationCoords;
  final int estimatedFare;
  final String? driverName;
  final String? motorcycleModel;
  final String? licensePlate;
  final String? safetyPin;

  RideBookingState({
    this.status = RideStatus.idle,
    this.destinationName,
    this.destinationCoords,
    this.estimatedFare = 0,
    this.driverName,
    this.motorcycleModel,
    this.licensePlate,
    this.safetyPin,
  });

  RideBookingState copyWith({
    RideStatus? status,
    String? destinationName,
    LatLng? destinationCoords,
    int? estimatedFare,
    String? driverName,
    String? motorcycleModel,
    String? licensePlate,
    String? safetyPin,
  }) {
    return RideBookingState(
      status: status ?? this.status,
      destinationName: destinationName ?? this.destinationName,
      destinationCoords: destinationCoords ?? this.destinationCoords,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      driverName: driverName ?? this.driverName,
      motorcycleModel: motorcycleModel ?? this.motorcycleModel,
      licensePlate: licensePlate ?? this.licensePlate,
      safetyPin: safetyPin ?? this.safetyPin,
    );
  }
}

class RideBookingNotifier extends StateNotifier<RideBookingState> {
  RideBookingNotifier() : super(RideBookingState());

  void initiateBooking(String destinationName, LatLng coords) {
    // Basic mock fare logic based on destination name
    final mockFare = 1500 + (destinationName.length * 20);
    state = state.copyWith(
      status: RideStatus.selecting,
      destinationName: destinationName,
      destinationCoords: coords,
      estimatedFare: mockFare,
    );
  }

  void confirmRide() {
    state = state.copyWith(status: RideStatus.searching);
    // Simulate finding a driver after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (state.status == RideStatus.searching) { // Only update if still searching
        state = state.copyWith(
          status: RideStatus.active,
          driverName: 'John Phiri',
          motorcycleModel: 'TVS HLX 125',
          licensePlate: 'MC 1234',
          safetyPin: '8341',
        );
      }
    });
  }

  void cancelBooking() {
    state = RideBookingState(); // Reset completely
  }
}

final rideBookingProvider = StateNotifierProvider<RideBookingNotifier, RideBookingState>((ref) {
  return RideBookingNotifier();
});
