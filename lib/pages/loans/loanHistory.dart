import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/loan_viewmodel.dart';
class LoanHistoryPage extends StatefulWidget {
  const LoanHistoryPage({super.key});

  @override
  State<LoanHistoryPage> createState() => _LoanHistoryPageState();
}

class _LoanHistoryPageState extends State<LoanHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize and fetch first page of loans
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoanViewModel>(context, listen: false).fetchLoans();
    });

    // Setup scroll listener for pagination
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
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text(
                  "Loan Application History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => viewModel.refreshLoans(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        if (viewModel.isLoading && viewModel.loans.isEmpty)
                          const Center(child: CircularProgressIndicator()),
                        if (viewModel.loans.isNotEmpty)
                          Container(
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

                        if (viewModel.isLoading && viewModel.loans.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),

                        if (!viewModel.hasMore && viewModel.loans.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "No more loans to load",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
      DateTime dateTime = date is String ? DateTime.parse(date) : date as DateTime;
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    } catch (e) {
      return 'Invalid date';
    }
  }
}