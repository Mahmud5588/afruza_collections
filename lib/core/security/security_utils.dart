import "package:flutter/foundation.dart";
import "dart:io";

import "../logger.dart";

/// Security Utilities
/// Additional security checks and validations
class SecurityUtils {
  /// Check if app is running on rooted/jailbroken device
  /// Note: This is a basic check. For production, use packages like:
  /// - flutter_jailbreak_detection
  /// - safe_device
  static Future<bool> isDeviceSecure() async {
    if (kReleaseMode) {
      // Basic checks - in production use dedicated package
      try {
        if (Platform.isAndroid) {
          return await _checkAndroidRootedDevice();
        } else if (Platform.isIOS) {
          return await _checkIOSJailbreak();
        }
      } catch (e) {
        AppLogger.error("Device security check failed", error: e);
        return true; // Assume secure if check fails
      }
    }
    return true; // Always true in debug mode
  }

  static Future<bool> _checkAndroidRootedDevice() async {
    // Basic check - not comprehensive
    // In production, use a dedicated package
    final suspiciousFiles = [
      "/system/app/Superuser.apk",
      "/sbin/su",
      "/system/bin/su",
      "/system/xbin/su",
      "/data/local/xbin/su",
      "/data/local/bin/su",
      "/system/sd/xbin/su",
      "/system/bin/failsafe/su",
      "/data/local/su",
    ];

    for (final path in suspiciousFiles) {
      if (await File(path).exists()) {
        AppLogger.warning("Potential root detected: $path");
        return false;
      }
    }

    return true;
  }

  static Future<bool> _checkIOSJailbreak() async {
    // Basic check for jailbreak - not comprehensive
    final suspiciousFiles = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt",
      "/private/var/lib/apt/",
    ];

    for (final path in suspiciousFiles) {
      if (await File(path).exists()) {
        AppLogger.warning("Potential jailbreak detected: $path");
        return false;
      }
    }

    return true;
  }

  /// Validate user input to prevent injection attacks
  static String sanitizeInput(String input) {
    // Remove potentially dangerous characters
    return input
        .replaceAll(RegExp(r"[<>\"']"), "")
        .replaceAll(RegExp(r"[\r\n]"), "")
        .trim();
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  static bool isStrongPassword(String password) {
    // At least 8 characters, with letters and numbers
    if (password.length < 8) return false;

    final hasLetter = RegExp(r"[a-zA-Z]").hasMatch(password);
    final hasNumber = RegExp(r"[0-9]").hasMatch(password);

    return hasLetter && hasNumber;
  }

  /// Check if app is in debug mode
  static bool isDebugMode() {
    return kDebugMode;
  }

  /// Check if app is in release mode
  static bool isReleaseMode() {
    return kReleaseMode;
  }

  /// Get device security status message
  static Future<String> getSecurityStatus() async {
    final isSecure = await isDeviceSecure();
    if (!isSecure) {
      return "⚠️ Diqqat: Qurilma xavfsizligi buzilgan bo'lishi mumkin";
    }
    return "✅ Qurilma xavfsiz";
  }
}
