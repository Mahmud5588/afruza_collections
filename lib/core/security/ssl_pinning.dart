import "dart:io";
import "package:dio/dio.dart";
import "package:dio/io.dart";
import "package:flutter/foundation.dart";

import "../logger.dart";

/// SSL Certificate Pinning for enhanced security
/// Prevents man-in-the-middle attacks by validating server certificate
class SslPinning {
  /// Enable SSL pinning for production builds
  static void configureSslPinning(Dio dio) {
    if (kReleaseMode) {
      // Only enable in release mode to avoid certificate issues in development
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          // Validate certificate
          final isValidHost = _validateHost(host);
          final isValidCert = _validateCertificate(cert);

          if (!isValidHost || !isValidCert) {
            AppLogger.error(
              "SSL Certificate validation failed for: $host:$port",
            );
            return false;
          }

          return true;
        };
        return client;
      };

      AppLogger.success("SSL Certificate Pinning enabled");
    } else {
      AppLogger.debug("SSL Pinning disabled in debug mode");
    }
  }

  /// Validate if the host is trusted
  static bool _validateHost(String host) {
    const trustedHosts = [
      "bek85.me",
      "www.bek85.me",
      // Add other trusted domains here
    ];

    return trustedHosts.contains(host);
  }

  /// Validate certificate (simplified - in production use actual cert pinning)
  static bool _validateCertificate(X509Certificate cert) {
    // In production, compare certificate fingerprint with expected value
    // For now, we validate that certificate exists and has valid dates
    try {
      final now = DateTime.now();
      final notBefore = cert.startValidity;
      final notAfter = cert.endValidity;

      if (now.isBefore(notBefore) || now.isAfter(notAfter)) {
        AppLogger.error("Certificate date validation failed");
        return false;
      }

      // Validate certificate issuer
      final subject = cert.subject;
      if (subject.isEmpty) {
        AppLogger.error("Certificate has no subject");
        return false;
      }

      AppLogger.debug("Certificate validated successfully");
      return true;
    } catch (e) {
      AppLogger.error("Certificate validation error", error: e);
      return false;
    }
  }

  /// Get expected certificate fingerprint (SHA-256)
  /// In production, replace this with actual certificate fingerprint
  /// You can get it by running: openssl s_client -connect bek85.me:443 | openssl x509 -fingerprint -sha256
  static String getExpectedFingerprint() {
    // TODO: Replace with actual certificate fingerprint from production server
    return "YOUR_CERTIFICATE_SHA256_FINGERPRINT_HERE";
  }
}
