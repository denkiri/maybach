import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/package_model.dart';
import '../service/package_service.dart';

class PackageViewModel extends ChangeNotifier {
  final PackageService _service = PackageService();
  List<PackageModel> packages = [];
  PackageModel? package;
  bool isLoading = false;
  bool isPurchasing = false;

//CUSTOM
  Future<void> loadSilverPackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchSilverPackage();

    isLoading = false;
    notifyListeners();
  }
  Future<void> loadPlatinumPackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchPlatinumPackage();

    isLoading = false;
    notifyListeners();
  }
  Future<void> loadGoldPackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchGoldPackage();

    isLoading = false;
    notifyListeners();
  }
  Future<void> loadMayBachPackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchMayBachPackage();

    isLoading = false;
    notifyListeners();
  }
  Future<void> loadWhatsupLinkagePackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchWhatsupLinkagePackage();

    isLoading = false;
    notifyListeners();
  }
  //BONUS
  Future<void> loadWelcomePackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchWelcomePackage();

    isLoading = false;
    notifyListeners();
  }
  Future<void> loadCashBackPackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchCashBackPackage();

    isLoading = false;
    notifyListeners();
  }
  Future<void> loadProBonusPackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchProBonusPackage();

    isLoading = false;
    notifyListeners();
  }
  //WRITING
  Future<void> loadRemotasksPackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchRemoTasksPackage();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadCloudWorkersPackage() async {
    isLoading = true;
    notifyListeners();

    package = await _service.fetchCloudWorkersPackage();

    isLoading = false;
    notifyListeners();
  }
  //CLEARANCE
  Future<void> loadClearancePackage() async {
    isLoading = true;
    notifyListeners();
    package = await _service.fetchClearancePackage();
    isLoading = false;
    notifyListeners();
  }
  //DOLLAR_ZONE
  Future<void> loadCertificationPackage() async {
    isLoading = true;
    notifyListeners();
    package = await _service.fetchCertificationPackage();
    isLoading = false;
    notifyListeners();
  }
  Future<void> loadAdvertisingAgencyPackage() async {
    isLoading = true;
    notifyListeners();
    package = await _service.fetchAdvertisingAgencyPackage();
    isLoading = false;
    notifyListeners();
  }
  Future<void> loadVerificationPackage() async {
    isLoading = true;
    notifyListeners();
    package = await _service.fetchVerificationPackage();
    isLoading = false;
    notifyListeners();
  }

  //STARLINK_MOTORS
  Future<void> loadStarlinkMotorsPackage() async {
    isLoading = true;
    notifyListeners();

    packages = await _service.fetchStarlinkMotorsPackages();

    isLoading = false;
    notifyListeners();
  }
  //PURCHASING PACKAGE
  Future<void> purchasePackage(String packageId) async {
    isPurchasing = true;
    notifyListeners();

    final result = await _service.purchasePackage(packageId);

    isPurchasing = false;
    notifyListeners();

    Fluttertoast.showToast(
      msg: result['message'],
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: result['success'] ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  //STARLINK PURCHASE
  // Keep track of purchasing status for individual packages
  final Set<String> _purchasingPackageIds = {};
  bool isPurchasingStarlink(String packageId) => _purchasingPackageIds.contains(packageId);
  Future<void> purchaseStarlinkPackage(String packageId) async {
    _purchasingPackageIds.add(packageId);
    notifyListeners();

    final result = await _service.purchasePackage(packageId);

    _purchasingPackageIds.remove(packageId);
    notifyListeners();

    Fluttertoast.showToast(
      msg: result['message'],
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: result['success'] ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  //UPDATE PACKAGE
  Future<void> updatePackage(String packageId, Map<String, dynamic> data) async {
    isLoading = true;
    notifyListeners();
    final result = await _service.updatePackage(packageId, data);
    isLoading = false;
    notifyListeners();
    Fluttertoast.showToast(
      msg: result['message'],
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: result['success'] ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }




}
