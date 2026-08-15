import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TripsHistoryScreen extends StatelessWidget {
  const TripsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('My Trips', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Today, 14:30', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                            Text('MK ${1500 + (index * 500)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                        const Divider(height: 24),
                        const Row(
                          children: [
                            Icon(Icons.circle, size: 12, color: AppColors.secondary),
                            SizedBox(width: 12),
                            Expanded(child: Text('Nkhotakota Boma', style: TextStyle(fontWeight: FontWeight.w600))),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0, top: 2, bottom: 2),
                          child: SizedBox(height: 16, child: VerticalDivider(color: Colors.grey, thickness: 1.5)),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: AppColors.primary),
                            SizedBox(width: 8),
                            Expanded(child: Text('Sani Pottery Lodge', style: TextStyle(fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
