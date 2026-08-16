import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/college_branding.dart';
import '../widgets/curved_footer_painter.dart';
import '../widgets/curved_header_painter.dart';
import '../widgets/decorative_divider.dart';
import '../widgets/feature_value_item.dart';
import '../widgets/get_started_button.dart';

/// WelcomeScreen renders Step 1 onboarding screen for Camp Champ app.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navigateToLoginSelection() {
    Navigator.pushNamed(context, AppRoutes.loginSelection);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // White icons for dark purple header
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primaryPurple, // Solid primary purple behind status bar & edges
        body: Stack(
          children: [
            // Central White Content Region Container with subtle building background image
            Positioned.fill(
              child: Container(
                color: AppColors.lightBackground,
                child: Opacity(
                  opacity: 0.16, // 16% visible intensity for subtle background
                  child: Image.asset(
                    'assets/images/sengunthar_building.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),

            // Main Vertically Scrollable Content Body
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Sleek, proportional Top Dark Purple Curved Header
                    const CurvedHeaderWidget(height: 70),
                    const SizedBox(height: 4),

                    // Animated Fade and Slide Body Content
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: [
                              // AI-POWERED Subtitle
                              const Text(
                                'AI-POWERED',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 3.0,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Main Prominent Application Title: Camp Champ
                              const Text(
                                'Camp Champ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.primaryPurple,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Supporting System Title
                              const Text(
                                'Smart College Management System',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondaryPurple,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Refined Gold Decorative Divider
                              const DecorativeDivider(width: 170),
                              const SizedBox(height: 12),

                              // Tagline
                              const Text(
                                'One Campus, One Platform, One Connection',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondaryPurple,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Institutional College Emblem Branding
                              const CollegeBranding(),
                              const SizedBox(height: 24),

                              // Feature Value Indicators: SECURE | SMART | INTELLIGENT
                              const FeatureValuesRow(),

                              // Bottom Spacing to ensure content is fully scrollable above elevated button & footer
                              const SizedBox(height: 160),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Section: Purple Curved Footer
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CurvedFooterWidget(
                height: 95,
                text: 'Empowering Education with AI',
              ),
            ),

            // Primary GET STARTED Action Button
            Positioned(
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom > 0
                  ? MediaQuery.of(context).padding.bottom + 95
                  : 100,
              child: GetStartedButton(
                onPressed: _navigateToLoginSelection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
