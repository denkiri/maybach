import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../viewmodel/deposit_viewmodel.dart';

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final depositViewModel = Provider.of<DepositViewModel>(context);
    
    // Controllers
    TextEditingController phoneController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "WITHDRAW WALLET BALANCE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone Number Field
                  const Text(
                    "PHONE NUMBER (MPESA REGISTERED)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "0700123456",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Amount Field
                  const Text(
                    "AMOUNT (MIN KES. 1,000)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Balance Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Text(
                      //   "BALANCE KES. 0",
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F2937),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: depositViewModel.isLoading ? null : () async {
                          String phone = phoneController.text.trim();
                          int amount = int.tryParse(amountController.text) ?? 0;

                          if (phone.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Phone number cannot be empty",
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                            );
                            return;
                          }

                          if (amount < 1000) {
                            Fluttertoast.showToast(
                              msg: "Minimum withdrawal amount is KES. 1,000",
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                            );
                            return;
                          }

                          await depositViewModel.withdraw(amount, phone);
                          
                          if (depositViewModel.responseMessage.contains("failed")) {
                            Fluttertoast.showToast(
                              msg: depositViewModel.responseMessage,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: depositViewModel.responseMessage,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.green,
                            );
                            // Clear the form after successful withdrawal
                            phoneController.clear();
                            amountController.clear();
                          }
                        },
                        child: depositViewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Make Withdrawal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                "There are no records to display",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}