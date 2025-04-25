import 'dart:async';
import 'package:flutter/material.dart';

class InvestmentPlanCard extends StatefulWidget {
  const InvestmentPlanCard({super.key});

  @override
  _InvestmentPlanCardState createState() => _InvestmentPlanCardState();
}

class _InvestmentPlanCardState extends State<InvestmentPlanCard> {
  double investedAmount = 10000;
  Duration remainingTime = const Duration(days: 13, hours: 22, minutes: 39, seconds: 17);
  Timer? investmentTimer;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();

    investmentTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        investedAmount += 100;
      });
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    investmentTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  String formatTime(Duration duration) {
    return "${duration.inDays}days ${duration.inHours % 24}hours ${duration.inMinutes % 60}minutes ${duration.inSeconds % 60}sec";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity, // Fixed width
        height: 300, // Fixed height
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF4A261), Color(0xFF2A9D8F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            const Text(
              "Investment Plan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            // Investment Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Investment Amount Box
                Container(
                  width: 80,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "KES 60,000",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Investment Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Plan", "Quicktrade"),
                      _buildDetailRow("Invested", "KES ${investedAmount.toStringAsFixed(0)}"),
                      _buildStatusRow("Matured"),
                    ],
                  ),
                ),
              ],
            ),

            // Countdown Timer
            Center(
              child: Text(
                formatTime(remainingTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Status", style: TextStyle(color: Colors.white70, fontSize: 12)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
