import 'package:flutter/material.dart';
import 'package:mystery_pixels/screens/instructions.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';


class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "4 Day Mystery Challenge",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Enter your details to start playing",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 35),

                  buildTextField(
                    controller: nameController,
                    hint: "Full Name",
                    icon: Icons.person_outline,
                    validator: (value) =>
                    value!.isEmpty ? "Enter your name" : null,
                  ),

                  const SizedBox(height: 18),

                  buildTextField(
                    controller: placeController,
                    hint: "Place",
                    icon: Icons.location_on_outlined,
                    validator: (value) =>
                    value!.isEmpty ? "Enter your place" : null,
                  ),

                  const SizedBox(height: 18),

                  buildTextField(
                    controller: phoneController,
                    hint: "Phone Number",
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter phone number";
                      }
                      if (value.length < 10) {
                        return "Enter valid phone number";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: playerProvider.isLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {

                          await playerProvider.registerOrFetchPlayer(
                            name: nameController.text.trim(),
                            place: placeController.text.trim(),
                            phone: phoneController.text.trim(),
                          );

                          if (playerProvider.hasCompletedToday()) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("You already completed today's challenge!"),
                              ),
                            );

                          } else {

                            playerProvider.startGame();
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Instructions()));

                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 3,
                      ),
                      child: playerProvider.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF2F4F8),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
          const BorderSide(color: Colors.orangeAccent, width: 1.5),
        ),
      ),
    );
  }
}