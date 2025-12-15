import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final authController = Get.find<AuthController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 64,
                    color: Colors.pink,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  /// EMAIL
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// PASSWORD
                  Obx(() {
                    return TextField(
                      controller: passwordController,
                      obscureText: isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => isPasswordHidden.toggle(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  /// CONFIRM PASSWORD
                  Obx(() {
                    return TextField(
                      controller: confirmPasswordController,
                      obscureText: isConfirmPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => isConfirmPasswordHidden.toggle(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 32),

                  /// REGISTER BUTTON
                  Obx(() {
                    return authController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                final email = emailController.text.trim();
                                final pass = passwordController.text.trim();
                                final confirmPass = confirmPasswordController
                                    .text
                                    .trim();

                                if (email.isEmpty || pass.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Email dan password wajib diisi',
                                  );
                                  return;
                                }

                                if (pass != confirmPass) {
                                  Get.snackbar('Error', 'Password tidak sama');
                                  return;
                                }

                                authController.register(email, pass);
                              },
                              child: const Text(
                                'REGISTER',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                  }),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Get.offNamed(Routes.LOGIN),
                    child: const Text(
                      "Sudah punya akun? Login",
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
