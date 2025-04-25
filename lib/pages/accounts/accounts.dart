import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/account_viewmodel.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
      final viewModel = AccountViewModel();
      viewModel.fetchAccounts();
      viewModel.initScrollListener();
      return viewModel;
    },
    child: Scaffold(
    backgroundColor: Colors.blueGrey[50],
    appBar: AppBar(
    title: const Text(
    "Accounts",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.cyan,
    elevation: 4,
    shadowColor: Colors.blue.withOpacity(0.3),
    ),
    body: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Consumer<AccountViewModel>(
    builder: (context, viewModel, child) {
    if (viewModel.isLoading && viewModel.accounts.isEmpty) {
    return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.accounts.isEmpty) {
    return Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    viewModel.errorMessage!,
    style: const TextStyle(color: Colors.red, fontSize: 16),
    ),
    const SizedBox(height: 10),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: viewModel.refreshAccounts,
    child: const Text('Retry'),
    ),
    ],
    ),
    );
    }

    return Column(
    children: [
    Expanded(
    child: NotificationListener<ScrollNotification>(
    onNotification: (notification) {
    if (notification is ScrollEndNotification &&
    viewModel.scrollController.position.pixels ==
    viewModel.scrollController.position.maxScrollExtent &&
    !viewModel.isLoading &&
    viewModel.hasMore) {
    viewModel.loadMoreAccounts();
    }
    return false;
    },
    child: LayoutBuilder(
    builder: (context, constraints) {
    return SingleChildScrollView(
    controller: viewModel.scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    child: ConstrainedBox(
    constraints: BoxConstraints(
    minHeight: constraints.maxHeight,
    ),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    // Horizontal scrolling table
    SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Card(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    shadowColor: Colors.blue.withOpacity(0.2),
    child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: DataTable(
    columnSpacing: 12,
    headingRowColor:
    MaterialStateProperty.all(Colors.blue.shade100),
    columns: const [
    DataColumn(label: Text("No.")),
    DataColumn(label: Text("Username")),
    DataColumn(label: Text("First Name")),
    DataColumn(label: Text("Last Name")),
    DataColumn(label: Text("Phone")),
    DataColumn(label: Text("Email")),
    DataColumn(label: Text("Country")),
    DataColumn(label: Text("Referral Code")),
    DataColumn(label: Text("Status")),
    DataColumn(label: Text("Referred By")),
    DataColumn(label: Text("Date Created")),
    DataColumn(label: Text("Active Package")),
    DataColumn(label: Text("Wallet Balance")),
    DataColumn(label: Text("Total Withdrawals")),
    DataColumn(label: Text("Actions")),
    ],
                            rows: viewModel.accounts.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              var account = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(Text(index.toString())),
                              DataCell(
                              InkWell(
                              onTap: () async {
                              final viewModel = context.read<AccountViewModel>();
                              await viewModel.fetchUserDepositHistory(account.id);

                              showDialog(
                              context: context,
                              builder: (context) {
                              final deposits = viewModel.depositHistory;
                            return AlertDialog(
                              title: Text(
                                "${account.username}'s Deposit History",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              content: deposits.isEmpty
                                  ? const Text(
                                      "No deposit history available.",
                                      style: TextStyle(fontSize: 16, color: Colors.grey),
                                    )
                                  : SizedBox(
                                      width: double.maxFinite,
                                      height: 300, // Set a fixed height for better scrolling on mobile
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: deposits.length,
                                        separatorBuilder: (context, index) => const Divider(
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                        itemBuilder: (context, index) {
                                          final deposit = deposits[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "KES ${deposit.amount.toStringAsFixed(2)}",
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                Text(
                                                  deposit.createdAt.toLocal().toString().split('.')[0],
                                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    viewModel.clearDepositHistory(); // optional cleanup
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Close",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                              },
                              );
                              },
                              child: Text(account.username,
                              style: const TextStyle(
                              color: Colors.blue, decoration: TextDecoration.underline)),
                              ),
                              ),
                                  DataCell(Text(account.firstName)),
                                  DataCell(Text(account.lastName)),
                                  DataCell(Text(account.phoneNumber.toString())),
                                  DataCell(Text(account.email.toString())),
                                  DataCell(Text(account.country.toString())),
                                  DataCell(Text(account.userReferralCode.toString())),
                                  DataCell(
                                    Container(
                                      width: 100, // Set a fixed width
                                      height: 30, // Set a fixed height
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: account.status == "ACTIVE" ? Colors.green[400] : Colors.red[400],
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: account.status == "ACTIVE"
                                                ? Colors.green.withOpacity(0.2)
                                                : Colors.red.withOpacity(0.2),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center( // Center the text within the container
                                        child: Text(account.status.toString(), style: const TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(account.referredBy?.username ?? "N/A")),
                                  DataCell(Text(account.dateCreated!.split('T')[0])),
                                  DataCell(
                                    Text(
                                      account.activePackage != null && account.activePackage!.isNotEmpty
                                          ? account.activePackage!
                                          : 'None',
                                    ),
                                  ),
                                  DataCell(Text("KES ${account.wallet!.balance.toString()}")),
                                  DataCell(Text("KES ${account.withdrawals!.toString()}")),
                                  DataCell(
                                    Row(
                                      children: [
                                        if (account.status == "ACTIVE")
                                          SizedBox(
                                            width: 120, // Set a fixed width
                                            height: 30, // Set a fixed height
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                // Show loading toast
                                                Fluttertoast.showToast(
                                                  msg: "Deactivating account...",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );

                                                // Call deactivateAccount
                                                var result = await viewModel.deactivateAccount(account.id);

                                                // Show result toast
                                                Fluttertoast.showToast(
                                                  msg: result.message,
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              child: const Text("Deactivate"),
                                            ),
                                          )
                                        else
                                          SizedBox(
                                            width: 120, // Set a fixed width
                                            height: 30, // Set a fixed height
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                // Show loading toast
                                                Fluttertoast.showToast(
                                                  msg: "Activating account...",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );

                                                // Call activateAccount
                                                var result = await viewModel.activateAccount(account.id);

                                                // Show result toast
                                                Fluttertoast.showToast(
                                                  msg: result.message,
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              child: const Text("Activate"),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
    ),
    ),
    ),
    ),
      // Bottom padding space
      SizedBox(height: viewModel.hasMore ? 0 : 60),
    ],
    ),
    ),
    );
    },
    ),
    ),
    ),
      if (viewModel.isLoading && viewModel.accounts.isNotEmpty)
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      if (!viewModel.hasMore && viewModel.accounts.isNotEmpty)
        const Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Text(
            "No more accounts to load",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
    ],
    );
    },
    ),
    ),
      floatingActionButton: Consumer<AccountViewModel>(
        builder: (context, viewModel, child) {
          return FloatingActionButton(
            onPressed: viewModel.refreshAccounts,
            tooltip: 'Refresh',
            backgroundColor: Colors.green,
            child: const Icon(Icons.refresh, color: Colors.white),
          );
        },
      ),
    ),
    );
  }
}