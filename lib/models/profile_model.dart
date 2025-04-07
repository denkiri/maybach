class ProfileModel {
  final Details details;

  ProfileModel({required this.details});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      details: Details.fromJson(json['details']),
    );
  }
}

class Details {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String country;
  final String userReferralCode;
  final String status;
  final ReferredBy referredBy;

  Details({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.country,
    required this.userReferralCode,
    required this.status,
    required this.referredBy,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      country: json['country'],
      userReferralCode: json['user_referral_code'],
      status: json['status'],
      referredBy: ReferredBy.fromJson(json['referred_by']),
    );
  }
}

class ReferredBy {
  final String id;
  final String username;
  final String firstName;
  final String lastName;

  ReferredBy({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory ReferredBy.fromJson(Map<String, dynamic> json) {
    return ReferredBy(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}