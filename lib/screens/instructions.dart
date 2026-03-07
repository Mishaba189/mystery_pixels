import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class Instructions extends StatelessWidget {
  const Instructions({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 500,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Title
                Center(
                  child: Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Bullet Points
                _buildBullet(
                    "തന്നിരിക്കുന്ന hint വെച്ച് എന്താണ് ചിത്രത്തിൽ ഉള്ളത് എന്ന് ഗസ് ചെയ്ത് എഴുതുക."),
                _buildBullet(
                    "നിങ്ങളുടെ ഉത്തരം ശരിയാണെങ്കിൽ ഫുൾ മാർക്ക് ലഭിക്കും."),
                _buildBullet(
                    "തെറ്റാണെങ്കിൽ മാസ്ക് ചെയ്ത പിക്ചറിന്റെ ഒരു ഭാഗം unhide ചെയ്യും."),
                _buildBullet(
                    "വീണ്ടും ഗസ് ചെയ്യാൻ അവസരം ഉണ്ടാകും."),
                _buildBullet(
                    "പിക്ചർ മുഴുവൻ unhide ചെയ്യുന്നത് വരെ ഉത്തരം ഗസ് ചെയ്യാം."),
                _buildBullet(
                    "ഓരോ തെറ്റായ ഉത്തരത്തിനും പോയിന്റ് കുറയും."),
                _buildBullet(
                    "നിങ്ങളുടെ ഉത്തരങ്ങൾ English ൽ ടൈപ്പ് ചെയ്യാൻ ശ്രദ്ധിക്കുക"),

                const SizedBox(height: 30),

                /// Start Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/game');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 3,
                    ),
                    child: playerProvider.isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Start Game",
                      style: TextStyle(
                        fontSize: 16,
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

    );
  }
}

Widget _buildBullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "• ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}
