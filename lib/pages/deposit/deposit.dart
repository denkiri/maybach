import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../viewmodel/deposit_viewmodel.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    final depositViewModel = Provider.of<DepositViewModel>(context);

    // Controllers for personal deposit
    TextEditingController phoneController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController receiptNoController = TextEditingController();

    // Controllers for another account deposit
    TextEditingController recipientPhoneController = TextEditingController();
    TextEditingController recipientAmountController = TextEditingController();
    TextEditingController recipientUsernameController = TextEditingController();
    TextEditingController recipientReceiptNoController = TextEditingController();

    // Show toast when response message is updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (depositViewModel.responseMessage.isNotEmpty) {
        Fluttertoast.showToast(
          msg: depositViewModel.responseMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        depositViewModel.responseMessage = ""; // Reset message
      }
    });

    return WillPopScope(
        onWillPop: () async => !depositViewModel.isLoading, // disable back if loading
    child: Stack(
    children: [
    Scaffold(
    backgroundColor: Colors.grey[200],
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
    child: Column(
            children: [
              // Personal Deposit Card
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildDepositCard(
                      context,
                      title: "DEPOSIT TO YOUR ACCOUNT",
                      color1: Colors.purple,
                      color2: Colors.deepPurple,
                      fields: _buildPersonalDepositFields(phoneController, amountController, receiptNoController),
                      onPressed: () {
                        String phone = phoneController.text.trim();
                        int amount = int.tryParse(amountController.text) ?? 0;
                        String receiptNo = receiptNoController.text.trim();

                        if (phone.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Phone number cannot be empty",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        if (amount <= 0) {
                          Fluttertoast.showToast(
                            msg: "Enter a valid amount",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }
                        if (receiptNo.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Receipt number cannot be empty",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }



                        depositViewModel.deposit(amount, phone, receiptNo);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Another Account Deposit Card
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildDepositCard(
                      context,
                      title: "DEPOSIT TO ANOTHER ACCOUNT",
                      color1: Colors.green,
                      color2: Colors.lightGreen,
                      fields: _buildAnotherAccountDepositFields(
                        recipientPhoneController,
                        recipientAmountController,
                        recipientUsernameController,
                        recipientReceiptNoController,
                      ),
                      onPressed: () {
                        String phone = recipientPhoneController.text.trim();
                        int amount = int.tryParse(recipientAmountController.text) ?? 0;
                        String username = recipientUsernameController.text.trim();
                        String receiptNo = recipientReceiptNoController.text.trim();

                        if (phone.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Phone number cannot be empty",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        if (amount <= 0) {
                          Fluttertoast.showToast(
                            msg: "Enter a valid amount",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        if (username.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Recipient username cannot be empty",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }
                        if (receiptNo.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Receipt number cannot be empty",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        depositViewModel.anotherAccountDeposit(amount, phone, username, receiptNo);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              if (depositViewModel.isLoading) const CircularProgressIndicator(),
            ],
    ),
    ),
    ),
    ),

    // Fullscreen modal while waiting for payment
    if (depositViewModel.isLoading)
    Positioned.fill(
    child: Container(
    color: Colors.black.withOpacity(0.5),
    child: const Center(
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    CircularProgressIndicator(color: Colors.white),
    SizedBox(height: 16),
    Text(
    "⏳ Tracking your payment...\nDo not close or exit the app",
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.white, fontSize: 16),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    ),
    );
  }

  Widget _buildDepositCard(
      BuildContext context, {
        required String title,
        required Color color1,
        required Color color2,
        required List<Widget> fields,
        required VoidCallback onPressed,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...fields,
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onPressed,
              child: const Text("Make Payment", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPersonalDepositFields(
      TextEditingController phoneController,
      TextEditingController amountController,
      TextEditingController receiptNoController) {
    return [
      _buildTextField(
          label: "PHONE - MPESA REGISTERED",
          hint: "254701234567",
          controller: phoneController
      ),
      const SizedBox(height: 8),
      _buildTextField(
          label: "AMOUNT",
          hint: "Enter amount",
          controller: amountController,
          isNumeric: true
      ),
      const SizedBox(height: 8),
      _buildTextField(
          label: "RECEIPT NUMBER",
          hint: "Enter receipt number",
          controller: receiptNoController
      ),
    ];
  }

  List<Widget> _buildAnotherAccountDepositFields(
      TextEditingController phoneController,
      TextEditingController amountController,
      TextEditingController usernameController,
      TextEditingController receiptNoController) {
    return [
      _buildTextField(
          label: "YOUR PHONE - MPESA REGISTERED",
          hint: "254701234567",
          controller: phoneController
      ),
      const SizedBox(height: 8),
      _buildTextField(
          label: "RECIPIENT USERNAME",
          hint: "Enter recipient username",
          controller: usernameController
      ),
      const SizedBox(height: 8),
      _buildTextField(
          label: "AMOUNT",
          hint: "Enter amount",
          controller: amountController,
          isNumeric: true
      ),
      const SizedBox(height: 8),
      _buildTextField(
          label: "RECEIPT NUMBER",
          hint: "Enter receipt number",
          controller: receiptNoController
      ),
    ];
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isNumeric = false
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}