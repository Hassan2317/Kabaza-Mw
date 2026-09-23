import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account Under Review'),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Hang Tight!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We have received your registration documents and they are currently under review by our admin team.\n\nYou will be notified via SMS once your driver account is approved (usually within 24 hours).',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
