import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_theme.dart';
import '../widgets/app_loading_button.dart';
import '../widgets/app_text_form_field.dart';
import '../widgets/auth_header.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final success = await authController.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (success && mounted) {
        context.goNamed('login');
      } else if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.errorMessage.value),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                Color.fromARGB(204, 94, 53, 177),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Header
                const AuthHeader(
                  title: 'Create Account',
                  subtitle: 'Sign up to get started',
                  topSpacing: 40,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Field
                      AppTextFormField(
                        controller: _nameController,
                        hintText: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outlined),
                        validator: AppValidations.validateName,
                        fillColor: Colors.white,
                        borderRadius: 8,
                        borderColor: Colors.transparent,
                        enabledBorderColor: Colors.transparent,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Email Field
                      AppTextFormField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidations.validateEmail,
                        fillColor: Colors.white,
                        borderRadius: 8,
                        borderColor: Colors.transparent,
                        enabledBorderColor: Colors.transparent,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Password Field
                      AppTextFormField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        obscureText: true,
                        validator: AppValidations.validatePassword,
                        fillColor: Colors.white,
                        borderRadius: 8,
                        borderColor: Colors.transparent,
                        enabledBorderColor: Colors.transparent,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Confirm Password Field
                      AppTextFormField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        fillColor: Colors.white,
                        borderRadius: 8,
                        borderColor: Colors.transparent,
                        enabledBorderColor: Colors.transparent,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Register Button
                      Obx(
                        () => AppLoadingButton(
                          label: 'Register',
                          isLoading: authController.isLoading.value,
                          onPressed: authController.isLoading.value
                              ? null
                              : _handleRegister,
                          backgroundColor: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.goNamed('login'),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
