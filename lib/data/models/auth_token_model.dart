class AuthTokenModel {
  AuthTokenModel({
    required this.accessToken,
    required this.tokenType,
  });

  final String accessToken;
  final String tokenType;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json["access_token"] as String,
      tokenType: json["token_type"] as String? ?? "bearer",
    );
  }
}
