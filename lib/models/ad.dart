import 'dart:convert';

class AdFile {
  final String id;
  final String fileUrl;
  final String name;
  final String dateCreated;

  AdFile({
    required this.id,
    required this.fileUrl,
    required this.name,
    required this.dateCreated,
  });

  factory AdFile.fromJson(Map<String, dynamic> json) {
    return AdFile(
      id: json['id'],
      fileUrl: json['file'],
      name: json['name'],
      dateCreated: json['date_created'],
    );
  }
}

class Ad {
  final String id;
  final AdFile file;
  final String dateCreated;
  final String dateUpdated;
  final String? dateDeleted;
  final String ad;

  Ad({
    required this.id,
    required this.file,
    required this.dateCreated,
    required this.dateUpdated,
    this.dateDeleted,
    required this.ad,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'],
      file: AdFile.fromJson(json['file']),
      dateCreated: json['date_created'],
      dateUpdated: json['date_updated'],
      dateDeleted: json['date_deleted'],
      ad: json['ad'],
    );
  }

  static List<Ad> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Ad.fromJson(json)).toList();
  }
}