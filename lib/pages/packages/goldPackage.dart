
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/package_model.dart';
import '../../viewmodel/package_viewmodel.dart';
class GoldPackagePage extends StatefulWidget {
  const GoldPackagePage({super.key});

  @override
  State<GoldPackagePage> createState() => _GoldPackagePageState();
}

class _GoldPackagePageState extends State<GoldPackagePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PackageViewModel>(context, listen: false).loadGoldPackage());
  }

  @override
  Widget build(BuildContext context) {
    final packageViewModel = Provider.of<PackageViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Center(
          child: packageViewModel.isLoading
              ? const CircularProgressIndicator()
              : packageViewModel.package == null
              ? const Text("Failed to load package")
              : Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 340,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/gold_banner.png',
                        width: 340,
                        height: 340,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 340,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "KES. ${packageViewModel.package!.price}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${packageViewModel.package!.name} Package",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
               child: Text(
                 "•⁠  ⁠The most Superior\n"
                 "•Daily whatsapp earnings\n"
                 "•⁠  ⁠24/7 customer support\n"
                 "•10,000 cashback bonus\n"
                 "•⁠  ⁠5,000 welcome bonus\n"
                 "•⁠  ⁠Access all Maybach products and services\n"
                 "•Earning is unlimited\n"
                 "•⁠  ⁠Automatic and instant withdrawals\n"
                 "•⁠  ⁠No package renewals\n"
                 "•⁠  ⁠Access to Gold Adverts",
                 textAlign: TextAlign.center,
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 14,
                 ),
               ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: packageViewModel.isPurchasing
                          ? null
                          : () {
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
                        minimumSize: const Size.fromHeight(50),
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
                          : const Text(
                        "Buy Package",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class UpdateGoldPackagePage extends StatefulWidget {
  const UpdateGoldPackagePage({super.key});

  @override
  State<UpdateGoldPackagePage> createState() => _UpdateGoldPackagePageState();
}

class _UpdateGoldPackagePageState extends State<UpdateGoldPackagePage> {
  bool isEditing = false;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final commissionController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final packageViewModel =
    Provider.of<PackageViewModel>(context, listen: false);
    packageViewModel.loadGoldPackage();
  }

  void enterEditMode(PackageModel package) {
    setState(() {
      isEditing = true;
      nameController.text = package.name;
      priceController.text = package.price.toString();
      descriptionController.text = package.description;
      commissionController.text = package.commissionRate.toString();
      categoryController.text = package.categoryType!;
    });
  }

  void saveChanges(PackageViewModel viewModel) {
    final updated = UpdatePackageModel(
      id: viewModel.package!.id,
      name: nameController.text,
      price: int.tryParse(priceController.text) ?? 0,
      description: descriptionController.text,
      commissionRate: int.tryParse(commissionController.text) ?? 0,
      categoryType: categoryController.text,
    );

    viewModel.updatePackage(updated.id.toString(), updated.toJson());
    setState(() {
      isEditing = false;
    });
  }


  Widget buildField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        readOnly: !isEditing,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isEditing ? Colors.grey[100] : Colors.grey[200],
          border: const OutlineInputBorder(),
        ),
        maxLines: label == 'Description' ? 3 : 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final packageViewModel = Provider.of<PackageViewModel>(context);
    final package = packageViewModel.package;

    if (package == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (!isEditing) {
      // Load values once when in view mode
      nameController.text = package.name;
      priceController.text = package.price.toString();
      descriptionController.text = package.description;
      commissionController.text = package.commissionRate.toString();
      categoryController.text = package.categoryType!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gold Package", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildField("Name", nameController),
            buildField("Price", priceController, isNumeric: true),
            buildField("Description", descriptionController),
            buildField("Commission Rate", commissionController, isNumeric: true),
            Offstage(
              offstage: true,  // Hides the field completely
              child: buildField("Category Type", categoryController),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (isEditing) {
                      saveChanges(packageViewModel);
                    } else {
                      enterEditMode(package);
                    }
                  },
                  icon: Icon(isEditing ? Icons.save : Icons.edit, color: Colors.white),
                  label: Text(
                    isEditing ? "Save Changes" : "Edit Package",
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                if (isEditing)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: const Text("Cancel"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
