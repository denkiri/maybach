import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/components/widgets/footer.dart';
import 'package:flutter_projects/pages/dashboard/widgets/activePackage.dart';
import 'package:flutter_projects/pages/dashboard/widgets/customAppBar.dart';
import 'package:flutter_projects/pages/dashboard/widgets/depositBalance.dart';
import 'package:flutter_projects/pages/dashboard/widgets/drawer/customDrawer.dart';
import 'package:flutter_projects/pages/dashboard/widgets/investmentPlan.dart';
import 'package:flutter_projects/pages/dashboard/widgets/promoCodeCard.dart';
import 'package:flutter_projects/pages/dashboard/widgets/totalWithdrawn.dart';
import 'package:flutter_projects/pages/dashboard/widgets/walletBalance.dart';
import 'package:flutter_projects/pages/dashboard/widgets/whatsupBalance.dart';
import 'package:flutter_projects/pages/dashboard/widgets/whatsupWithdrawal.dart';
import 'package:flutter_projects/pages/dashboard/widgets/topEarners.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/dashboard_viewmodel.dart';
import '../ad/ads.dart';
import '../bonus/cash_back_bonus.dart';
import '../bonus/pro_bonus.dart';
import '../bonus/welcome_bonus.dart';
import '../clearance/clearance.dart';
import '../deposit/deposit.dart';
import '../dollar_zone/advertisingAgency.dart';
import '../dollar_zone/certification.dart';
import '../dollar_zone/verification.dart';
import '../jobs/jobs.dart';
import '../loans/applyLoan.dart';
import '../loans/loanHistory.dart';
import '../money_zone/submitView.dart';
import '../money_zone/whatsupWithdrawals.dart';
import '../online_writing/cloudworkers.dart';
import '../online_writing/remotasks.dart';
import '../packages/goldPackage.dart';
import '../packages/platinumPackage.dart';
import '../packages/silverPackage.dart';
import '../starlink/starlink.dart';
import '../teams/teams.dart';
import '../wallet/transfer.dart';
import '../wallet/withdrawals.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentRoute = '/dashboard';


  void _navigateTo(String route) {
    if (route == '/login') {
      // If we are navigating to login, reset the browser URL to /login without fragments
      if (kIsWeb) {
        html.window.history.pushState(null, '', '/login');
      }
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
      return;
    }

    // Update internal state
    setState(() => _currentRoute = route);

    // ✅ Update the browser URL manually (without full navigation)
    if (kIsWeb) {
      html.window.history.pushState(null, '', route); // Update URL without fragment
    }

    // Close drawer on small screen
    if (!_isWideScreen(context)) Navigator.pop(context);
  }

  Widget _getPage() {
    switch (_currentRoute) {
      case '/dashboard':return const DashboardPage();
      case '/deposit':return const DepositPage();
      case '/silver-package':
        return const SilverPackagePage();
      case '/platinum-package':
        return const PlatinumPackagePage();
      case '/gold-package':
        return const GoldPackagePage();
      case '/submit-views':
        return SubmitViewPage();
      case '/whatsup-withdrawals':
        return WhatsAppWithdrawalsPage();
      case '/bonus-withdrawals':
        return const BonusWithdrawalsPage();
      case '/certification':
        return const CertificationPage();
      case '/advertising-agent':
        return const AdvertisingAgentPage();
      case '/verification':
        return const VerificationPage();
      case '/welcome-bonus':
        return const WelcomeBonusPage();
      case '/cashback-bonus':
        return const CashBackBonusPage();
      case '/pro-bonus':
        return const ProBonusPage();
      case '/cashback':
        return const CashbackPage();
      case '/remotasks':
        return const RemotasksPage();
      case '/cloudworkers':
        return const CloudworkersPage();
      case '/starlink':
        return const StarlinkPackagesPage();
      case '/monetized-ads':
        return const AdsPage();
      case '/jobs':
        return const JobListingPage();
      case '/apply':
        return const ApplyLoanPage();
      case '/history':
        return const LoanHistoryPage();
      case '/clearance':
        return const ClearancePage();
      case '/teams':return const TeamsPage();
      case '/withdrawals':return const WithdrawalPage();
      case '/transfer':return const TransferPage();
      //case '/settings':return const SettingsPage();
      //case '/settings':return const TeamsPage();
      default:
        return const DashboardPage();
    }
  }

  // Helper method to determine if drawer should be shown
  bool _isWideScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        isLargeScreen: _isWideScreen(context),
        scaffoldKey: _scaffoldKey,
      ),
      drawer: _isWideScreen(context)
          ? null
          : CustomDrawer(
        currentRoute: _currentRoute,
        navigateTo: _navigateTo,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (_isWideScreen(context))
                    CustomDrawer(
                      currentRoute: _currentRoute,
                      navigateTo: _navigateTo,
                    ),
                  Expanded(child: _getPage()),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize data fetching when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(context, listen: false).fetchDashboardData();
    });

    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        // Assuming 'viewModel.dashboardData.details.topEarners' is List<TopEarner>
        List<Map<String, String>> topEarnersMapList = viewModel.dashboardData?.details.topEarners
            .map((topEarner) => {
          'user': topEarner.user,
          'total_earnings': topEarner.totalEarnings,
        })
            .toList() ?? []; // Default to an empty list if it's null.


        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFFFFFFF),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning ${viewModel.dashboardData?.details.firstName ?? 'User'} 👋",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNotificationCard(viewModel),
                      const SizedBox(height: 16),
                      if (viewModel.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (viewModel.errorMessage.isNotEmpty)
                        Center(
                          child: Text(
                            viewModel.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      else if (viewModel.dashboardData != null)

                          LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);
                              double aspectRatio = _calculateAspectRatio(constraints.maxWidth);

                              return GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: aspectRatio,
                                 children: [

                                  WhatsappBalanceCard(
                                      data: viewModel.dashboardData!.details.whatsappEarnings.balance.toString()),
                                  WhatsappWithdrawalCard(
                                      data: viewModel.dashboardData!.details.whatsappEarnings.totalWithdrawals.toString()),
                                   ActivePackageCard(
                                     data: viewModel.dashboardData!.details.activePackage?.name ?? "No active package",
                                   ),
                                  DepositBalanceCard(
                                      data: viewModel.dashboardData!.details.userDeposit.toString()),
                                  TopEarnersCard(
                                      topEarners: topEarnersMapList),
                                  const InvestmentPlanCard(
                                     ),
                                  PromoCodeCard(
                                      promoCode: viewModel.dashboardData!.details.promoCode.referralCode,inviter: viewModel.dashboardData!.details.promoCode.referredBy,),
                                  WalletBalanceCard(
                                      data: viewModel.dashboardData!.details.wallet.balance.toString()),
                                  TotalWithdrawnCard(
                                      data: viewModel.dashboardData!.details.withdrawals.toString()),
                                ],
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _calculateCrossAxisCount(double maxWidth) {
    if (maxWidth >= 1200) return 4;
    if (maxWidth >= 800) return 3;
    if (maxWidth >= 600) return 2;
    return 1;
  }

  double _calculateAspectRatio(double maxWidth) {
    if (maxWidth >= 1200) return 2.5;
    if (maxWidth >= 800) return 2.0;
    if (maxWidth >= 600) return 1.8;
    return 1.5;
  }

  Widget _buildNotificationCard(DashboardViewModel viewModel) {
    final notificationMessage = viewModel.dashboardData?.details.latestNotification?.message ?? "No new notifications";
    return Card(
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
          leading: const Icon(Icons.notifications, color: Colors.white),
          title: const Text("Notification", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
          subtitle: Text(notificationMessage,style:const TextStyle(color: Colors.white))),
    );
  }
}

class DashboardPage2 extends StatelessWidget {
  const DashboardPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Good Morning dele 👋",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);
                      double aspectRatio = _calculateAspectRatio(constraints.maxWidth);

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: aspectRatio,
                        children: const [
                          //whatsappBalanceCard(),
                         // whatsappWithdrawalCard(),
                          //const ActivePackageCard(),
                          // const DepositBalanceCard(),
                          // const CashbackBonusCard(),
                          // const InvestmentPlanCard(),
                          // const PromoCodeCard(),
                          // const WalletBalanceCard(),
                          // const TotalWithdrawnCard(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(double maxWidth) {
    if (maxWidth >= 1200) return 4;
    if (maxWidth >= 800) return 3;
    if (maxWidth >= 600) return 2;
    return 1;
  }

  double _calculateAspectRatio(double maxWidth) {
    if (maxWidth >= 1200) return 2.5;
    if (maxWidth >= 800) return 2.0;
    if (maxWidth >= 600) return 1.8;
    return 1.5;
  }

  Widget _buildNotificationCard() {
    return Card(
      color: Colors.green.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: const ListTile(
        leading: Icon(Icons.notifications, color: Colors.green),
        title: Text("Mercedes-Benz", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Happy Earnings with Benztech Motors!"),
      ),
    );
  }
}

class BonusWithdrawalsPage extends StatefulWidget {
  const BonusWithdrawalsPage({super.key});

  @override
  _BonusPageState createState() => _BonusPageState();
}

class _BonusPageState extends State<BonusWithdrawalsPage> {
  final TextEditingController bonusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    "CLAIM BONUS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: bonusController,
                    label: "BONUS AMOUNT",
                    hint: "Enter amount",
                  ),
                  const SizedBox(height: 12),
                  _buildClaimButton(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildNoRecordsText(),
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
        ),
      ],
    );
  }

  Widget _buildClaimButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {},
      child: const Text("Claim Bonus", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildNoRecordsText() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text("There are no bonus records to display",
            style: TextStyle(color: Colors.black54)),
      ),
    );
  }
}







class CashbackPage extends StatelessWidget {
  const CashbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Cashback Page"));
  }
}
