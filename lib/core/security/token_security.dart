import "package:flutter/foundation.dart";
import "package:crypto/crypto.dart";
import "dart:convert";

import "../logger.dart";

/// Token Security Manager
/// Handles token validation, expiry, and secure operations
class TokenSecurity {
  /// Validate token format
  static bool isValidTokenFormat(String token) {
    // JWT token has 3 parts separated by dots
    final parts = token.split(".");
    if (parts.length != 3) {
      AppLogger.warning("Invalid token format - not a JWT");
      return false;
    }

    // Each part should be base64 encoded
    for (final part in parts) {
      if (part.isEmpty) {
        AppLogger.warning("Invalid token - empty part");
        return false;
      }
    }

    return true;
  }

  /// Hash sensitive data before logging (if absolutely necessary)
  static String hashSensitiveData(String data) {
    if (kReleaseMode) {
      // In production, hash sensitive data
      final bytes = utf8.encode(data);
      final hash = sha256.convert(bytes);
      return hash.toString().substring(0, 8) + "...";
    }
    // In debug, show first few characters
    return data.length > 10 ? "${data.substring(0, 10)}..." : "***";
  }

  /// Sanitize token for logging
  static String sanitizeTokenForLog(String token) {
    if (kReleaseMode) {
      return "[REDACTED]";
    }
    // In debug mode, show only first/last few characters
    if (token.length < 20) return "***";
    return "${token.substring(0, 4)}...${token.substring(token.length - 4)}";
  }

  /// Check if token is expired based on issued time
  static bool isTokenExpired(DateTime issuedAt, Duration maxAge) {
    final now = DateTime.now();
    final expiryTime = issuedAt.add(maxAge);
    return now.isAfter(expiryTime);
  }

  /// Generate a secure random state for OAuth/PKCE flows
  static String generateSecureState() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = DateTime.now().microsecondsSinceEpoch.toString();
    final combined = "$timestamp-$random";
    return sha256.convert(utf8.encode(combined)).toString();
  }

  /// Validate refresh token before use
  static bool validateRefreshToken(String? refreshToken) {
    if (refreshToken == null || refreshToken.isEmpty) {
      AppLogger.warning("Refresh token is null or empty");
      return false;
    }

    if (!isValidTokenFormat(refreshToken)) {
      AppLogger.warning("Invalid refresh token format");
      return false;
    }

    return true;
  }

  /// Calculate token expiry warning threshold
  /// Returns true if token will expire soon (within 10% of its lifetime)
  static bool shouldRefreshToken(DateTime issuedAt, Duration maxAge) {
    final now = DateTime.now();
    final expiryTime = issuedAt.add(maxAge);
    final timeUntilExpiry = expiryTime.difference(now);
    final warningThreshold = maxAge * 0.1; // 10% of total lifetime

    return timeUntilExpiry < warningThreshold;
  }
}
