import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_theme.dart';
import '../widgets/app_loading_button.dart';
import '../widgets/app_text_form_field.dart';
import '../widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        context.goNamed('home');
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
          height: MediaQuery.sizeOf(context).height,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const AuthHeader(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to your account',
                ),
                const SizedBox(height: AppSpacing.xl),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      const SizedBox(height: AppSpacing.lg),

                      // Login Button
                      Obx(
                        () => AppLoadingButton(
                          label: 'Login',
                          isLoading: authController.isLoading.value,
                          onPressed:
                              authController.isLoading.value ? null : _handleLogin,
                          backgroundColor: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.goNamed('register'),
                            child: const Text(
                              'Register',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
