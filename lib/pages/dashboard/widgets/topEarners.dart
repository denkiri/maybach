import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopEarnersCard extends StatelessWidget {
  final List<Map<String, String>> topEarners;

  const TopEarnersCard({super.key, required this.topEarners});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Matching WhatsApp card width
      height: 240, // Slightly taller to accommodate swiper
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Color(0xFF10101A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section similar to WhatsApp card
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: const Row(
              children: [
                Icon(Icons.leaderboard, color: Colors.white, size: 20),
                SizedBox(width: 4),
                Text(
                  "Top Earners",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Swiper section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Swiper(
                itemCount: topEarners.length,
                autoplay: true,
                itemBuilder: (context, index) {
                  final earner = topEarners[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEarnerRow(
                        icon: FontAwesomeIcons.user,
                        label: earner['user'] ?? 'Unknown',
                        isHighlighted: index == 0, // Highlight top earner
                      ),
                      const SizedBox(height: 2),
                      _buildEarnerRow(
                        icon: FontAwesomeIcons.coins,
                        label: "${earner['total_earnings'] ?? '0'} KES",
                        isHighlighted: index == 0,
                      ),
                      if (index == 0) // Trophy for top earner
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: FaIcon(
                            FontAwesomeIcons.trophy,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Footer indicator
          Container(
            height: 4,
            margin: const EdgeInsets.only(bottom: 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topEarners.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 8,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.amber : Colors.white54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnerRow({
    required IconData icon,
    required String label,
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          icon,
          color: isHighlighted ? Colors.amber : Colors.white70,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isHighlighted ? Colors.amber : Colors.white,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            fontSize: isHighlighted ? 16 : 14,
          ),
        ),
      ],
    );
  }
}