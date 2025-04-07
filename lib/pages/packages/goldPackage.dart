
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
                    'assets/images/gold_banner.png',
                    width: double.infinity,
                    height: 120,
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
                    child: Text("Buy Package",
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
