import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../app_customer/customer_main_navigation_screen.dart';
import 'driver_registration_screen.dart';

class SignupScreen extends StatefulWidget {
  final bool initialIsDriver;
  const SignupScreen({super.key, this.initialIsDriver = false});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late bool _isDriver;
  bool _isPasswordObscured = true;
  
  @override
  void initState() {
    super.initState();
    _isDriver = widget.initialIsDriver;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_isDriver) {
      // Driver hasn't uploaded docs, so implicitly they are 'incomplete'
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DriverRegistrationScreen()),
        (route) => false,
      );
    } else {
      // Passengers bypass document verification
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Kabaza',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Create an Account',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Join us to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildRoleToggle(),
              const SizedBox(height: 32),
              _buildTextField('Full Name', Icons.person_outline, _nameController),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _handleSignup,
                child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?', style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Login', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildRoleToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isDriver = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isDriver ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Passenger',
                    style: TextStyle(
                      color: !_isDriver ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isDriver = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isDriver ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Driver',
                    style: TextStyle(
                      color: _isDriver ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
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

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone_android, color: AppColors.primary),
        prefixText: '+265 ',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
