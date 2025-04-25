import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/teams_viewmodel.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TeamsViewModel()..fetchTeams(),
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: const Text(
            "My Team",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.cyan,
          elevation: 4,
          shadowColor: Colors.blue.withOpacity(0.3),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Consumer<TeamsViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.teams.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.errorMessage != null && viewModel.teams.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            viewModel.errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: isSmallScreen ? 14 : 16),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: viewModel.refreshTeams,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            shadowColor: Colors.blue.withOpacity(0.2),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: DataTable(
                                columnSpacing: isSmallScreen ? 8 : 12,
                                headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
                                columns: const [
                                  DataColumn(label: Text("Username")),
                                  DataColumn(label: Text("Phone")),
                                  DataColumn(label: Text("Deposit")),
                                  DataColumn(label: Text("Active Package")),
                                  DataColumn(label: Text("Registered")),
                                  DataColumn(label: Text("Status")),
                                ],
                                rows: viewModel.teams.map((member) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(member.username, style: TextStyle(fontSize: isSmallScreen ? 12 : 14))),
                                      DataCell(Text(member.phoneNumber, style: TextStyle(fontSize: isSmallScreen ? 12 : 14))),
                                      DataCell(Text("${member.deposit} KES", style: TextStyle(fontSize: isSmallScreen ? 12 : 14))),
                                      DataCell(Text(member.activePackage, style: TextStyle(fontSize: isSmallScreen ? 12 : 14))),
                                      DataCell(Text(member.registered.split('T')[0], style: TextStyle(fontSize: isSmallScreen ? 12 : 14))),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: member.status == "ACTIVE" ? Colors.green[400] : Colors.red[400],
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: member.status == "ACTIVE"
                                                    ? Colors.green.withOpacity(0.2)
                                                    : Colors.red.withOpacity(0.2),
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            member.status,
                                            style: TextStyle(color: Colors.white, fontSize: isSmallScreen ? 12 : 14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (viewModel.isLoading && viewModel.teams.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      if (!viewModel.hasMore && viewModel.teams.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No more teams to load",
                            style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: Consumer<TeamsViewModel>(
          builder: (context, viewModel, child) {
            return FloatingActionButton(
              onPressed: viewModel.refreshTeams,
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