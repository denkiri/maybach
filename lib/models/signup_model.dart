// models/signup_model.dart
class SignupModel {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String country;
  final String password;
  final String confirmPassword;
  final String referralCode;

  SignupModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.password,
    required this.confirmPassword,
    required this.referralCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone_number": phoneNumber,
      "country": country,
      "password": password,
      "confirm_password": confirmPassword,
      "referral_code": referralCode,
    };
  }
}
