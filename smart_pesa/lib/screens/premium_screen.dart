import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../bloc/premium/premium_bloc.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isYearlySelected = true; // Yearly is pre-selected

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PremiumCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8D5FF), // Light purple frame
        body: SafeArea(
          child: Stack(
            children: [
              // Main dark container card
              Center(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A), // Dark charcoal
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40), // Space for close button

                          // 3. Header Section: Icon + Title
                          _buildHeader(),

                          const SizedBox(height: 32),

                          // 4. Yearly Subscription (Highlighted)
                          _buildYearlyPlan(),

                          const SizedBox(height: 16),

                          // 5. Monthly Subscription
                          _buildMonthlyPlan(),

                          const SizedBox(height: 24),

                          // 6. CTA Button
                          _buildCTAButton(),

                          const SizedBox(height: 16),

                          // 7. Trial Payment Disclaimer
                          _buildDisclaimerText(),

                          const SizedBox(height: 32),

                          // 8. Footer Links
                          _buildFooterLinks(),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Top Bar - Close Button
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => context.go('/'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Header Section
  Widget _buildHeader() {
    return Row(
      children: [
        // Yellow star icon in circular background
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFF2C94C), // Yellow
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.star,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),

        // Title
        const Text(
          'Get Premium!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // 4. Yearly Subscription Plan
  Widget _buildYearlyPlan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Plan Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: "7 days trial" label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary, // Purple
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '7 days trial',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Right: "Save 55%" badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF2C94C), // Yellow
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Save 55%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Main Yearly Card (White)
        GestureDetector(
          onTap: () {
            setState(() {
              isYearlySelected = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left: Radio button + Label
                Expanded(
                  child: Row(
                    children: [
                      // Radio button
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: isYearlySelected
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),

                      // Label and Subtext
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Yearly',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Autorenewal subscription.\nCancel anytime.\nFirst payment is \$54',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Price
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '\$4.5',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' /m',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 5. Monthly Subscription Plan
  Widget _buildMonthlyPlan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Plan Header Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary, // Purple
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '7 days trial',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Main Monthly Card (Dark Gray)
        GestureDetector(
          onTap: () {
            setState(() {
              isYearlySelected = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A), // Dark gray
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[700]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Left: Radio button + Label
                Expanded(
                  child: Row(
                    children: [
                      // Radio button (unselected)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[500]!,
                            width: 2,
                          ),
                        ),
                        child: !isYearlySelected
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[500]!,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),

                      // Label and Subtext
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Monthly',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Autorenewal subscription.\nCancel anytime.\nFirst payment is \$10',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[400],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Price
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '\$10',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: ' /m',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 6. CTA Button
  Widget _buildCTAButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.primary, // Purple
        borderRadius: BorderRadius.circular(27), // Pill shape
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<PremiumCubit>().unlockPremium();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        child: const Text(
          'START A FREE TRIAL',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // 7. Trial Payment Disclaimer
  Widget _buildDisclaimerText() {
    return Text(
      isYearlySelected
          ? 'Pay \$54 after 7 days of trial'
          : 'Pay \$10 after 7 days of trial',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey[500],
      ),
    );
  }

  // 8. Footer Links
  Widget _buildFooterLinks() {
    return Column(
      children: [
        // Top row: Terms and Privacy
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Terms of Use',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Privacy policies',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),

        // Bottom row: Restore purchase (centered)
        TextButton(
          onPressed: () {},
          child: Text(
            'Restore my purchase',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

