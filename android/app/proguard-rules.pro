# Flutter and Android keep rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.FlutterInjector { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep Gson/JSON models if reflection is used
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# OkHttp and WebSocket
-dontwarn okhttp3.**
-dontwarn okio.**

# Dio uses reflection for some types in debug; keep warnings quiet
-dontwarn retrofit2.**

# Security: SSL/TLS classes
-keep class javax.net.ssl.** { *; }
-keep class sun.security.** { *; }
-dontwarn javax.net.ssl.**

# Keep security provider classes
-keep class org.conscrypt.** { *; }
-keep class org.bouncycastle.** { *; }
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**

# Handle Play Core library for SDK 35 compatibility
# These classes are needed by Flutter embedding but not used if deferred components aren't enabled
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# Optimize and obfuscate
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
-optimizationpasses 5

# Remove logging calls in production
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelables
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep Serializable
-keepnames class * implements java.io.Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
