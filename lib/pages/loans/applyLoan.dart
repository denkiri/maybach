import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/utils/toast_utils.dart';
import '../../viewmodel/loan_viewmodel.dart';

class ApplyLoanPage extends StatefulWidget {
  const ApplyLoanPage({super.key});

  @override
  State<ApplyLoanPage> createState() => _ApplyLoanPageState();
}

class _ApplyLoanPageState extends State<ApplyLoanPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<LoanViewModel>(context, listen: false);
      viewModel.fetchProfile();
      viewModel.fetchLoans();
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<LoanViewModel>(context, listen: false).loadMoreLoans();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoanViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Apply Loan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.3),
      ),
      body: viewModel.isLoading && viewModel.loans.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLoanFormCard(viewModel, isMobile),
                const SizedBox(height: 24),
                _buildLoanListCard(viewModel, isMobile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoanFormCard(LoanViewModel viewModel, bool isMobile) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Loan Application Form",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Wrap(
              runSpacing: 12,
              spacing: isMobile ? 0 : 16,
              children: [
                _buildTextField("First Name", viewModel.firstNameController),
                _buildTextField("Last Name", viewModel.lastNameController),
                _buildTextField("Email Address", viewModel.emailController),
                _buildTextField("Phone Number", viewModel.phoneNumberController),
                _buildTextField("Amount (KES)", viewModel.amountController),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "KES. 200 will be deducted from your deposit balance as application fee.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (viewModel.isLoading) return;

                  final amountText = viewModel.amountController.text.trim();

                  if (amountText.isEmpty) {
                    ToastUtils.showWarningToast("Please enter loan amount");
                    return;
                  }

                  if (int.tryParse(amountText) == null) {
                    ToastUtils.showWarningToast("Please enter a valid amount");
                    return;
                  }

                  bool success = await viewModel.applyLoan();
                  if (success) {
                    ToastUtils.showSuccessToast("Loan application submitted!");
                  } else {
                 //   ToastUtils.showErrorToast(viewModel.error ?? "Failed to submit loan application");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: viewModel.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text("Submit Application",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoanListCard(LoanViewModel viewModel, bool isMobile) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("My Loan Applications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: viewModel.loans.map((loan) {
                    return DataRow(cells: [
                      DataCell(Text("KES ${loan.amount}")),
                      DataCell(Text(_formatDate(loan.dateCreated))),
                      DataCell(Text(
                        loan.status,
                        style: TextStyle(
                          color: _getStatusColor(loan.status),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            if (viewModel.isLoading && viewModel.loans.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!viewModel.hasMore && viewModel.loans.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text("No more loans to load")),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 350,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic date) {
    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'Invalid date';
      }
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (e) {
      return 'Invalid date';
    }
  }
}
