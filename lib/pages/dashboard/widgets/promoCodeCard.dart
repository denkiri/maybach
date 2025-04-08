import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PromoCodeCard extends StatelessWidget {
  final String promoCode ;
  final String inviter ;

  const PromoCodeCard({super.key, required this.promoCode, required this.inviter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF14B66C), // Green background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Promo Code Title + Badge)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Promo Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E8052), // Darker green badge
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Invited by $inviter",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Divider
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.4),
            ),

            const SizedBox(height: 12),

            // Promo Code Bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF53C79B), // Lighter green for promo bar
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  // Promo Code Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      promoCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Copy Button
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: 'https://denkiri.github.io/login?promo=$promoCode'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Copied: $promoCode")),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.copy,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
