import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/driver_main_navigation_screen.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Driver Registration', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            // Show mocked loading
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );

            // Simulate network processing and auto-approval
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop(); // dismiss loading
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DriverMainNavigationScreen()),
              );
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.of(context).pop();
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 3 ? 'Submit Application' : 'Continue', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppColors.textSecondary),
                      ),
                      onPressed: details.onStepCancel,
                      child: const Text('Back', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Basic Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Column(
              children: [
                const SizedBox(height: 12),
                _buildTextField('Full Name (As on ID)', Icons.person),
                const SizedBox(height: 16),
                _buildTextField('Phone Number', Icons.phone),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Legal Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Text('Provide clear photos of the following:', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                _buildUploadButton('Front & Back of National ID', Icons.badge),
                const SizedBox(height: 12),
                _buildUploadButton('Driver\'s License', Icons.card_membership),
                const SizedBox(height: 12),
                _buildUploadButton('Take a Selfie (Live)', Icons.camera_front),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Column(
              children: [
                const SizedBox(height: 12),
                _buildTextField('Motorcycle Make & Model', Icons.motorcycle),
                const SizedBox(height: 16),
                _buildTextField('License Plate Number', Icons.pin),
                const SizedBox(height: 16),
                _buildUploadButton('Photo of Bike (Showing Plate)', Icons.camera_alt),
              ],
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Safety & Payments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                _buildUploadButton('Photo of Passenger Helmet', Icons.security),
                const SizedBox(height: 16),
                _buildTextField('Mobile Money Number', Icons.account_balance_wallet),
              ],
            ),
            isActive: _currentStep >= 3,
            state: _currentStep == 3 ? StepState.editing : StepState.complete,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildUploadButton(String label, IconData icon) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        alignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera opening...')));
      },
      icon: Icon(icon, color: AppColors.primary),
      label: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
    );
  }
}
