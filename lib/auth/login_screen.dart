import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import 'signup_screen.dart';
import '../app_customer/customer_main_navigation_screen.dart';
import '../app_driver/driver_main_navigation_screen.dart';
import 'driver_registration_screen.dart';
import 'pending_approval_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isDriver = false;
  bool _isPasswordObscured = true;
  
  // NOTE: This is a mock variable to test the smart routing.
  // In production, this will be fetched from Firebase Firestore.
  final String _mockDriverStatus = 'pending'; // Change to 'incomplete' or 'approved' to test

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_isDriver) {
      // Smart Routing for Driver
      switch (_mockDriverStatus) {
        case 'incomplete':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DriverRegistrationScreen()),
          );
          break;
        case 'pending':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PendingApprovalScreen()),
          );
          break;
        case 'approved':
        default:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DriverMainNavigationScreen()),
          );
          break;
      }
    } else {
      // Passenger simply goes to their map
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
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
              const SizedBox(height: 60),
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
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Sign in to your account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildRoleToggle(),
              const SizedBox(height: 32),
              _buildPhoneField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _handleLogin,
                child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?', style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen(initialIsDriver: _isDriver)),
                      );
                    },
                    child: const Text('Sign Up', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone_android, color: AppColors.primary),
        prefixText: '+265 ', // Malawi country code
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
