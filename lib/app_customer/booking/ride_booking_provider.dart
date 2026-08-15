import 'package:flutter_riverpod/flutter_riverpod.dart';

// Represents the state of the ride booking flow
class RideBookingState {
  final bool isBooking;
  final String? destination;
  final int estimatedFare;

  RideBookingState({
    this.isBooking = false,
    this.destination,
    this.estimatedFare = 0,
  });

  RideBookingState copyWith({
    bool? isBooking,
    String? destination,
    int? estimatedFare,
  }) {
    return RideBookingState(
      isBooking: isBooking ?? this.isBooking,
      destination: destination ?? this.destination,
      estimatedFare: estimatedFare ?? this.estimatedFare,
    );
  }
}

class RideBookingNotifier extends StateNotifier<RideBookingState> {
  RideBookingNotifier() : super(RideBookingState());

  void initiateBooking(String destination) {
    // Determine a mock fare based on location name length for dynamic UI demonstration
    final mockFare = 1500 + (destination.length * 20);
    state = state.copyWith(
      isBooking: true,
      destination: destination,
      estimatedFare: mockFare,
    );
  }

  void cancelBooking() {
    state = state.copyWith(
      isBooking: false,
      destination: null,
      estimatedFare: 0,
    );
  }
}

// Global provider for the booking state
final rideBookingProvider = StateNotifierProvider<RideBookingNotifier, RideBookingState>((ref) {
  return RideBookingNotifier();
});
