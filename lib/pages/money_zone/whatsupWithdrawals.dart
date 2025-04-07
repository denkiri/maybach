import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/withdrawal_list_response.dart';
import '../../viewmodel/whatsup_withdrawal_viewmodel.dart';

class WhatsAppWithdrawalsPage extends StatefulWidget {
  const WhatsAppWithdrawalsPage({super.key});

  @override
  _WhatsAppWithdrawalsPageState createState() => _WhatsAppWithdrawalsPageState();
}

class _WhatsAppWithdrawalsPageState extends State<WhatsAppWithdrawalsPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WithdrawViewModel>(context, listen: false).fetchWithdrawals();
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      Provider.of<WithdrawViewModel>(context, listen: false).loadMoreWithdrawals();
    }
  }

  @override
  Widget build(BuildContext context) {
    final withdrawViewModel = Provider.of<WithdrawViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "WHATSAPP WITHDRAWALS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: phoneController,
                          label: "MPESA PHONE NUMBER",
                          hint: "Enter phone number",
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          controller: amountController,
                          label: "AMOUNT (MIN KES. 5,000)",
                          hint: "Enter amount",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                     // Expanded(child: _buildBalanceContainer()),
                      const SizedBox(width: 8),
                      _buildWithdrawButton(withdrawViewModel),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (withdrawViewModel.responseMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  withdrawViewModel.responseMessage,
                  style: TextStyle(
                    color: withdrawViewModel.responseMessage.contains("Failed")
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildWithdrawalsList(withdrawViewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
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
          keyboardType: label.contains("AMOUNT") ? TextInputType.number : TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildBalanceContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Text(
        "BALANCE KES. 0",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildWithdrawButton(WithdrawViewModel withdrawViewModel) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: withdrawViewModel.isLoading
          ? null
          : () {
        double amount = double.tryParse(amountController.text) ?? 0;
        if (amount < 5000) {
          Fluttertoast.showToast(
            msg: "Amount must be at least KES. 5000",
            gravity: ToastGravity.CENTER,
          );
          return;
        }
        withdrawViewModel.initiateWithdrawal(phoneController.text, amount).then((_) {
          if (withdrawViewModel.responseMessage.contains("Failed")) {
            Fluttertoast.showToast(
              msg: withdrawViewModel.responseMessage,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
            );
          } else {
            Fluttertoast.showToast(
              msg: withdrawViewModel.responseMessage,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
            );
            phoneController.clear();
            amountController.clear();
          }
        });
      },
      child: withdrawViewModel.isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text("Withdraw", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildWithdrawalsList(WithdrawViewModel viewModel) {
    if (viewModel.isLoading && viewModel.withdrawals.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.withdrawals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "There are no records to display",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.fetchWithdrawals(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: viewModel.withdrawals.length + (viewModel.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.withdrawals.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: viewModel.isLoadingMore
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ),
            );
          }

          final withdrawal = viewModel.withdrawals[index];
          return _buildWithdrawalItem(withdrawal, viewModel);
        },
      ),
    );
  }

  Widget _buildWithdrawalItem(WithdrawalItem withdrawal, WithdrawViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "KES ${withdrawal.amount}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(withdrawal.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    withdrawal.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Phone: ${withdrawal.phoneNumber}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              "Date: ${_formatDate(withdrawal.dateCreated)}",
              style: const TextStyle(color: Colors.grey),
            ),
            if (withdrawal.status == 'PENDING') ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: viewModel.isUnlocking
                      ? null
                      : () => _showUnlockConfirmation(withdrawal.id),
                  child: viewModel.isUnlocking
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Unlock Withdrawal",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showUnlockConfirmation(String withdrawalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Unlock"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("A fee of KES 2,000 will be deducted to unlock this withdrawal."),
            SizedBox(height: 8),
            Text("Are you sure you want to proceed?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _unlockWithdrawal(withdrawalId);
            },
            child: const Text(
              "Unlock",
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  // In WhatsAppWithdrawalsPage
  Future<void> _unlockWithdrawal(String withdrawalId) async {
    final viewModel = Provider.of<WithdrawViewModel>(context, listen: false);
    try {
      await viewModel.unlockWithdrawal(withdrawalId);

      Fluttertoast.showToast(
        msg: viewModel.responseMessage,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: viewModel.responseMessage,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.green;
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }
}