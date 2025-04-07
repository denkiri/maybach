
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/package_viewmodel.dart';
class ProBonusPage extends StatefulWidget {
  const ProBonusPage({super.key});

  @override
  State<ProBonusPage> createState() => _ProBonusPageState();
}

class _ProBonusPageState extends State<ProBonusPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PackageViewModel>(context, listen: false).loadProBonusPackage());
  }

  @override
  Widget build(BuildContext context) {
    final packageViewModel = Provider.of<PackageViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: packageViewModel.isLoading
            ? const CircularProgressIndicator()
            : packageViewModel.package == null
            ? const Text("Failed to load package")
            : Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/pro_bonus_banner.png',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "KES. ${packageViewModel.package!.price}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  packageViewModel.package!.name,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    packageViewModel.package!.description,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: packageViewModel.isPurchasing
                      ? null
                      : () {
                    // Handle package purchase
                    packageViewModel.purchasePackage(
                      packageViewModel.package!.id,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: packageViewModel.isPurchasing
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text("Claim Bonus",
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
