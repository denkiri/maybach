class PackageModel {
  final String id;
  final String name;
  final String description;
  final String price;
  final bool isActive;
  final double? commissionRate;
  final String? categoryType;
  final String? bonus;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;
  final DateTime? dateDeleted;

  PackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isActive,
    this.commissionRate,
    this.categoryType,
    this.bonus,
    this.dateCreated,
    this.dateUpdated,
    this.dateDeleted,
  });

  /// Factory method to parse a single JSON object into a `PackageModel`
  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? "",
      price: json['price'],
      isActive: json['is_active'],
      commissionRate: (json['commission_rate'] as num?)?.toDouble(),
      categoryType: json['category_type'],
      bonus: json['bonus'],
      dateCreated: json['date_created'] != null ? DateTime.tryParse(json['date_created']) : null,
      dateUpdated: json['date_updated'] != null ? DateTime.tryParse(json['date_updated']) : null,
      dateDeleted: json['date_deleted'] != null ? DateTime.tryParse(json['date_deleted']) : null,
    );
  }

  /// Helper method to parse a list of JSON objects into a list of `PackageModel`
  static List<PackageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PackageModel.fromJson(json)).toList();
  }

}
class UpdatePackageModel {
  final String? id;
  final String name;
  final int price;
  final String description;
  final int commissionRate;
  final String categoryType;

  UpdatePackageModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.commissionRate,
    required this.categoryType,
  });

  factory UpdatePackageModel.fromJson(Map<String, dynamic> json) {
    return UpdatePackageModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      commissionRate: json['commission_rate'],
      categoryType: json['category_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "description": description,
      "commission_rate": commissionRate,
      "category_type": categoryType,
    };
  }
}

