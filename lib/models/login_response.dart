class LoginResponse {
  final String accessToken;
  final int expiresIn;
  final String tokenType;
  final String refreshToken;
  final String jwtToken;

  LoginResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.refreshToken,
    required this.jwtToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    return LoginResponse(
      accessToken: details['access_token'],
      expiresIn: details['expires_in'],
      tokenType: details['token_type'],
      refreshToken: details['refresh_token'],
      jwtToken: details['jwt_token'],
    );
  }
}
