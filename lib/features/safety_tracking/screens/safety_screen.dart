import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield, size: 100, color: AppColors.error),
            const SizedBox(height: 24),
            const Text(
              'Safety First',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'If you feel unsafe during a ride, you can immediately alert your trusted contacts or local authorities.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
              ),
              icon: const Icon(Icons.warning, color: Colors.white),
              label: const Text('TRIGGER SOS ALERT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
              ),
              icon: const Icon(Icons.share_location, color: AppColors.primary),
              label: const Text('Share Ride with Contact', style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
