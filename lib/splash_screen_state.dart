import 'package:flutter/material.dart';

// Splash screen at the start of the app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = false;
  bool _showText = false;
  bool _showSubtext = false;

  @override
  void initState() {
    super.initState();
    _animateSequence();
  }

  Future<void> _animateSequence() async {
    // Wait for initial logo display
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _showLogo = true;
      });
    }
    // Wait for logo to appear then show text
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      setState(() {
        _showLogo = false;
        _showText = true;
      });

      // Wait for text to appear then show subtext
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          _showSubtext = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define subtext font styles
    TextStyle capitalLettersStyle = TextStyle(
      color: Color(0xFFA51930),
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Arial',
    );
    TextStyle normalLettersStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      fontFamily: 'Arial',
    );

    // Return the main scaffold
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main text "ELEVATE"
            Positioned(
              top: 105,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: _showText ? 1.0 : 0.0),
                duration: const Duration(seconds: 1),
                // Fade in the text
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: const Text(
                      'ELEVATE',
                      style: TextStyle(
                        color: Color(0xFFA51930),
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  );
                },
              ),
            ),
            // Subtext (Name explanation)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _showSubtext ? 60.0 : 100.0),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: _showSubtext ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 1500),
                    // Fade in the subtext
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          // Style the subtext with different styles for capital and normal letters
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'E', style: capitalLettersStyle),
                                TextSpan(
                                  text: 'gyptian ',
                                  style: normalLettersStyle,
                                ),
                                TextSpan(text: 'L', style: capitalLettersStyle),
                                TextSpan(
                                  text: 'ocal ',
                                  style: normalLettersStyle,
                                ),
                                TextSpan(text: 'E', style: capitalLettersStyle),
                                TextSpan(
                                  text: '-commerce ',
                                  style: normalLettersStyle,
                                ),
                                TextSpan(text: 'V', style: capitalLettersStyle),
                                TextSpan(
                                  text: 'isualization \nand\n ',
                                  style: normalLettersStyle,
                                ),
                                TextSpan(text: 'A', style: capitalLettersStyle),
                                TextSpan(
                                  text: 'ugmented ',
                                  style: normalLettersStyle,
                                ),
                                TextSpan(text: 'T', style: capitalLettersStyle),
                                TextSpan(
                                  text: 'echnology ',
                                  style: normalLettersStyle,
                                ),
                                TextSpan(text: 'E', style: capitalLettersStyle),
                                TextSpan(
                                  text: 'xperience\n',
                                  style: normalLettersStyle,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            // Logo with fade in/out
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _showLogo ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 1500),
              // Fade in the logo
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    'assets/elevate.png',
                    height: 275,
                    width: 275,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
