class AuthTokenModel {
  AuthTokenModel({
    required this.accessToken,
    this.refreshToken,
    required this.tokenType,
  });

  final String accessToken;
  final String? refreshToken;
  final String tokenType;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json["access_token"] as String,
      refreshToken: json["refresh_token"] as String?,
      tokenType: json["token_type"] as String? ?? "bearer",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": accessToken,
      if (refreshToken != null) "refresh_token": refreshToken,
      "token_type": tokenType,
    };
  }
}
