import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/package_viewmodel.dart';

class StarlinkPackagesPage extends StatefulWidget {
  const StarlinkPackagesPage({super.key});

  @override
  State<StarlinkPackagesPage> createState() => _StarlinkPackagesPageState();
}

class _StarlinkPackagesPageState extends State<StarlinkPackagesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PackageViewModel>(context, listen: false).loadStarlinkMotorsPackage());
  }

  @override
  Widget build(BuildContext context) {
    final packageViewModel = Provider.of<PackageViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Center(
          child: Text(
            "Starlink Packages",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),),
      body: packageViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : packageViewModel.packages.isEmpty
          ? const Center(child: Text("No packages available"))
          : ListView.builder(

        padding: const EdgeInsets.all(16),
        itemCount: packageViewModel.packages.length,
        itemBuilder: (context, index) {
          final package = packageViewModel.packages[index];
          final isPurchasing = packageViewModel.isPurchasingStarlink(package.id);
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "KES. ${package.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      package.description,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: isPurchasing
                            ? null
                            : () {
                          packageViewModel.purchaseStarlinkPackage(package.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isPurchasing
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Text("Buy Now", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
