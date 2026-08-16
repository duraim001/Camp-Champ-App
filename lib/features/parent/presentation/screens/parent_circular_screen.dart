import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'parent_fee_payment_screen.dart';

class ParentCircularScreen extends StatelessWidget {
  const ParentCircularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A. FEE PAYMENT REMINDER (CRITICAL BANNER)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.payments_rounded, color: AppColors.gold, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'FEE PAYMENT REMINDER',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.redAccent),
                        ),
                        child: const Text(
                          'DUE 30 SEP 2026',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Semester 5 Tuition Fee Balance: ₹15,000',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Kindly complete the pending fee payment before the due date to avoid late clearance processing.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ParentFeePaymentScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primaryPurple, size: 18),
                      label: const Text(
                        'PAY FEES NOW (₹15,000)',
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // B. PARENT-TEACHER MEETING REMINDER
            const Text(
              'PARENT – TEACHER MEETINGS',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Semester 5 Academic Progress Meet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'CONFIRMED',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.secondaryText),
                        SizedBox(width: 6),
                        Text('Date: 20 September 2026', style: TextStyle(fontSize: 12, color: AppColors.darkText)),
                        SizedBox(width: 14),
                        Icon(Icons.access_time_rounded, size: 16, color: AppColors.secondaryText),
                        SizedBox(width: 6),
                        Text('10:00 AM – 1:00 PM', style: TextStyle(fontSize: 12, color: AppColors.darkText)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: AppColors.secondaryText),
                        SizedBox(width: 6),
                        Text('Venue: Main Auditorium • Campus Block A', style: TextStyle(fontSize: 12, color: AppColors.darkText)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // C. COLLEGE HOLIDAYS & LEAVE CIRCULARS
            const Text(
              'COLLEGE HOLIDAYS & NOTICES',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            _buildCircularTile(
              title: 'Independence Day Holiday Announcement',
              date: '15 August 2026',
              category: 'College Holiday',
              description: 'College will remain closed on 15th August 2026 on account of Independence Day. Flag hoisting ceremony at 8:30 AM.',
              icon: Icons.event_busy_rounded,
              color: Colors.orange.shade800,
            ),
            const SizedBox(height: 10),
            _buildCircularTile(
              title: 'Heavy Rain Precautionary Holiday',
              date: '02 August 2026',
              category: 'Advisory Notice',
              description: 'As per District Collector directive, classes suspended due to heavy rain forecast.',
              icon: Icons.umbrella_rounded,
              color: Colors.blue.shade800,
            ),
            const SizedBox(height: 20),

            // D. UPCOMING COLLEGE FUNCTIONS & EVENTS
            const Text(
              'UPCOMING COLLEGE FUNCTIONS',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            _buildCircularTile(
              title: 'Annual Sports Day Meet 2026',
              date: '28 September 2026',
              category: 'College Function',
              description: 'Inter-Department Athletics meet at College Sports Complex. Parents are cordially invited.',
              icon: Icons.emoji_events_rounded,
              color: AppColors.primaryPurple,
            ),
            const SizedBox(height: 10),
            _buildCircularTile(
              title: 'Camp Champ Cultural Fest & Graduation',
              date: '15 October 2026',
              category: 'Annual Event',
              description: 'Grand Annual Cultural extravaganza and Convocation ceremony.',
              icon: Icons.celebration_rounded,
              color: AppColors.primaryPurple,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularTile({
    required String title,
    required String date,
    required String category,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category: $category',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: AppColors.darkText, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}
