class AccountsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<UserAccount> results;

  AccountsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AccountsResponse.fromJson(Map<String, dynamic> json) {
    return AccountsResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((item) => UserAccount.fromJson(item))
          .toList(),
    );
  }
}

class UserAccount {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;
  final String? country;
  final String? userReferralCode;
  final String? status;
  final ReferredBy? referredBy;
  final String? dateCreated;
  final String? activePackage;
  final Wallet? wallet;
  final int? withdrawals;

  UserAccount({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
    this.country,
    this.userReferralCode,
    this.status,
    this.referredBy,
    this.dateCreated,
    this.activePackage,
    this.wallet,
    this.withdrawals,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'],
      email: json['email'],
      country: json['country'],
      userReferralCode: json['user_referral_code'],
      status: json['status'],
      referredBy: json['referred_by'] != null
          ? ReferredBy.fromJson(json['referred_by'])
          : null,
      dateCreated: json['date_created'],
      activePackage: json['active_package'],
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      withdrawals: json['withdrawals'],
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
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}

class Wallet {
  final String id;
  final double balance;

  Wallet({
    required this.id,
    required this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}
