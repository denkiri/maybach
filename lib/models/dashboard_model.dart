class DashboardModel {
  final Details details;

  DashboardModel({required this.details});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      details: Details.fromJson(json['details']),
    );
  }
}

class Details {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final Wallet wallet;
  final ActivePackage? activePackage;
  final PromoCode promoCode;
  final double userDeposit;
  final WhatsappEarnings whatsappEarnings;
  final int withdrawals;
  final double cashbackBonus;
  final LatestNotification? latestNotification;
  final List<TopEarner> topEarners;  // Added top_earners field

  Details({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.wallet,
    required this.activePackage,
    required this.promoCode,
    required this.userDeposit,
    required this.whatsappEarnings,
    required this.withdrawals,
    required this.cashbackBonus,
    required this.latestNotification,
    required this.topEarners,  // Initialize topEarners
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    var topEarnersList = json['top_earners'] != null
        ? (json['top_earners'] as List).map((i) => TopEarner.fromJson(i)).toList()
        : <TopEarner>[];

    return Details(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      wallet: Wallet.fromJson(json['wallet']),
      activePackage: json['active_package'] != null && json['active_package'].isNotEmpty
          ? ActivePackage.fromJson(json['active_package'])
          : null,
      promoCode: PromoCode.fromJson(json['promo_code']),
      userDeposit: json['user_deposit']?.toDouble() ?? 0.0,
      whatsappEarnings: WhatsappEarnings.fromJson(json['whatsapp_earnings']),
      withdrawals: json['withdrawals'] ?? 0,
      cashbackBonus: json['cashback_bonus']?.toDouble() ?? 0.0,
      latestNotification: json['latest_notification'] != null
          ? LatestNotification.fromJson(json['latest_notification'])
          : null,
      topEarners: topEarnersList,  // Assign the top earners list
    );
  }
}

class TopEarner {
  final String user;
  final String totalEarnings;

  TopEarner({required this.user, required this.totalEarnings});

  factory TopEarner.fromJson(Map<String, dynamic> json) {
    return TopEarner(
      user: json['user'],
      totalEarnings: json['total_earnings'],
    );
  }
}

class Wallet {
  final String id;
  final double balance;

  Wallet({required this.id, required this.balance});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      balance: json['balance']?.toDouble() ?? 0.0,
    );
  }
}

class ActivePackage {
  final String id;
  final String name;
  final double price;

  ActivePackage({required this.id, required this.name, required this.price});

  factory ActivePackage.fromJson(Map<String, dynamic> json) {
    return ActivePackage(
      id: json['id'],
      name: json['name'],
      price: json['price']?.toDouble() ?? 0.0,
    );
  }
}

class PromoCode {
  final String referralCode;
  final String referredBy;

  PromoCode({required this.referralCode, required this.referredBy});

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      referralCode: json['referral_code'],
      referredBy: json['referred_by'],
    );
  }
}

class WhatsappEarnings {
  final double totalWithdrawals;
  final double balance;

  WhatsappEarnings({required this.totalWithdrawals, required this.balance});

  factory WhatsappEarnings.fromJson(Map<String, dynamic> json) {
    return WhatsappEarnings(
      totalWithdrawals: json['total_withdrawals']?.toDouble() ?? 0.0,
      balance: json['balance']?.toDouble() ?? 0.0,
    );
  }
}

class LatestNotification {
  final String id;
  final String message;
  final String dateCreated;

  LatestNotification({required this.id, required this.message, required this.dateCreated});

  factory LatestNotification.fromJson(Map<String, dynamic> json) {
    return LatestNotification(
      id: json['id'],
      message: json['message'],
      dateCreated: json['date_created'],
    );
  }
}
